//
//  TweetData.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import Foundation
//MARK: - TweetData Struct
struct TweetData : Codable{
    var authorID : String?
    var createdAt : String?
    var id : String?
    var text: String?
    //CodingKey for json
    enum CodingKeys: String, CodingKey {
        case authorID = "author_id"
        case createdAt = "created_at"
        case id, text
    }
}
