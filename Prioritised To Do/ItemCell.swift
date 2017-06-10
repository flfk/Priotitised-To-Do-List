//
//  ItemCell.swift
//  Prioritised To Do
//
//  Created by Felix Kramer on 9/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    
    //MARK: - Reuse Identifier
    
    static let reuseIdentifier = "ItemCell"
    
    //MARK: - Properties
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemPriorityView: UIView!
    
    
    //MARK: - Initialisation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
