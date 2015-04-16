//
//  SecondViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

class StationListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    var selectedStationRow : Int = -1
    
    @IBOutlet weak var stationTable: UITableView!
    
    var stationList : StationList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dispatch_sync(GetDataQueue_serial(),
            {
                self.stationList = GetAppDelegate().stationList
        })
        //SetRoundedViewBox(forView: stationTable)
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
    
    
     //MARK: - Navigation
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedStationRow = indexPath.row
        return indexPath
    }
    
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectedStationRow = indexPath.row
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        
        if (segue.identifier == "stationDetailSeque")
        {
            var svc = segue.destinationViewController as! StationDetailViewController
            
            var selStation = stationList[selectedStationRow]
            svc.selectedStationAbbr = selStation.abbr
            
        }
        
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var returnCell:UITableViewCell!
        
        if(tableView == stationTable)
        {
            var cellIdentifier:String = "StationListCell"
            var cell:StationListCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? StationListCell
            
            // Configure the cell...
            var stat = stationList![indexPath.row]
            
            cell?.stationName.text = stat.name
            
            returnCell = cell
        }
        
        
        return returnCell!
    }

    

}

