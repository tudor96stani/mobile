//
//  ChartViewModel.swift
//  MobileApp
//
//  Created by Tudor Stanila on 05/12/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class ChartViewModel: NSObject {
    @IBOutlet var apiClient : ApiClient!
    
    func fetchChartData(completion: @escaping ([ChartItem])->Void){
        
        apiClient.FetchBooks(UserId: UserDefaults.standard.string(forKey:UserDefaults.Keys.UserId)!) { (books) in
            DispatchQueue.main.async{
                var items = [ChartItem]()
                for b in books!{
                    if !items.contains(where: { (item) -> Bool in
                        item.author==b.BookAuthor.FirstName+" "+b.BookAuthor.LastName
                    })
                    {
                        items.append(ChartItem(author:b.BookAuthor.FirstName+" "+b.BookAuthor.LastName,number:1));
                    }
                    else{
                        items.first(where: { (item) -> Bool in
                            item.author==b.BookAuthor.FirstName+" "+b.BookAuthor.LastName
                        })?.NumberOfBooks! += 1
                        
                    }
                }
                
                completion(items);
                
            }
        }
    }
}
