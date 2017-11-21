//
//  CreateBookViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 21/11/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class CreateBookViewModel : NSObject {
    var book: Book?
    var message: String?
    var authors: [Author]!
    @IBOutlet var apiClient : ApiClient!
    
    func Create(title:String,authorid:UUID,completion: @escaping (Bool)->Void){
        apiClient.CreateBook(title: title, authorid: authorid) { (book, success, message) in
            DispatchQueue.main.async {
                self.book=book
                self.message=message
                completion(success)
            }
        }
    }
    
    func FindAuthors(completion: @escaping () -> Void){
        apiClient.GetAllAuthors { (authors) in
            DispatchQueue.main.async {
                self.authors=authors
                completion()
            }
        }
    }
    
    func GetAuthorDataForPicker() -> [(UUID,String)]
    {
        return authors.map{value in
            (value.Id,value.FirstName + " " + value.LastName)
        }
    }
}
