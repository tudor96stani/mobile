//
//  IOperation.swift
//  MobileApp
//
//  Created by Tudor Stanila on 05/12/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import Alamofire
enum OperationType:Int{
    case Add
    case Delete
    case Update
}

protocol IOperation{
    var type: OperationType {get set}
    var parameters: [String] {get set}
    func process(completion: @escaping ([String])->Void);
}
