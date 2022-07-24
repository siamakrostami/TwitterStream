//
//  TwitterHelper.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/20/22.
//

import Foundation
import UIKit

class TwitterHelper{
    //open user twitter profile
    class func openTwitterProfile(with username : String){
        guard let appURL = URL(string: "twitter:///user?screen_name=\(username)") else {return}
        guard let webURL = URL(string: "https://twitter.com/\(username)") else {return}
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL as URL)
        } else {
            UIApplication.shared.open(webURL)
        }
    }
    //search for hashtag
    class func openTwitterSearch(for hashtag : String){
        guard let hashTagQuery = hashtag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let appURL = URL(string: "twitter://search?query=\(hashTagQuery)") else {return}
        guard let webURL = URL(string: "https://twitter.com/search?q=\(hashTagQuery)") else {return}
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL as URL)
        } else {
            UIApplication.shared.open(webURL)
        }
    }
    //open url
    class func openTwittterUrl(url : URL){
        UIApplication.shared.open(url)
    }
}
