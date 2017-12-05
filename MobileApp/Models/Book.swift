//
//  Book.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON

class Book:NSObject,NSCoding{
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
    
    required init?(coder aDecoder: NSCoder) {
        self.Id = UUID(uuidString:aDecoder.decodeObject(forKey: "Id") as? String ?? "")!
        self.Title = aDecoder.decodeObject(forKey: "Title") as? String ?? ""
        self.AuthorId = UUID(uuidString:aDecoder.decodeObject(forKey: "AuthorId") as? String ?? "")!
        self.BookAuthor = Author(id: AuthorId, firstname: aDecoder.decodeObject(forKey: "FirstName") as? String ?? "", lastname: aDecoder.decodeObject(forKey: "LastName") as? String ?? "")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Id.uuidString, forKey: "Id")
        aCoder.encode(Title, forKey: "Title")
        aCoder.encode(AuthorId.uuidString, forKey: "AuthorId")
        aCoder.encode(BookAuthor.FirstName,forKey:"FirstName")
        aCoder.encode(BookAuthor.LastName,forKey:"LastName")
    }
}
