//
//  PlistHelper.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/16/22.
//

import Foundation
//MARK: - Plist Helper Class
class PlistHelper : Bundle{
    //get base url from bundle
    static var baseUrl : String{
        return Bundle.main.infoDictionary?["BaseUrl"] as? String ?? ""
    }
    //get bearer token from bundle
    static var bearerToken : String{
        return Bundle.main.infoDictionary?["BearerToken"] as? String ?? ""
    }
    
}
