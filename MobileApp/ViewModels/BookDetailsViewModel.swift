//
//  BookDetailsViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class BookDetailsViewModel
{
    var book: Book!
    
    init(b: Book){
        book=b
    }
    
    init(id:UUID,title:String,authorid:UUID){
        book = Book(id: id, title: title, authorid: authorid)
    }
    
    func BookTitleForDisplay() -> String{
        return book?.Title ?? "-"
    }
   
    func BookAuthorForDisplay() -> String{
        return (book?.BookAuthor.FirstName ?? " ") + " " + (book?.BookAuthor.LastName ?? " ")
    }
}
