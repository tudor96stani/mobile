//
//  User.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
public class User{
    var Id: UUID;
    var Username: String;
    var Role: Int;
    
    init(Id:UUID, Username:String,Role:Int){
        self.Id=Id;
        self.Username=Username;
        self.Role=Role;
    }
    
    init(json: JSON)
    {
        Id = UUID(uuidString: json["Id"].string ?? "00000000-0000-0000-0000-000000000000")!
        Username = json["Username"].string ?? ""
        Role = json["Role"].int ?? 1
    }
}
