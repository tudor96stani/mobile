//
//  Book.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON

class Book{
    var Id: UUID;
    var Title: String;
    var AuthorId: UUID;
    var BookAuthor: Author;
    init(id:UUID,title:String,authorid:UUID){
        Id=id;
        Title=title;
        AuthorId=authorid;
        BookAuthor=Author()
    }
    init(id:UUID,title:String,authorid:UUID,author:Author){
        Id=id;
        Title=title;
        AuthorId=authorid;
        BookAuthor = author
    }
    
    init(json: JSON){
        Id=UUID(uuidString:json["id"].string ?? "00000000-0000-0000-0000-000000000000")!
        Title = json["title"].string ?? ""
        AuthorId = UUID(uuidString:json["author"]["id"].string ?? "00000000-0000-0000-0000-000000000000")!
        self.BookAuthor = Author(id: UUID(uuidString:json["author"]["id"].string ?? "00000000-0000-0000-0000-000000000000")!,firstname: json["author"]["firstName"].string ?? "",lastname: json["author"]["lastName"].string ?? "")
        
    }
}
