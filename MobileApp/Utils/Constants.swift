//
//  Constants.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation

public enum Constants{
    
    static let BaseURL: String = "http://home-server.go.ro/MobileApi/api/v1/";
    static let LoginURL: String = BaseURL + "users/login";
    static let RegisterURL: String = BaseURL + "users/register";
    
    static let UserBooksURL: String = BaseURL + "books/user/";
    static let UpdateBookURL: String = BaseURL + "books/update";
}
