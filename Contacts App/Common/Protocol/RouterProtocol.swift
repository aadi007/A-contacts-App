//
//  RouterProtocol.swift
//  Created by Aadesh Maheshwari on 21/01/16.
//  Copyright © 2016 Tailored Tech. All rights reserved.
//

import Foundation
import Alamofire

protocol RouterProtocol {
    
    var path: String { get }
    
    var method: Alamofire.HTTPMethod { get }
    
    var parameters: APIRequestBody? { get }
    
    var  body: APIRequestBody? { get }
}

protocol RouterProtocolAPI {
    
    var path: String { get }
    
    var method: Alamofire.HTTPMethod { get }
    
    var parameters: APIRequestBody? { get }
    
    var  body: APIRequestBody? { get }
}
