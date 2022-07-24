//
//  TwitterNetworkRepository.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/18/22.
//

import Foundation

//MARK: - Typealias
typealias RuleCompletion = ((Result<Rule?,ClientError>) -> Void)
typealias TweetCompletion = ((Result<TweetObject?,ClientError>) -> Void)

//MARK: - Repository Protocols
protocol TwitterRepositoryProtocols {
    func setRule(rule : String , completion : @escaping RuleCompletion)
    func getRule(completion : @escaping RuleCompletion)
    func deleteRule(ruleIds : [String] , completion : @escaping RuleCompletion)
    func streamFilteredData(completion : @escaping TweetCompletion)
    func cancelRequests()
}

struct TwitterNetworkRepository{
    
    private let client : APIClient
    
    init(client : APIClient = APIClient()){
        self.client = client
    }

}

//MARK: - Protocols impl
extension TwitterNetworkRepository : TwitterRepositoryProtocols {
    func cancelRequests() {
        self.client.cancelAllRequests()
    }
    
    func setRule(rule: String, completion: @escaping RuleCompletion) {
        self.client.streamRequest(Router.setRule(rule: rule), result: completion)
    }
    
    func getRule(completion: @escaping RuleCompletion) {
        self.client.streamRequest(Router.getRule, result: completion)
    }
    
    func deleteRule(ruleIds: [String], completion: @escaping RuleCompletion) {
        self.client.streamRequest(Router.deleteRule(ruleIds : ruleIds), result: completion)
    }
    
    func streamFilteredData(completion : @escaping TweetCompletion) {
        self.client.streamRequest(Router.streamFilter, result: completion)
    }
    
}

//MARK: - Set Router's Data
extension TwitterNetworkRepository{
    
    enum Router : NetworkRouter {
        case setRule(rule : String)
        case getRule
        case deleteRule(ruleIds : [String])
        case streamFilter
        
        func generateSetRuleDictionary(rule : String) -> Dictionary<String,Any> {
            var mainDictionary = Dictionary<String,Any>()
            var valueDictionary = Dictionary<String,Any>()
            var dictArray = [Dictionary<String,Any>]()
            valueDictionary.updateValue(rule, forKey: "value")
            dictArray.append(valueDictionary)
            mainDictionary.updateValue(dictArray, forKey: "add")
            return mainDictionary
        }
        
        func generateDeleteRuleDictionary(ids : [String]) -> Dictionary<String,Any> {
            var mainDictionary = Dictionary<String,Any>()
            var valueDictionary = Dictionary<String,Any>()
            valueDictionary.updateValue(ids, forKey: "ids")
            mainDictionary.updateValue(valueDictionary, forKey: "delete")
            return mainDictionary
        }
        
        var method : RequestMethod?{
            switch self{
            case .setRule , .deleteRule:
                return .post
            case .getRule, .streamFilter:
                return .get
            }
        }
        
        var params: [String : Any]? {
            switch self {
            case .setRule(let rule):
                return self.generateSetRuleDictionary(rule: rule)
            case .getRule:
                return nil
            case .deleteRule(let ruleIds):
                return self.generateDeleteRuleDictionary(ids: ruleIds)
            case .streamFilter:
                return nil
            }
        }
        
        var path: String{
            switch self {
            case .setRule(_) , .getRule , .deleteRule(_):
                return "tweets/search/stream/rules"
            default:
                return "tweets/search/stream?tweet.fields=created_at&expansions=author_id&user.fields=created_at"
            }
        }
        
        var headers: [String : String]?{
            switch self {
            case .setRule(_) , .deleteRule(_):
                return ["Authorization" : "Bearer \(PlistHelper.bearerToken)" , "Content-type": "application/json"]
            default:
                return ["Authorization" : "Bearer \(PlistHelper.bearerToken)"]
            }
            
        }
        
    }
    

    
}
