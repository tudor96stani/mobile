//
//  ApiClient.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiClient :NSObject{
    
    func FetchBooks(UserId:String, completion: @escaping ([Book]?)->Void)
    {
        Alamofire.request(Constants.UserBooksURL+UserId).validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    var books = Array<Book>()
                    for(_,subJson):(String,JSON) in json
                    {
                        books.append(Book(json:subJson))
                    }
                    completion(books)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func Register(username: String,password:String,role:Int, completion: @escaping (User?,String?,Bool)->Void)
    {
        let parameters: Parameters = [
            "Username":username,
            "Password":password,
            "Role":role
        ]
        Alamofire.request(Constants.RegisterURL,method:.post,parameters:parameters).validate()
            .responseJSON { (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    let OK = json["Ok"].boolValue
                    if OK{
                        //Registration successful
                        let user = User(json: json["User"])
                        completion(user,nil,true)
                    }
                    else{
                        //Registration was not successful because the server rejected the User (existing username, etc)
                        let message = json["Message"].stringValue
                        completion(nil,message,false)
                    }
                case .failure( _):
                    completion(nil,"Server error",false)
                }
        }
    }
    
    func GetAllAuthors(completion: @escaping ([Author]?) -> Void)
    {        
        Alamofire.request(Constants.AllAuthorsURL).validate()
            .responseJSON { (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    var authors = [Author]()
                    for(_,subJson):(String,JSON) in json
                    {
                        authors.append(Author(json: subJson))
                    }
                    completion(authors)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func UpdateBook(id: UUID,title:String,authorid:UUID, completion: @escaping (Book?) -> Void)
    {
            //make the call to the api
            //completion(nil)
        let parameters: Parameters = [
            "Id":id.uuidString,
            "Title":title,
            "AuthorId":authorid.uuidString
        ]
        Alamofire.request(Constants.UpdateBookURL,method:.post,parameters: parameters).validate()
            .responseJSON { (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    let book = Book(json: json)
                    completion(book)
                case .failure( _):
                    completion(nil)
                }
        }
    }
}

