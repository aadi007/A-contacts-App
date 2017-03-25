//
//  ContactsViewModel.swift
//  Contacts App
//
//  Created by Aadesh Maheshwari on 25/03/17.
//  Copyright © 2017 Aadi's World. All rights reserved.
//

import UIKit
import Alamofire

class ContactsViewModel: NSObject {
    
    weak var delegate: HomeViewController!
    
    init(sender: HomeViewController) {
        self.delegate = sender
    }
    
    // calls the Api call to get all the Contacts and returns back to sender
    func getAllContacts() {
        Alamofire.request(Router.contactsRouterManager(ContactsRouter.getAllContacts()))
            .debugLog()
            .validate()
            .responseJSON {
                (response) in
//                if response.result.isFailure {
//                    handleError(response,
//                                successHandler:{
//                                    res in
//                                    successCompletionHandler(res: res)
//                    },
//                                errorhandler:{
//                                    errorCompletionHandler()
//                    })
//                } else {
//                    successCompletionHandler(res: response)
//                }
                print("\(response)")
        }
    }
}
