//
//  ResultTableViewCell.swift
//  FMDBDemo
//
//  Created by devang bhavsar on 26/08/20.
//  Copyright © 2020 devang bhavsar. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBorder: UILabel!
    
    @IBOutlet weak var lblResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
