//
//  Router.swift
//
//  Created by Aadesh Maheshwari on 25/03/17.
//  Copyright © 2017 Aadesh Maheshwari. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

/**
 *  Base router which has list of all the router that will be used to make network call
 *  throughout the app.
 */
enum Router: URLRequestConvertible {
    
    // Custom variable defined in build.
    static let baseURLString = ContactsHelper.apiBaseUrl
    
    case contactsRouterManager(ContactsRouter)
    
    func asURLRequest() throws -> URLRequest {
        switch self {
            case .contactsRouterManager(let requset):
                let urlRequest = try configureRequest(requset)
                return urlRequest
        }
    }
    
    /**
     Configure app level request object.
     - Set request path
     - Set request method
     - Set Headers [Authorization, Accept, Content-Type]
     - Set request body
     - set request parameters
     
     - parameter requestObj: Router of type RouterProtocol
     
     - returns: NSMutableURLRequest object
     */
    func configureRequest(_ requestObj: RouterProtocol) throws -> URLRequest {
        
        print(Router.baseURLString)
        
        let url = URL(string: Router.baseURLString)!
        
        var mutableURLRequest = URLRequest(url: url.appendingPathComponent(requestObj.path)) // Set request path
        mutableURLRequest.httpMethod = requestObj.method.rawValue // Set request method
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField:"Accept")
        mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        mutableURLRequest.setValue("IPhone", forHTTPHeaderField:"User-Agent")
        
        if requestObj.method == Alamofire.HTTPMethod.post || requestObj.method == Alamofire.HTTPMethod.delete {
            // Request type is post/put -> check for request body
            if let body: APIRequestBody = requestObj.body {
                do {
                    mutableURLRequest.httpBody = try JSONSerialization.data(withJSONObject: Mapper().toJSON(body), options: JSONSerialization.WritingOptions())
                } catch {
                    // No-op
                }
            }
        }
        
        // Check if request has parameters defined
        if let parameters: APIRequestBody = requestObj.parameters {
            print("\(Mapper().toJSON(parameters))")
            return try Alamofire.URLEncoding.default.encode(mutableURLRequest, with: Mapper().toJSON(parameters))
            
        } else {
            return mutableURLRequest
        }
    }
}

// MARK: - Alamofire request extension
//  - Add debugLog method which logs request
extension Request {
    public func debugLog() -> Self {
        
        print("===============")
        print(self)
        print("Headers ---> ")
        print(self.request!.allHTTPHeaderFields!)
        print("Body ---> ")
        if let requestBody = self.request!.httpBody {
            print(NSString(data: requestBody, encoding: String.Encoding.utf8.rawValue)!)
        }
        print("===============")
        
        return self
    }
}
