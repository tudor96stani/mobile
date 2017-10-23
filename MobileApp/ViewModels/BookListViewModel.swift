//
//  BookListViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class BookListViewModel: NSObject
{
    @IBOutlet var apiClient: ApiClient!
    var books: [Book]?
    
    func GetBooks(UserId: UUID,completion: @escaping() -> Void)
    {
        apiClient.FetchBooks(UserId: UserId.uuidString) { (books) in
            DispatchQueue.main.async {
                self.books = books
                completion()
            }
        }
    }
    
    func NumberOfItemsToDisplay(in section: Int)->Int
    {
        return books?.count ?? 0;
    }
    
    func BookTitleToDisplay(for indexPath: IndexPath)->String
    {
        return books?[indexPath.row].Title ?? "";
    }
    
    func BookAuthorIdToDisplay(for indexPath: IndexPath)->String{
        //return books?[indexPath.row].BookAuthor.FirstName+ " "+ books?[indexPath.row].BookAuthor.LastName ?? "";
        if let author = books?[indexPath.row].BookAuthor
        {
            return author.FirstName + " " + author.LastName
        }
        return " ";
    }
}
