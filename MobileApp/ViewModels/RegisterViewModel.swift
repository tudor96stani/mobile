//
//  RegisterViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class RegisterViewModel : NSObject
{
    var user: User?
    var errorMessage: String?
    @IBOutlet var apiCLient : ApiClient!
    
    func RegisterUser(username: String,password: String, role: Int, completion: @escaping (Bool)-> Void)
    {
        apiCLient.Register(username: username, password: password, role: role) {
            (user,message,success) in
            DispatchQueue.main.async {
                self.user=user;
                self.errorMessage=message
                completion(success)
            }
        }
    }
}
