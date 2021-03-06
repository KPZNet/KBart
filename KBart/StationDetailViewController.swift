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
    var destinationStations : DestinationStations?
    //var selectedStation : Station!
    var selectedStationAbbr : String?
    let selectedStationAbbrDefault : String = "RICH"
    var updateTimer  = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillDisappear(_ _animated: Bool)
    {
        updateTimer.invalidate()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        updateTimer.invalidate()
        FireGetDepartureStations()
        updateTimer = Timer.scheduledTimer(timeInterval: 30.0,
            target: self,
            selector: #selector(StationDetailViewController.FireGetDepartureStations),
            userInfo: nil,
            repeats: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UpdateDestinationStations(forStations _forStations : DestinationStations)
    {
        self.destinationStations = _forStations
        departureStationsTable.reloadData()
    }
    @objc func FireGetDepartureStations()
    {
        
        GetDataQueue_serial().async(execute: {
                var sStationDef : String = self.selectedStationAbbrDefault
                
                if let sAbbr = self.selectedStationAbbr
                {
                    sStationDef = sAbbr
                }
                
                let destStations : DestinationStations = GetDestinationStations(forStationAbbr :sStationDef)
                
                DispatchQueue.main.async(execute: { self.UpdateDestinationStations(forStations: destStations) } )
                
        })
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        var tableSections : Int = 0
        if let _ = destinationStations
        {
            tableSections = 1
        }
        
        return tableSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var tableRows : Int = 0
        
        if let dStations = destinationStations
        {
            tableRows = dStations.NumberOfStations()
        }
        
        return tableRows
    }
    
    
    
    
    //    func configureTableView()
    //    {
    //        stationTable.rowHeight = UITableViewAutomaticDimension
    //        stationTable.estimatedRowHeight = 160.0
    //    }
    
    func isLandscapeOrientation() -> Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var returnCell:UITableViewCell!
        
        
        let cellIdentifier:String = "DestinationStationCell"
        let cell:DestinationStationCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DestinationStationCell
        
        // Configure the cell...
        if let dStations = destinationStations
        {
            let stat = dStations[(indexPath as NSIndexPath).row]
            cell?.SetStation(forStation: stat)
        }
        
        returnCell = cell
        
        return returnCell!
    }
    
}
