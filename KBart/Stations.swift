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
    
    subscript(key: Int) -> DepartingTrain
        {
            var Stat : DepartingTrain = departingTrainsArray[key]
            return Stat
    }
}

class DepartureStations
{
    var departureStations:[String:DepartureStation]
    var departureStationArray : [DepartureStation]
    var trainStationAbbr:String
    
    init()
    {
        self.departureStations = [:]
        self.departureStationArray = [DepartureStation]()
        
        trainStationAbbr = ""
    }
    init(fromStationAbbrev _trainStationAbbrev:String, updateNow _update:Bool = false)
    {
        self.departureStations = [:]
        self.departureStationArray = [DepartureStation]()
        
        trainStationAbbr = _trainStationAbbrev
        
        if(_update)
        {
            UpdateEDT()
        }
    }
    
    subscript(key: String) -> DepartureStation
        {
            var Stat : DepartureStation = departureStations[key]!
            return Stat
    }
    subscript(key: Int) -> DepartureStation
        {
            var Stat : DepartureStation = departureStationArray[key]
            return Stat
    }
    
    func UpdateEDT(fromStationAbbrev _trainStationAbbrev:String)
    {
        trainStationAbbr = _trainStationAbbrev
        UpdateEDT()
    }
    func UpdateEDT()
    {
        departureStations.removeAll()
        departureStationArray.removeAll()
        
        let urlPath:String = "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=\(trainStationAbbr)&key=\(BARTAPI_LIC_KEY)"
        
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        
        var errorData: NSError?
        if let doc = AEXMLDocument(xmlData: dataVal, error: &errorData)
        {
            var parsedText = String()
            
            if(doc["root"]["station"]["etd"].all != nil)
            {
                for stat in doc["root"]["station"]["etd"].all!
                {
                    var departingStationKey = stat["abbreviation"].stringValue
                    
                    var newStation :DepartureStation = DepartureStation()
                    
                    newStation.name = stat["destination"].stringValue
                    newStation.abbr = stat["abbreviation"].stringValue
                    
                    if(stat["estimate"].all != nil)
                    {
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
                    }
                    else
                    {
                        var msg:String = "Departing Station \(departingStationKey) has no trains"
                        println(msg)
                    }
                    self.departureStations[departingStationKey] = newStation
                    self.departureStationArray.append(newStation)
                }
            }
            else
            {
                var msg:String = "Station \(trainStationAbbr) has no departures"
                println(msg)
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
    var name : String = ""
    var abbr : String = ""
    var gtfs_latitude : String = ""
    var gtfs_longitude : String = ""
    var address : String = ""
    var city : String = ""
    var county : String = ""
    var state : String = ""
    var zipcode : String = ""
    
    init()
    {
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
    
    var stations:[String:Station] = [:]
    var stationArray : [Station] = [Station]()
    
    init()
    {
        
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
            if(doc["root"]["stations"]["station"].all != nil)
            {
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
                    
                    self.stations[stationKey] = newStation
                    self.stationArray.append(newStation)
                }
            }
            else
            {
                var msg:String = "There are no BART Stations retrieved"
                println(msg)
            }
        }
        else
        {
            let err = "description: \(errorData?.localizedDescription)\ninfo: \(errorData?.userInfo)"
        }
    }
    
    
}