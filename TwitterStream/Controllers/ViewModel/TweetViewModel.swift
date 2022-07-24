//
//  TweetViewModel.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import Foundation
import Combine
//MARK: - ViewModel Protocols
protocol TweetViewModelProtocols{
    func getRules()
    func setRules()
    func deleteRules()
    func streamTweets()
    func cancelNetworkRequest()
}
//MARK: - ViewModel
class TweetViewModel {
    
    private var network : TwitterNetworkRepository
    var ruleObject : Rule?
    var tweets = CurrentValueSubject<[TweetObject]?,Never>(nil)
    var error = CurrentValueSubject<ClientError?,Never>(nil)
    var ruleIsDeleted = CurrentValueSubject<Bool?,Never>(nil)
    var tweetsArray = [TweetObject]()
    var ruleName = CurrentValueSubject<String,Never>("")
    var disposeBag : Set<AnyCancellable> = []
    
    init(network : TwitterNetworkRepository = TwitterNetworkRepository()){
        self.network = network
        self.getRules()
    }
    
}
//MARK: - Implement ViewModel Protcols
extension TweetViewModel : TweetViewModelProtocols {
    //cancel network requests
    func cancelNetworkRequest() {
        self.network.cancelRequests()
    }
    //fetch current rule from twitter api
    func getRules() {
        self.network.getRule { [weak self] ruleResult in
            guard let `self` = self else {return}
            switch ruleResult{
            case .success(let rule):
                self.ruleObject = rule
                self.handleRuleStatus()
            case .failure(let error):
                self.error.send(error)
            }
        }
    }
    //handle current rule state for setting a new one or fetch stream data
    private func handleRuleStatus(){
        guard let rule = self.ruleObject , let data = rule.data , !data.isEmpty else {
            self.ruleName.send("tehran")
            self.setRules()
            return
        }
        self.ruleName.send(data.first?.value ?? "tehran")
        self.streamTweets()
    }
    //set new rule to twitter api for filter streaming
    func setRules() {
        self.network.setRule(rule:self.ruleName.value) { [weak self] ruleResult in
            guard let `self` = self else {return}
            switch ruleResult{
            case .success(let rule):
                self.ruleObject = rule
                self.tweetsArray.removeAll()
                self.tweets.send(nil)
                self.streamTweets()
            case .failure(let error):
                self.error.send(error)
            }
        }
    }
    //delete current rule to set a new one
    func deleteRules() {
        guard let rule = self.ruleObject , let datas = rule.data else {return}
        let ids = datas.compactMap{$0.id}
        self.network.deleteRule(ruleIds: ids) { [weak self] deleteResult in
            guard let `self` = self else {return}
            switch deleteResult{
            case .success(let rule):
                self.ruleObject = rule
                self.ruleIsDeleted.send(true)
            case .failure(let error):
                self.error.send(error)
                self.ruleIsDeleted.send(false)
            }
        }
    }
    //stream live tweets with defined rule
    func streamTweets() {
        self.network.streamFilteredData { [weak self] streamData in
            guard let `self` = self else {return}
            switch streamData{
            case .success(let tweet):
                guard let tweet = tweet else {return}
                self.tweetsArray.insert(tweet, at: 0)
                self.tweets.send(self.tweetsArray)
            case .failure(let error):
                self.error.send(error)
            }
        }
    }
}
