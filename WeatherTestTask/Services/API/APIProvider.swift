//
//  APIProvider.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import class Alamofire.SessionManager
import Foundation
import Result
import Moya

//MARK: Completion and result for callback closure
typealias APIResult = Result<Response, APIError>
typealias APICompletion = (_ result: Result<Response, APIError>) -> Void

class APIManager {
    static let weather = APIProvider<APIWeather>()
    
}

//MARK: APIProvider for APITarget
class APIProvider<T: TargetType> {
    
    //Basic provider
    private let provider = MoyaProvider<T>(
        endpointClosure: { (provider: T) -> Endpoint in
            return APIProvider.requestEndpoint(target: provider) },
        manager: Alamofire.SessionManager(configuration: {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            configuration.requestCachePolicy = .useProtocolCachePolicy
            return configuration }()),
        plugins: [NetworkLoggerPlugin(verbose: true, output: APIProvider.outputFormatter, responseDataFormatter: APIProvider.dataFormatter)]
    )
    
    //Basic request
    public func request(_ target: T, completion: @escaping APICompletion) {
        DispatchQueue.networking.async {
            self.provider.request(target, completion: { (result) in
                DispatchQueue.networking.async {
                    switch result {
                    case let .success(response):
                        switch response.statusCode {
                        case 500..<600:
                            completion(APIResult.init(error: APIError.serverInternalError(reason: nil)))
                        case 400..<500:
                            do {
                                completion(APIResult.init(error: APIError.clientRequestError(reason: try response.mapString())))
                            } catch {
                                completion(APIResult.init(value: response))
                            }
                        case 200..<300:
                            do {
                                completion(APIResult.init(error: APIError.clientRequestError(reason: try response.mapString(atKeyPath: "error"))))
                            } catch {
                                completion(APIResult.init(value: response))
                            }
                        default:
                            completion(APIResult.init(error: APIError.clientInternalError(reason: nil)))
                        }
                    case let .failure(error):
                        completion(APIResult.init(error: APIError.clientInternalError(reason: error.errorDescription)))
                    }
                }
            })
        }
    }
    
    // Request final destination
    private static func requestEndpoint(target: T) -> Endpoint {
        
        let sampleResponseClosure = { return EndpointSampleResponse.networkResponse(200, target.sampleData) }
        let baseURL = target.baseURL.absoluteString
        let pathURL = target.path
        
        let endpoint = Endpoint(url: baseURL + pathURL,
                                   sampleResponseClosure: sampleResponseClosure,
                                   method: target.method,
                                   task: target.task,
                                   httpHeaderFields: target.headers)
        
        return endpoint
    }
    
    private static func outputFormatter(separator: String, terminator: String, items: Any...) {
        DispatchQueue.global(qos: .utility).async {
            for item in items {
                print(item, separator: separator, terminator: terminator)
            }
        }
    }
    
    private static func dataFormatter(data: Data) -> Data {
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return data
        } catch {
            return data
        }
    }
}
