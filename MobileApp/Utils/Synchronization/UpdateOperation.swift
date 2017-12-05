//
//  UpdateOperation.swift
//  MobileApp
//
//  Created by Tudor Stanila on 06/12/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
class UpdateOperation: NSObject,IOperation,NSCoding{
    var type: OperationType = OperationType.Update
    
    var parameters: [String]
    
    init(id:UUID,title:String,authorid:UUID){
        parameters = [String]()
        parameters.append(id.uuidString)
        parameters.append(title)
        parameters.append(authorid.uuidString);
    }
    
    func process(completion: @escaping ([String])->Void) {
        completion(parameters);
    }
    
    required init?(coder aDecoder: NSCoder) {
        let typeNo = aDecoder.decodeInt32(forKey:"Type")
        self.type = OperationType(rawValue:Int(typeNo))!;
        self.parameters = (aDecoder.decodeObject(forKey: "Parameters") as? [String])!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type.rawValue, forKey: "Type")
        aCoder.encode(parameters, forKey: "Parameters")
    }
}
