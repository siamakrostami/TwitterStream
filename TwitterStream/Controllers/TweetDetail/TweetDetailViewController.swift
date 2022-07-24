//
//  TweetDetailViewController.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/20/22.
//

import UIKit
import ActiveLabel

//MARK: - Class Dedinition
class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: ActiveLabel!{
        didSet{
            usernameLabel.enabledTypes = [.mention]
        }
    }
    @IBOutlet weak var tweetTextLabel: ActiveLabel!{
        didSet{
            tweetTextLabel.enabledTypes = [.hashtag,.mention,.url]
        }
    }
    @IBOutlet weak var createdAtLabel: UILabel!
    
    private var tweetViewModel : TweetViewModel!
    private var tweetObject: TweetObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleTapOnAttributedValues()
        // Do any additional setup after loading the view.
    }

}
//MARK: - Implement Functions
extension TweetDetailViewController {
    //Handle tap on mention,hashtag or url
    private func handleTapOnAttributedValues(){
        self.usernameLabel.handleMentionTap { mention in
            TwitterHelper.openTwitterProfile(with: mention)
        }
        self.tweetTextLabel.handleMentionTap { username in
            TwitterHelper.openTwitterProfile(with: username)
        }
        self.tweetTextLabel.handleHashtagTap { hashtag in
            let hashtagedString = "#\(hashtag)"
            TwitterHelper.openTwitterSearch(for: hashtagedString)
        }
        self.tweetTextLabel.handleURLTap { url in
            TwitterHelper.openTwittterUrl(url: url)
        }
    }
    // set tweet data to view
    private func setData(){
        DispatchQueue.main.async {
            self.nameLabel.text = self.tweetObject.includes?.users?.first?.name
            self.usernameLabel.text = "@\(self.tweetObject.includes?.users?.first?.username ?? "Username")"
            self.tweetTextLabel.text = self.tweetObject.data?.text
            self.createdAtLabel.text = self.tweetObject.data?.createdAt
        }
    }
    //create viewController with dependencies
    static func buildViewController(viewModel : TweetViewModel , tweetObject : TweetObject) -> UIViewController?{
        let viewController = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "TweetDetailViewController") as? TweetDetailViewController
        viewController?.tweetViewModel = viewModel
        viewController?.tweetObject = tweetObject
        viewController?.setData()
        return viewController
    }
    
}
