//
//  TweetObject.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import Foundation

//MARK: - Main tweet object
struct TweetObject: Codable {
    var data: TweetData?
    var includes: Includes?
    var matchingRules: [MatchingRules]?
    //CodingKeys for json
    enum CodingKeys: String, CodingKey {
        case data
        case includes = "includes"
        case matchingRules = "matching_rules"
    }
}
