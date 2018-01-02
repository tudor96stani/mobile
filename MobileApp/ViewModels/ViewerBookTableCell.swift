//
//  ViewerBookTableCell.swift
//  MobileApp
//
//  Created by Tudor Stanila on 29/12/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit

class ViewerBookTableCell: UITableViewCell {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
