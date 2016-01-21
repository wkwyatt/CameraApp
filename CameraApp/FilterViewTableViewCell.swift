//
//  FilterViewTableViewCell.swift
//  CameraApp
//
//  Created by Will Wyatt on 1/18/16.
//  Copyright © 2016 Will Wyatt. All rights reserved.
//

import UIKit

class FilterViewTableViewCell: UITableViewCell {

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
