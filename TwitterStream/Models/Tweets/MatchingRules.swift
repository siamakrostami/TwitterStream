//
//  MatchingRules.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import Foundation
//MARK: - MatchingRules Struct
struct MatchingRules : Codable{
    var id : String?
    var tag : String?
    //CodingKeys for json
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tag = "tag"
    }
    
}
