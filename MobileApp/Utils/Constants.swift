//
//  Constants.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation

public enum Constants{
    //MARK: Base and user
    static let BaseURL: String = "http://home-server.go.ro/MobileApi/api/v1/";
    static let LoginURL: String = "http://home-server.go.ro/MobileApi/token";
    static let RegisterURL: String = BaseURL + "users/register";
    static let RefreshURL: String = "http://home-server.go.ro/MobileApi/verify";
    
    //MARK: Books
    static let UserBooksURL: String = BaseURL + "books/user/";
    static let UpdateBookURL: String = BaseURL + "books/update";
    
    //MARK: Authors
    static let AllAuthorsURL: String = BaseURL + "authors"
}
