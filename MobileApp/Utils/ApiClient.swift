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
        
        if Reachability.isConnectedToNetwork(){
            //fetch books from remote server
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
                        //save books and authors locally when they are fetched, to be available for offline usage
                        let booksData = NSKeyedArchiver.archivedData(withRootObject: books)
                        self.defaultValues.set(booksData, forKey: UserDefaults.Keys.Books)
                        let authors = books.map{$0.BookAuthor};
                        var authorsSet = [Author]()
                        
                        for a in authors{
                            if !authorsSet.contains(where: { (auth) -> Bool in
                                a.Id.uuidString==auth.Id.uuidString
                            })
                            {
                                authorsSet.append(a)
                            }
                        }
                        let authorsData = NSKeyedArchiver.archivedData(withRootObject: authorsSet)
                        self.defaultValues.set(authorsData,forKey:UserDefaults.Keys.Authors)
                        self.Sync();
                        //finish
                        completion(books)
                    case .failure( _):
                        completion(nil)
                    }
            }
        }
        else{
            //fetch books from local storage
            if let booksData = defaultValues.object(forKey: UserDefaults.Keys.Books) as? NSData {
                if let booksArray = NSKeyedUnarchiver.unarchiveObject(with: booksData as Data) as? [Book] {
                    completion(booksArray)
                }
            }
        }
    }
    
    func CreateBook(title:String,authorid:UUID,completion: @escaping (Book?,Bool,String)->Void)
    {
        if Reachability.isConnectedToNetwork(){
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
        else
        {
            let op: IOperation = AddOperation(title:title,authorId:authorid);
            //let opData = NSKeyedArchiver.archivedData(withRootObject: op)
            //self.defaultValues.set(booksData, forKey: UserDefaults.Keys.Books)
            
            if let operations = defaultValues.object(forKey: UserDefaults.Keys.Operations) as? NSData {
                if var operationsArray = NSKeyedUnarchiver.unarchiveObject(with: operations as Data) as? [IOperation] {
                    //completion(booksArray)
                    operationsArray.append(op)
                    print(operationsArray)
                    let newOpdata = NSKeyedArchiver.archivedData(withRootObject: operationsArray)
                    self.defaultValues.set(newOpdata,forKey:UserDefaults.Keys.Operations)
                }
            }
            else{
                var opArr = [IOperation]()
                opArr.append(op)
                let arrData = NSKeyedArchiver.archivedData(withRootObject: opArr);
                self.defaultValues.set(arrData,forKey:UserDefaults.Keys.Operations)
            }
            completion(nil,true,"Book will be added to db when there is network access")
        }
    }
    
    func UpdateBook(id: UUID,title:String,authorid:UUID, completion: @escaping (Book?) -> Void)
    {
        if Reachability.isConnectedToNetwork(){
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
        else{
            let op: IOperation = UpdateOperation(id:id,title:title,authorid:authorid);
            //let opData = NSKeyedArchiver.archivedData(withRootObject: op)
            //self.defaultValues.set(booksData, forKey: UserDefaults.Keys.Books)
            
            if let operations = defaultValues.object(forKey: UserDefaults.Keys.Operations) as? NSData {
                if var operationsArray = NSKeyedUnarchiver.unarchiveObject(with: operations as Data) as? [IOperation] {
                    //completion(booksArray)
                    operationsArray.append(op)
                    print(operationsArray)
                    let newOpdata = NSKeyedArchiver.archivedData(withRootObject: operationsArray)
                    self.defaultValues.set(newOpdata,forKey:UserDefaults.Keys.Operations)
                }
            }
            else{
                var opArr = [IOperation]()
                opArr.append(op)
                let arrData = NSKeyedArchiver.archivedData(withRootObject: opArr);
                self.defaultValues.set(arrData,forKey:UserDefaults.Keys.Operations)
            }
            
            if let authorsData = defaultValues.object(forKey: UserDefaults.Keys.Authors) as? NSData {
                if let authorsArray = NSKeyedUnarchiver.unarchiveObject(with: authorsData as Data) as? [Author] {
                    if let booksData = defaultValues.object(forKey: UserDefaults.Keys.Books) as? NSData {
                        if let booksArray = NSKeyedUnarchiver.unarchiveObject(with: booksData as Data) as? [Book] {
                            let oldBook = booksArray.first(where: { (b) -> Bool in
                                b.Id.uuidString == id.uuidString
                            })
                            oldBook?.Title=title
                            if oldBook?.AuthorId != authorid{
                                let author = authorsArray.first(where: { (a) -> Bool in
                                    a.Id==authorid
                                })
                                oldBook?.AuthorId=authorid
                                oldBook?.BookAuthor=author!
                            }
                            let booksData = NSKeyedArchiver.archivedData(withRootObject: booksArray)
                            self.defaultValues.set(booksData, forKey: UserDefaults.Keys.Books)
                        }
                    }
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func DeleteBook(id: UUID,completion: @escaping (Bool)->Void)
    {
        if Reachability.isConnectedToNetwork(){
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
        else
        {
            //store the operations for later
            let op: IOperation = DeleteOperation(id:id);
            //let opData = NSKeyedArchiver.archivedData(withRootObject: op)
            //self.defaultValues.set(booksData, forKey: UserDefaults.Keys.Books)
            
            if let operations = defaultValues.object(forKey: UserDefaults.Keys.Operations) as? NSData {
                if var operationsArray = NSKeyedUnarchiver.unarchiveObject(with: operations as Data) as? [IOperation] {
                    //completion(booksArray)
                    operationsArray.append(op)
                    print(operationsArray)
                    let newOpdata = NSKeyedArchiver.archivedData(withRootObject: operationsArray)
                    self.defaultValues.set(newOpdata,forKey:UserDefaults.Keys.Operations)
                }
            }
            else{
                var opArr = [IOperation]()
                opArr.append(op)
                let arrData = NSKeyedArchiver.archivedData(withRootObject: opArr);
                self.defaultValues.set(arrData,forKey:UserDefaults.Keys.Operations)
            }
            completion(true)
        }
    }
    
    //MARK: Authors
    func GetAllAuthors(completion: @escaping ([Author]?) -> Void)
    {
        if Reachability.isConnectedToNetwork(){
            //fetch authors from remote server
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
        else
        {
            //fetch authors from local storage
            if let authorsData = defaultValues.object(forKey: UserDefaults.Keys.Authors) as? NSData {
                if let authorsArray = NSKeyedUnarchiver.unarchiveObject(with: authorsData as Data) as? [Author] {
                    completion(authorsArray)
                }
            }
        }
    }
    
    func CreateAuthor(firstName:String,lastName:String,completion: @escaping (Author?,Bool,String)->Void)
    {
        if Reachability.isConnectedToNetwork()
        {
            let params : Parameters = [
                "FirstName":firstName,
                "LastName":lastName
            ]
            Alamofire.request(Constants.CreateAuthorURL,method:.post,parameters:params).validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result{
                    case .success(let value):
                        print("OK")
                        let json = JSON(value)
                        let ok = json["Ok"].boolValue
                        if ok{
                            let author = Author(json:json["Author"])
                            completion(author,true,"OK")
                        }
                        else{
                            completion(nil,false,json["Message"].stringValue)
                        }
                    case .failure( _):
                        completion(nil,false,"There was an error")
                    }
                })
        }
        else
        {
            completion(nil,false,"You need an internet connection to create an author!")
        }
    }
    
    //MARK: Syncronize
    func Sync()
    {
        if let opData = defaultValues.object(forKey: UserDefaults.Keys.Operations) as? NSData {
            if let opArr = NSKeyedUnarchiver.unarchiveObject(with: opData as Data) as? [IOperation] {
                for op in opArr{
                    op.process { (params) in
                        switch op.type
                        {
                        case .Add:
                            self.CreateBook(title: params[0], authorid: UUID(uuidString:params[1])!, completion: { (book, ok, msg) in
                                if ok{
                                    print("Add OK");
                                }
                                else{
                                    print("Add not ok");
                                }
                            })
                        case .Delete:
                            self.DeleteBook(id: UUID(uuidString:params[0])!, completion: { (ok) in
                                if ok{
                                    print("Delete ok");
                                }
                                else{
                                    print("Delete not ok");
                                }
                            })
                        case .Update:
                            self.UpdateBook(id: UUID(uuidString:params[0])!, title: params[1], authorid: UUID(uuidString:params[2])!, completion: { (book) in
                                if book != nil{
                                    print("Update ok")
                                }
                                else{
                                    print("Update not ok")
                                }
                            })
                        }
                    }
                }
                let opArr = [IOperation]()
                let arrData = NSKeyedArchiver.archivedData(withRootObject: opArr);
                self.defaultValues.set(arrData,forKey:UserDefaults.Keys.Operations)
            }
        }
        
    }
}
