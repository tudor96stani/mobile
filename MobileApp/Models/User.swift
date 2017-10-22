//
//  User.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
public class User{
    var Id: UUID;
    var Username: String;
    var Role: Int;
    
    init(Id:UUID, Username:String,Role:Int){
        self.Id=Id;
        self.Username=Username;
        self.Role=Role;
    }
}
