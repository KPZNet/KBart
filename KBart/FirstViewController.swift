//
//  FirstViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController
{
    var stats :StationList = StationList()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func readInStations(sender: AnyObject)
    {
        
        stats.ReadStations()
        
    }

    @IBAction func checkStations(sender: AnyObject)
    {
        
    }
}

