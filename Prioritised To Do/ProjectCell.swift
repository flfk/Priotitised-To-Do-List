//
//  ProjectsCell.swift
//  Prioritised To Do
//
//  Created by Felix Kramer on 10/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit

class ProjectsCell: UITableViewCell {

    //MARK: - Reuse Identifier
    
    static let reuseIdentifier = "ProjectCell"
    
    //MARK: - Properties
    
    @IBOutlet weak var projectNameLabel: UILabel!
    
    //MARK: - Initialisation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
