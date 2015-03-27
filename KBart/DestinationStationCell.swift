//
//  DestinationStationCell.swift
//  KBart
//
//  Created by KenCeglia on 3/20/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

class DestinationStationCell: UITableViewCell {

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var train1Label: UITextField!
    @IBOutlet weak var train2Label: UILabel!
    @IBOutlet weak var train3Label: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
