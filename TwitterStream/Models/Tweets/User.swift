//
//  User.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import Foundation

//MARK: - User Struct
struct User : Codable{
    var createdAt : String?
    var id : String?
    var name : String?
    var username : String?
    //CodingKey for json
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, name, username
    }
}
