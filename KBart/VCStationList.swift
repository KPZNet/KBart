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
        
        dispatch_sync(Getbqueue_serial(),
            {
                self.stationList = GetAppDelegate().stationList
        })



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
        return stationList!.NumberOfStations()
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
        
        var cellIdentifier:String = "stationCustomCell"
        var cell:stationCustomCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? stationCustomCell

        
        // Configure the cell...
        var stat = stationList![indexPath.row]
        
        cell?.stationName.text = stat.name
        
        return cell!
    }


}

