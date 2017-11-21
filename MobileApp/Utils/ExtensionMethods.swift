//
//  ExtensionMethods.swift
//  MobileApp
//
//  Created by Tudor Stanila on 01/11/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.5
    }
}

extension UserDefaults {
    enum Keys {
        static let UserId = "userid"
        static let Role = "Role"
    }
}

extension KeychainSwift{
    enum Keys{
        static let Token = "token"
        static let Username = "username"
        static let Password = "password"
    }
}

