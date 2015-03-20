//
//  Stations.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import Foundation

class DepartingTrain
{
    
    var minutes : String
    var platform : String
    var direction : String
    var length : String
    var lineColor : String
    var lineColorHex : String
    var bike : String
    
    init()
    {
        minutes = "minutes"
        platform = "platform"
        direction = "direction"
        length = "length"
        lineColor = "line color"
        lineColorHex = "line color hex"
        bike = "bike flag"
    }
}

class DepartureStation
{
    var name:String
    var abbr:String
    
    var departingTrainsArray : [DepartingTrain]
    
    init()
    {
        name = "name"
        abbr = "abbr"
        
        self.departingTrainsArray = [DepartingTrain]()
    }
}

class DepartureStations
{
    var departureStations:[String:DepartureStation]
    var departureStationsArray : [DepartureStation]
    var stationAbbrev:String
    
    init()
    {
        self.departureStations = [:]
        self.departureStationsArray = [DepartureStation]()
        
        stationAbbrev = ""
    }
    init(fromStationAbbrev _stationAbbrev:String, updateNow _update:Bool = false)
    {
        self.departureStations = [:]
        self.departureStationsArray = [DepartureStation]()
        
        stationAbbrev = _stationAbbrev
        
        if(_update)
        {
            UpdateEDT()
        }
    }
    
    func UpdateEDT(fromStationAbbrev _fromStationAbbrev:String)
    {
        stationAbbrev = _fromStationAbbrev
        UpdateEDT()
    }
    func UpdateEDT()
    {
        departureStations.removeAll()
        departureStationsArray.removeAll()
        
        let urlPath:String = "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=\(stationAbbrev)&key=\(BARTAPI_LIC_KEY)"
        
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        
        var errorData: NSError?
        if let doc = AEXMLDocument(xmlData: dataVal, error: &errorData)
        {
            var parsedText = String()
            
            for stat in doc["root"]["station"]["etd"].all!
            {
                var departingStationKey = stat["abbreviation"].stringValue
                
                var newStation :DepartureStation = DepartureStation()

                newStation.name = stat["destination"].stringValue
                newStation.abbr = stat["abbreviation"].stringValue
                
                for train in stat["estimate"].all!
                {
                    var newTrain :DepartingTrain = DepartingTrain()
                    
                    newTrain.minutes = train["minutes"].stringValue
                    newTrain.platform = train["platform"].stringValue
                    newTrain.direction = train["direction"].stringValue
                    newTrain.length = train["length"].stringValue
                    newTrain.lineColor = train["color"].stringValue
                    newTrain.lineColorHex = train["hexcolor"].stringValue
                    newTrain.bike = train["bikeflag"].stringValue
                    
                    newStation.departingTrainsArray.append(newTrain)
                }
                self.departureStations[departingStationKey] = newStation
                self.departureStationsArray.append(newStation)
            }
        }
        else
        {
            let err = "description: \(errorData?.localizedDescription)\ninfo: \(errorData?.userInfo)"
        }
        
    }
}



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
    
    var departingStations:DepartureStations
    
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
        
        departingStations = DepartureStations()
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
        
        departingStations = DepartureStations()
    }
}

class StationList
{
    
    var stations:[String:Station]
    var stationArray : [Station]
    
    init()
    {
        //Create an empty station list
        self.stations = [:]
        stationArray = [Station]()
    }
    
    subscript(key: String) -> Station
        {
            var Stat : Station = stations[key]!
            return Stat
    }
    subscript(key: Int) -> Station
        {
            var Stat : Station = stationArray[key]
            return Stat
    }
    
    func NumberOfStations() -> Int
    {
        return stations.count
    }
    
    
    
    func ReadStations_AEXML()
    {
        
        let urlPath:String = "http://api.bart.gov/api/stn.aspx?cmd=stns&key=\(BARTAPI_LIC_KEY)"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        
        
        var errorData: NSError?
        if let doc = AEXMLDocument(xmlData: dataVal, error: &errorData)
        {
            var parsedText = String()
            // parse known structure
            for stat in doc["root"]["stations"]["station"].all!
            {
                var stationKey = stat["abbr"].stringValue
                
                var newStation :Station = Station(  fromName:stat["name"].stringValue,
                    fromAbbr:stat["abbr"].stringValue,
                    fromLatitude:stat["gtfs_latitude"].stringValue,
                    fromLongitude:stat["gtfs_longitude"].stringValue,
                    fromAddress:stat["address"].stringValue,
                    fromCity:stat["city"].stringValue,
                    fromCounty:stat["county"].stringValue,
                    fromState:stat["state"].stringValue,
                    fromZipCode:stat["zipcode"].stringValue)
                
                newStation.departingStations.UpdateEDT(fromStationAbbrev: stationKey)
                
                self.stations[stationKey] = newStation
                self.stationArray.append(newStation)
            }
        }
        else
        {
            let err = "description: \(errorData?.localizedDescription)\ninfo: \(errorData?.userInfo)"
        }
    }
    
    
}