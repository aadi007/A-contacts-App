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
        Alamofire.request("https://httpbin.org/post", method: .post)
    }
}
