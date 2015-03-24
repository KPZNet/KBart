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
    var initalizeStatus : InitializingAppStatusView?
    
    /*
    var loadingStationsMessenger : UIAlertController = UIAlertController(title: "BART", message: "Initializing Stations", preferredStyle: UIAlertControllerStyle.Alert)
    */
    
    var stationList : StationList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dispatch_async(Getbqueue_serial(),
            {
                dispatch_async(dispatch_get_main_queue(),
                    { self.ShowStationStatus() } )
                self.stationList = GetBARTStationsLive()
                dispatch_async(dispatch_get_main_queue(),
                    { self.DoneLoadingStations() } )
                
        })
        
        
        
    }
    
    func ShowStationStatus()
    {
        initalizeStatus  = InitializingAppStatusView(forController: self)
        initalizeStatus!.SetCancelHandler(handler: CancelStationList )
        
        initalizeStatus!.ShowView()
        
        /*
        loadingStationsMessenger.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            switch action.style{
           
            case .Cancel:
                self.CancelStationList()
                
            default:
                println("default")
                
            }
        }))
        self.presentViewController(loadingStationsMessenger, animated: true, completion: nil)
*/
    }
    
    func DoneLoadingStations()
    {
        /*
        loadingStationsMessenger.dismissViewControllerAnimated(true, completion: nil)
        */
        initalizeStatus!.CloseView()
        
        initalizeStatus = nil
    }
    
    func CancelStationList()
    {
       DoneLoadingStations()
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

