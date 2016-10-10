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
    
    var fromStation : Station?
    var toStation : Station?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.stationList = GetAppDelegate().stationList
        
        SetRoundedViewBox(forView: stationFromTable)
        SetRoundedViewBox(forView: stationToTable)
    }
    
    func SetRoundedViewBox(forView _forView:UIView)
    {
        _forView.layer.cornerRadius = 5.0
        _forView.layer.masksToBounds = true
        _forView.layer.borderWidth = 0.5
        _forView.layer.borderColor = UIColor.black.cgColor
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        var tableSections : Int = 0
        if let _ = stationList
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
        
        if let statList = stationList
        {
            tableRows = statList.NumberOfStations()
        }
        
        return tableRows
    }
    
    
    //MARK: - Navigation

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedStationRow = (indexPath as NSIndexPath).row
        return indexPath
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath){
        selectedStationRow = (indexPath as NSIndexPath).row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if (segue.identifier == "stationDetailSeque")
        {
            let svc = segue.destination as! StationDetailViewController
            
            let selStation = stationList[selectedStationRow]
            svc.selectedStationAbbr = selStation.abbr
            
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RouteStationCell", for: indexPath) 
    
    // Configure the cell...
        if let _ = stationList
        {
             let stat = stationList[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = stat.name
        }
    return cell
    }
    
    

}
