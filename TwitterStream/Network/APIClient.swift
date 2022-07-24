//
//  APIClient.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/16/22.
//

import Foundation
import Alamofire

//MARK: - Networking Protocols
protocol APIClientProtocols {
    func streamRequest<T>(_ endpoint: URLRequestConvertible, result: @escaping (Result<T, ClientError>) -> Void) where T: Decodable, T: Encodable
    func cancelAllRequests()
}

//MARK: - Class Definition
class APIClient {
    private let sessionManager: Session
    private let decoder: JSONDecoder
    required init(session: Session = Session()) {
        self.sessionManager = session
        self.decoder = JSONDecoder()
    }
    
}

//MARK: - Protocol Impl
extension APIClient : APIClientProtocols {
    //cancel all requests
    func cancelAllRequests() {
        self.sessionManager.cancelAllRequests()
    }
    
    // request stream
    func streamRequest<T : Codable>(_ endpoint: URLRequestConvertible, result: @escaping (Result<T, ClientError>) -> Void)  {
        guard let urlRequest = try? endpoint.asURLRequest() else {
            result(.failure(.invalidRequest))
            return
        }
        let request = sessionManager.streamRequest(urlRequest)
        request
            .validate()
            .responseStream { stream in
                switch stream.event{
                case .stream(let streamResult):
                    switch streamResult{
                    case .success(let streamData):
                        do{
                            let finalData = try self.decoder.decode(T.self, from: streamData)
                            debugPrint(streamData.debugDescription)
                            result(.success(finalData))
                            
                        }catch{
                            debugPrint("parse failed")
                        }
                        
                    case .failure(let error):
                        let finalError = ClientError(rawValue: error.asAFError?.responseCode ?? 1002)
                        result(.failure(finalError ?? .unknown))
                    }
                case .complete(_):
                    debugPrint("completed stream")
                    break
                }
            }
    }
}
