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
    
    func SetSquareViewBox(forView _forView:UIView)
    {
        //_forView.layer.cornerRadius = 5.0
        //_forView.layer.masksToBounds = true
        _forView.layer.borderWidth = 0.5
        _forView.layer.borderColor = UIColor.black.cgColor
    }

    
    func SetStation(forStation _forStation : DestinationStation)
    {
        station = _forStation
        stationName.text = station?.name
        UpdateTrain(forLabel: train1Label, forTrain: station![0])
        UpdateTrain(forLabel: train2Label, forTrain: station![1])
        UpdateTrain(forLabel: train3Label, forTrain: station![2])
        
        SetSquareViewBox(forView: train1Label)
        SetSquareViewBox(forView: train2Label)
        SetSquareViewBox(forView: train3Label)
        
    }
    func UpdateTrain(forLabel _forLabel:UILabel, forTrain _forTrain :DepartingTrain?)
    {
        if let dTrain = _forTrain
        {
            var mins : String = dTrain.minutes
            _forLabel.layer.backgroundColor = UIColor.clear.cgColor
            if(mins.isEqual("Leaving"))
            {
                mins = "Now"
                _forLabel.layer.backgroundColor = UIColor.green.cgColor
            }
            _forLabel.text = mins
        }
        else
        {
            _forLabel.text = ""
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
