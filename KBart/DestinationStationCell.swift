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
    @IBOutlet weak var train1Label: UILabel!
    @IBOutlet weak var train2Label: UILabel!
    @IBOutlet weak var train3Label: UILabel!
    
    var station : DestinationStation?
    
    func SetStation(forStation _forStation : DestinationStation)
    {
        station = _forStation
        stationName.text = station?.name
        UpdateTrain(forLabel: train1Label, forTrain: station![0])
        UpdateTrain(forLabel: train2Label, forTrain: station![1])
        UpdateTrain(forLabel: train3Label, forTrain: station![2])
    }
    func UpdateTrain(forLabel _forLabel:UILabel, forTrain _forTrain :DepartingTrain?)
    {
        if let dTrain = _forTrain
        {
            _forLabel.text = dTrain.minutes
        }
        else
        {
            _forLabel.text = "NT"
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
