//
//  BookEditViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class BookEditViewModel: NSObject{
    var book: Book!
    var authors: [Author]!
    @IBOutlet var apiClient: ApiClient!
    
    func UpdateBook(title:String,authorId:UUID,completion: @escaping () -> Void){
        apiClient.UpdateBook(id: self.book.Id, title: title, authorid: authorId) { (book) in
            DispatchQueue.main.async {
                self.book=book
                completion()
            }
        }
    }
    
    func SetBook(id: UUID,title: String,authorid: UUID,bookauthor: Author){
        self.book = Book(id: id, title: title, authorid: authorid,author:bookauthor)
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
    
    func BookIsDefined() -> Bool{
        return book != nil
    }
    
    func FindBookTitle() -> String
    {
        return book?.Title ?? " "
    }
    
    func FindBookAuthor() -> String
    {
        return (book?.BookAuthor.FirstName ?? " ") + " " + (book?.BookAuthor.LastName ?? " ")
    }
}
