//
//  Stations.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import Foundation

class Station
{
    var name : String
    var abbr : String
    var gtfs_latitude : String
    var gtfs_longitude : String
    var address : String
    var city : String
    var county : String
    var state : String
    var zipcode : String
    
    init()
    {
        name = "name"
        abbr = "abbrev"
        gtfs_latitude = "0"
        gtfs_longitude = "0"
        address = "address"
        city = "city"
        county = "county"
        state = "state"
        zipcode = "zipcode"
    }
    
    init(fromName _name :String, fromAbbr _abbr:String,
        fromLatitude _latitude:String, fromLongitude _longitude:String,
        fromAddress _address:String, fromCity _city:String,
        fromCounty _county:String, fromState _state:String,
        fromZipCode _zipCode:String)
    {
        name = _name
        abbr = _abbr
        gtfs_latitude = _latitude
        gtfs_longitude = _longitude
        address = _address
        city = _city
        county = _county
        state = _state
        zipcode = _zipCode
    }
}

class StationList
{
    
    var stations:[String:Station]
    
    init()
    {
        self.stations = [:]
    }
    
    func ReadStations()
    {
        var stationList = [String:Station]()
        
        if let xmlPath = NSBundle.mainBundle().pathForResource("BARTStations", ofType: "xml") {
            if let data = NSData(contentsOfFile: xmlPath)
            {
                var error: NSError?
                if let doc = AEXMLDocument(xmlData: data, error: &error)
                {
                    var parsedText = String()
                    // parse known structure
                    for stat in doc["root"]["stations"]["station"].all!
                    {
                        var stationName = stat["name"].stringValue
                        
                        var newStation :Station = Station(  fromName:stat["name"].stringValue,
                            fromAbbr:stat["abbr"].stringValue,
                            fromLatitude:stat["gtfs_latitude"].stringValue,
                            fromLongitude:stat["gtfs_longitude"].stringValue,
                            fromAddress:stat["address"].stringValue,
                            fromCity:stat["city"].stringValue,
                            fromCounty:stat["county"].stringValue,
                            fromState:stat["state"].stringValue,
                            fromZipCode:stat["zipcode"].stringValue)
                        
                        //stationList[newStation.name] = newStation
                        self.stations[stationName] = newStation
                    }
                }
                else
                {
                    let err = "description: \(error?.localizedDescription)\ninfo: \(error?.userInfo)"
                    
                    var x :Float = 4.5
                    
                    x = x+3
                    
                }
            }
        }
    }
    
}