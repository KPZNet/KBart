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
    var ktView:ExampleChildViewController?
    var stationList : StationList?
    
    @IBAction func OnKTView(sender: AnyObject)
    {
        ktView = ExampleChildViewController(forController: self)
        
        ktView?.ShowView()
    }
    
    @IBAction func StopKTView(sender: AnyObject)
    {
        ktView?.CloseView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ShowStationStatus()
        dispatch_async(Getbqueue_serial(),
            {
                stationList = GetStationList()
                dispatch_async(dispatch_get_main_queue(),
                    { self.CloseStationStatus() } )
                
                        })
        
    }

    func ShowStationStatus()
    {
        
    }
    func CloseStationStatus()
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    @IBAction func checkStations(sender: AnyObject)
    {
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let aVariable = appDelegate.stationList
//        
//        var stat : Station = aVariable["K"]
    }
}

