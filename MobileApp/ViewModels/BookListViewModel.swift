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
       
        //Call the fetch books method of the apiclient
        //With the completionHandler which assigns to the ViewModel property
        //books the list obtained from the api client
        //And then calls the completion handler received as param from the controller
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
    
    func FindBookDetailsViewModel(for indexPath: IndexPath) -> BookDetailsViewModel?
    {
        if let book = books?[indexPath.row]
        {
            let viewmodel = BookDetailsViewModel(b:book)
            return viewmodel
        }
        return nil
    }
    
    func DeleteBook(for indexPath: IndexPath,completion: @escaping (Bool)->Void) {
        let book = (self.books?[indexPath.row])!;
        self.books?.remove(at: indexPath.row);
        apiClient.DeleteBook(id: book.Id) { (Ok) in
            DispatchQueue.main.async{
                completion(Ok);
            }
        }
    }
    
    //
}
