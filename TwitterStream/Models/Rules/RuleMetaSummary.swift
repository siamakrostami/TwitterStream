//
//  RoleMetaSummary.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/18/22.
//

import Foundation
//MARK: - RuleMetaSummary Struct
struct RuleMetaSummary : Codable {
    var created : Int?
    var notCreated : Int?
    var valid : Int?
    var invalid : Int?
    //CodingKeys for json
    enum CodingKeys : String , CodingKey {
        case created , valid , invalid
        case notCreated = "not_created"
    }
}
