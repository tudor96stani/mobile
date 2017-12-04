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
import KeychainSwift

class ApiClient : NSObject{
    
    let keychain = KeychainSwift()
    let defaultValues = UserDefaults.standard
    
    
    //MARK: Authentication
    func RefreshTokenIfNecessary(token: String,outercompletion: @escaping () -> Void){
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        Alamofire.request(Constants.RefreshURL,headers:headers).response { (response) in
            switch response.response?.statusCode{
                case 200?:
                    //token still valid
                    outercompletion()
                
                default:
                    //token no longer valid
                    
                    let username = self.keychain.get(KeychainSwift.Keys.Username)!
                    let password = self.keychain.get(KeychainSwift.Keys.Password)!
                    self.Login(username: username, password: password, completion: { (user, message, success) in
                        if success{
                            outercompletion()
                        }
                    })
            }
        }
    }
    
    func Login(username: String,password:String,completion: @escaping (User?,String?,Bool)->Void){
        let parameters: Parameters = [
            "username":username,
            "password":password,
            "grant_type":"password"
        ]
        
        Alamofire.request(Constants.LoginURL,method:.post,parameters:parameters,encoding: URLEncoding.httpBody).validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let user = User(json: json)
                    let access_token = json["access_token"].stringValue
                    self.keychain.set(access_token,forKey:KeychainSwift.Keys.Token)
                    self.keychain.set(username,forKey:KeychainSwift.Keys.Username)
                    self.keychain.set(password,forKey:KeychainSwift.Keys.Password)
                    self.defaultValues.set(json["Id"].stringValue,forKey:UserDefaults.Keys.UserId)
                    self.defaultValues.set(json["Role"].stringValue,forKey: UserDefaults.Keys.Role)
                    completion(user,nil,true)
                case .failure(let error):
                    //completion(nil,nil,false)
                    let message : String
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 400:
                            message = "Username or password not provided."
                        case 401:
                            message = "Incorrect username or password."
                        default:
                            message = "There was an error"
                        }
                    } else {
                        message = error.localizedDescription
                    }
                    completion(nil,message,false)
                }
        }
    }
    
    func Register(username: String,password:String,role:Int, completion: @escaping (User?,String?,Bool)->Void)
    {
        let parameters: Parameters = [
            "username":username,
            "password":password,
            "role":role
        ]
        Alamofire.request(Constants.RegisterURL,method:.post,parameters:parameters).validate()
            .responseJSON { (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    let OK = json["ok"].boolValue
                    if OK{
                        //Registration successful
                        let user = User(json: json["user"])
                        completion(user,nil,true)
                    }
                    else{
                        //Registration was not successful because the server rejected the User (existing username, etc)
                        let message = json["message"].stringValue
                        completion(nil,message,false)
                    }
                case .failure( _):
                    completion(nil,"Server error",false)
                }
        }
    }
    
    
    //MARK: Books
    func FetchBooks(UserId:String, completion: @escaping ([Book]?)->Void)
    {
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        Alamofire.request(Constants.UserBooksURL+UserId,headers:headers).validate()
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
    
    func CreateBook(title:String,authorid:UUID,completion: @escaping (Book?,Bool,String)->Void)
    {
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let userid = self.defaultValues.string(forKey: UserDefaults.Keys.UserId)
        let parameters : Parameters = [
            "title":title,
            "authorId":authorid.uuidString,
            "userId":userid!
        ]
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        
        Alamofire.request(Constants.CreateBookURL,method:.post,parameters:parameters,headers:headers).validate()
            .responseJSON{ (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    let success = json["ok"].boolValue
                    if success {
                        let book = Book(json:json["book"])
                        completion(book,true,"OK")
                    }
                    else{
                        let message = json["message"].stringValue
                        completion(nil,false,message)
                    }
                case .failure( _):
                    completion(nil,false,"There was an error creating the book!")
                }
                
        }
    }
    
    func UpdateBook(id: UUID,title:String,authorid:UUID, completion: @escaping (Book?) -> Void)
    {
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let parameters: Parameters = [
            "id":id.uuidString,
            "title":title,
            "authorId":authorid.uuidString
        ]
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        Alamofire.request(Constants.UpdateBookURL,method:.post,parameters: parameters,headers:headers).validate()
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
    
    func DeleteBook(id: UUID,completion: @escaping (Bool)->Void)
    {
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        Alamofire.request(Constants.DeleteBookURL+id.uuidString,method:.post,headers:headers).validate()
            .responseJSON { (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    let ok = json["ok"].boolValue
                    completion(ok)
                case .failure( _):
                    completion(false)
                }
        }
    }
    
    //MARK: Authors
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
}
