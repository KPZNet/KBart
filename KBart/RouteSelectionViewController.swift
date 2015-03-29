//
//  RouteSelectionViewController.swift
//  KBart
//
//  Created by Kenneth Ceglia on 3/28/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

class RouteSelectionViewController: UIViewController, UITableViewDelegate , UITableViewDataSource
{


    var selectedStationRow : Int = -1
    
    @IBOutlet weak var stationFromTable: UITableView!
    @IBOutlet weak var stationToTable: UITableView!
    
    var stationList : StationList!
    
    var fromStation : Station
    var toStation : Station
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.stationList = GetAppDelegate().stationList
    
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
        if let statList = stationList
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
        
        if let statList = stationList
        {
            tableRows = statList.NumberOfStations()
        }
        
        return tableRows
    }
    
    
    //MARK: - Navigation
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath
    {
        selectedStationRow = indexPath.row
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath
    {
        selectedStationRow = indexPath.row
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        
        if (segue.identifier == "stationDetailSeque")
        {
            var svc = segue.destinationViewController as StationDetailViewController
            
            var selStation = stationList[selectedStationRow]
            svc.selectedStation = selStation
            
        }
        
    }
    
    
    
    //    func configureTableView()
    //    {
    //        stationTable.rowHeight = UITableViewAutomaticDimension
    //        stationTable.estimatedRowHeight = 160.0
    //    }
    
    func isLandscapeOrientation() -> Bool
    {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var returnCell:UITableViewCell!
        
        if let statList = stationList
        {
            var cellIdentifier:String = "stationCustomCell"
            var cell:stationCustomCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? stationCustomCell
            
            // Configure the cell...
            var stat = statList[indexPath.row]
            
            cell?.stationName.text = stat.name
            
            returnCell = cell
        }
        
        
        return returnCell!
    }
    

}
