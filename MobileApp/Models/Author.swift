//
//  Author.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Author {
    var Id: UUID;
    var FirstName: String;
    var LastName: String;
    
    public init(id:UUID,firstname:String,lastname:String)
    {
        Id=id;
        FirstName=firstname
        LastName=lastname
    }
    
    public init()
    {
        Id=UUID(uuidString:"00000000-0000-0000-0000-000000000000")!
        FirstName=""
        LastName=""
    }
    
    init(json: JSON)
    {
        Id=UUID(uuidString: json["Id"].string ?? "00000000-0000-0000-0000-000000000000")!
        FirstName=json["FirstName"].string ?? ""
        LastName=json["LastName"].string ?? ""
    }
}
