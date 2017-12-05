//
//  Author.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON

class Author:NSObject,NSCoding {
    var Id: UUID;
    var FirstName: String;
    var LastName: String;
    
    public init(id:UUID,firstname:String,lastname:String)
    {
        Id=id;
        FirstName=firstname
        LastName=lastname
    }
    
    override init()
    {
        Id=UUID(uuidString:"00000000-0000-0000-0000-000000000000")!
        FirstName=""
        LastName=""
    }
    
    init(json: JSON)
    {
        Id=UUID(uuidString: json["id"].string ?? "00000000-0000-0000-0000-000000000000")!
        FirstName=json["firstName"].string ?? ""
        LastName=json["lastName"].string ?? ""
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.Id = UUID(uuidString:aDecoder.decodeObject(forKey: "Id") as? String ?? "")!
        self.FirstName = aDecoder.decodeObject(forKey: "FirstName") as? String ?? ""
        self.LastName = aDecoder.decodeObject(forKey: "LastName") as? String ?? ""
    
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Id.uuidString, forKey: "Id")
        aCoder.encode(FirstName, forKey: "FirstName")
        aCoder.encode(LastName,forKey:"LastName")
    }
    
}
