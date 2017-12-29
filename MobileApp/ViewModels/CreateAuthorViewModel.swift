//
//  CreateAuthorViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 29/12/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class CreateAuthorViewModel: NSObject
{
    @IBOutlet var apiClient: ApiClient!
    var author: Author?
    var message:String?
    
    func CreateAuthor(firstName:String,lastName:String,completion: @escaping (Bool)->Void)
    {
        apiClient.CreateAuthor(firstName: firstName, lastName: lastName) { (author, ok, message) in
            DispatchQueue.main.async {
                if ok{
                    self.author=author
                    completion(true)
                }
                else{
                    self.message=message
                    completion(false)
                }
            }
        }
    }
}
