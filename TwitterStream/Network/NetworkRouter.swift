//
//  NetworkRouter.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/16/22.
//

import Foundation
import Alamofire

//MARK: - Enum Request Methods
enum RequestMethod: String {
    case get, post, put, patch, trace, delete
}

//MARK: - Network Router Protocols
protocol NetworkRouter: URLRequestConvertible {
    var baseURLString: String { get }
    var method: RequestMethod? { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    func asURLRequest() throws -> URLRequest
}

//MARK: - Network Router Protocols impl
extension NetworkRouter {
    //    typealias ResultRouter<T: Codable> = Result<T, Error>
    
    var baseURLString: String {
        return PlistHelper.baseUrl
    }
    
    // Add Rout method here
    var method: RequestMethod? {
        return .post
    }
    
    // Set APIs'Rout for each case
    var path: String {
        return ""
    }
    
    // Set header here
    var headers: [String: String]? {
        return [:]
    }
    
    // Set encoding for each APIs
    var encoding: ParameterEncoding? {
        return JSONEncoding.default
    }
    
    
    // Return each case parameters
    var params: [String: Any]? {
        return [:]
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLString.appending(path))
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method?.rawValue.uppercased()
        urlRequest.allHTTPHeaderFields = headers
        if method == .get {
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: params)
        } else {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params ?? [:], options: .prettyPrinted)
        }
        
        return urlRequest
    }
}

