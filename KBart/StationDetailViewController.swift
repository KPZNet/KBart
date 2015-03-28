//
//  StationDetailViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/26/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

class StationDetailViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var departureStationsTable: UITableView!
    var destinationStations : DestinationStations!
    var selectedStation : Station!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        destinationStations = GetDestinationStations(forStationAbbr : selectedStation.abbr)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        var tableSections : Int = 0
        if( tableView == departureStationsTable)
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
        
        if( tableView == departureStationsTable)
        {
            tableRows = destinationStations.NumberOfStations()
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
        var returnCell:UITableViewCell!
        
        
        var cellIdentifier:String = "DestinationStationCell"
        var cell:DestinationStationCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? DestinationStationCell
        
        // Configure the cell...
        var stat = destinationStations[indexPath.row]
        
        cell?.stationName.text = stat.name
        
        returnCell = cell
        
        return returnCell!
    }
    
}
