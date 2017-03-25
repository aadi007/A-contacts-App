//
//  ContactsRouter.swift
//  Contacts App
//
//  Created by Aadesh Maheshwari on 25/03/17.
//  Copyright © 2017 Aadi's World. All rights reserved.
//

import UIKit
import Alamofire

enum ContactsRouter: RouterProtocol {
    
    case getAllContacts()
    
    var path : String {
        switch self {
            case .getAllContacts():
                return "/contacts.json"
        }
    }
    
    var method : Alamofire.HTTPMethod {
        switch self {
            default:
                return .get
        }
    }
    
    var parameters : APIRequestBody? {
        switch self {
            default:
                return nil
        }
    }
    
    var body: APIRequestBody? {
        switch self {
            default:
                return nil
        }
    }
}
