//
//  LoginViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 31/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class LoginViewModel: NSObject {
    var user: User?
    var errorMessage: String?
    @IBOutlet var apiCLient : ApiClient!
    
    func Login(username: String,password:String, completion: @escaping (Bool) -> Void){
        apiCLient.Login(username: username, password: password) { (user, message, success) in
            DispatchQueue.main.async {
                self.user=user;
                self.errorMessage=message
                completion(success)
            }
        }
    }
}
