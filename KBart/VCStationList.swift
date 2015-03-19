//
//  SecondViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

class VCStationList: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var stationTable: UITableView!
    var stationList : StationList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        stationList = appDelegate.stationList

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
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return stationList.NumberOfStations()
    }
    
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    {
//        
//        var cellIdentifier:String = "stationCell"
//        var cell:stationTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? stationTableViewCell
//        if (cell == nil)
//        {
//            var nib:Array = NSBundle.mainBundle().loadNibNamed("stationTableViewCell", owner: self, options: nil)
//            cell = nib[0] as? stationTableViewCell
//        }
//        
//        // Configure the cell...
//        var stat = stationList[indexPath.row]
//        
//        cell?.stationName.text = stat.name
//        
//        return cell!
//    }
    
    func configureTableView()
    {
        stationTable.rowHeight = UITableViewAutomaticDimension
        stationTable.estimatedRowHeight = 160.0
    }
    
    func isLandscapeOrientation() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cellIdentifier:String = "stationCustomCell"
        var cell:stationCustomCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? stationCustomCell

        
        // Configure the cell...
        var stat = stationList[indexPath.row]
        
        cell?.stationName.text = stat.name
        
        return cell!
    }


//    func basicCellAtIndexPath(indexPath:NSIndexPath) -> BasicCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(customCellClassIdentifierName) as customCellClass
//        setTitleForCell(cell, indexPath: indexPath)
//        setSubtitleForCell(cell, indexPath: indexPath)
//        return cell
//    }

}

