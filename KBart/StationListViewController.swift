//
//  SecondViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

class StationListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var stationTable: UITableView!
    @IBOutlet weak var detailedStationTable: UITableView!
    
    var stationList : StationList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dispatch_sync(GetDataQueue_serial(),
            {
                self.stationList = GetAppDelegate().stationList
        })
        SetRoundedViewBox(forView: stationTable)
        SetRoundedViewBox(forView: detailedStationTable)
    }
    
    func SetRoundedViewBox(forView _forView:UIView)
    {
        _forView.layer.cornerRadius = 5.0
        _forView.layer.masksToBounds = true
        _forView.layer.borderWidth = 0.5
        _forView.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        var tableSections : Int = 0
        if( tableView == stationTable)
        {
            tableSections = 1
        }
        
        return tableSections
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var tableRows : Int = 0
        
        if(tableView == stationTable)
        {
            tableRows = stationList!.NumberOfStations()
        }
        
        return tableRows
    }
    
    
    
    
    //    func configureTableView()
    //    {
    //        stationTable.rowHeight = UITableViewAutomaticDimension
    //        stationTable.estimatedRowHeight = 160.0
    //    }
    
    func isLandscapeOrientation() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell!
        
        if(tableView == stationTable)
        {
            var cellIdentifier:String = "stationCustomCell"
            var cell:stationCustomCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? stationCustomCell
            
            // Configure the cell...
            var stat = stationList![indexPath.row]
            
            cell?.stationName.text = stat.name
        }
        
        return cell!
    }
    
    
}

