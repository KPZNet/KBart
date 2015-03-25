//
//  FirstViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit


class MainViewController: UIViewController
{
    var initalizeStatus : InitializingAppStatusView?
    
    var stationList : StationList!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dispatch_async(GetDataQueue_serial(),
            {
                dispatch_async(dispatch_get_main_queue(),
                    { self.ShowStationStatus() } )
                self.stationList = ReadBARTStationsFromFile()
                GetAppDelegate().SetStationList(forStationList: self.stationList)
                dispatch_async(dispatch_get_main_queue(),
                    { self.DoneLoadingStations() } )
                
        })
    }
    
    func ShowStationStatus()
    {
        initalizeStatus  = InitializingAppStatusView(forController: self, CancelHandler: CancelStationList)
        
        initalizeStatus!.ShowView()
    }
    
    func DoneLoadingStations()
    {
        if let initStatus = initalizeStatus
        {
            initStatus.CloseView()
            initalizeStatus = nil
        }
        
    }
    
    func CancelStationList()
    {
       DoneLoadingStations()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

