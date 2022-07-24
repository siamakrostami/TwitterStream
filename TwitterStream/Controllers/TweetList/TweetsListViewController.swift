//
//  TweetsListViewController.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import UIKit
//MARK: - Class Definition
class TweetsListViewController: UIViewController {
    
    @IBOutlet weak var textfieldView: UIView!{
        didSet{
            self.textfieldView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var ruleTextfield: UITextField!{
        didSet{
            ruleTextfield.delegate = self
        }
    }
    @IBOutlet weak var tweetsTableView: UITableView!{
        didSet{
            self.tweetsTableView.delegate = self
            self.tweetsTableView.dataSource = self
            self.tweetsTableView.register(UINib(nibName: TweetsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TweetsTableViewCell.identifier)
            self.tweetsTableView.rowHeight = UITableView.automaticDimension
            self.tweetsTableView.estimatedRowHeight = 100
        }
    }
    
    var tweetsViewModel : TweetViewModel!
    private var indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startBinding()
        // Do any additional setup after loading the view.
    }
    
}
//MARK: - Implement ViewController Functions
extension TweetsListViewController {
    //Start binding viewModel variables
    private func startBinding(){
        self.hideKeyboardWhenTappedAround()
        self.initViewModel()
        self.bindErrors()
        self.bindTweets()
        self.bindRuleName()
        self.bindDeletedRules()
        self.setupActivityIndicator()
    }
    //Initialize activityIndicator
    private func setupActivityIndicator(){
        self.indicator.center = self.view.center
        self.view.addSubview(self.indicator)
    }
    //Initialize viewModel
    private func initViewModel(){
        self.tweetsViewModel = TweetViewModel()
    }
    //Bind errors from network
    private func bindErrors(){
        self.tweetsViewModel.error
            .subscribe(on: RunLoop.main)
            .sink { [weak self] error in
                guard let `self` = self else {return}
                guard let error = error else {return}
                let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
            .store(in: &self.tweetsViewModel.disposeBag)
        
    }
    //Bind stream tweets
    private func bindTweets(){
        self.tweetsViewModel.tweets
            .subscribe(on: RunLoop.main)
            .sink { [weak self] tweets in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.tweetsTableView.reloadData()
                }
            }
            .store(in: &self.tweetsViewModel.disposeBag)
        
    }
    //Bind current rule name
    private func bindRuleName(){
        self.tweetsViewModel.ruleName
            .subscribe(on: RunLoop.main)
            .sink { [weak self] rule in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.ruleTextfield.text = rule
                }
            }
            .store(in: &self.tweetsViewModel.disposeBag)
    }
    //Bind deleting current rule
    private func bindDeletedRules(){
        self.tweetsViewModel.ruleIsDeleted
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isDeleted in
                guard let `self` = self else {return}
                guard let isDeleted = isDeleted else {return}
                if isDeleted{
                    self.tweetsViewModel.setRules()
                    DispatchQueue.main.async {
                        self.tweetsTableView.reloadData()
                    }
                }
            }
            .store(in: &self.tweetsViewModel.disposeBag)
    }

    //prepare for search and insert new rule
    private func searchNewRule(text : String?){
        self.tweetsViewModel.cancelNetworkRequest()
        self.tweetsViewModel.ruleName.send(text ?? "")
        self.tweetsViewModel.tweetsArray.removeAll()
        self.tweetsViewModel.tweets.send(nil)
        DispatchQueue.main.async {
            self.tweetsTableView.reloadData()
        }
        self.tweetsViewModel.deleteRules()
    }
    
}
//MARK: - UITableView Datasource & Delegate Implement
extension TweetsListViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.tweetsViewModel.tweets.value != nil , !self.tweetsViewModel.tweets.value!.isEmpty else {
            self.indicator.startAnimating()
            return 0
        }
        self.indicator.stopAnimating()
        return self.tweetsViewModel.tweets.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetsTableViewCell.identifier, for: indexPath) as? TweetsTableViewCell else {return UITableViewCell()}
        guard let data = self.tweetsViewModel.tweets.value , !data.isEmpty else {return UITableViewCell()}
        let currentData = data[indexPath.row]
        cell.setCellData(model: currentData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let data = self.tweetsViewModel.tweets.value else {return 0}
        let currentObject = data[indexPath.row]
        guard let text = currentObject.data?.text else {return 0}
        let height = text.height(withConstrainedWidth: tableView.frame.width, 15)
        return height + 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.tweetsViewModel.tweets.value else {return}
        let currentObject = data[indexPath.row]
        guard let vc = TweetDetailViewController.buildViewController(viewModel: self.tweetsViewModel, tweetObject: currentObject) else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - UITextfieldDelegate Implement
extension TweetsListViewController : UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.searchNewRule(text: textField.text)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.searchNewRule(text: textField.text)
    }
}
