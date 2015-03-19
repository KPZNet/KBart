//
//  Stations.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import Foundation

//class DepartureStation
//{
//    var minutes : String
//    var platform : String
//    var direction : String
//    var length : String
//    var lineColor : String
//    var lineColorHex : String
//    var bikeFlat : String
//}
//class DepartureStations
//{
//    var departureStations:[String:DepartureStation]
//    var departureStationsArray : [DepartureStation]
//    
//    init()
//    {
//        self.departureStations = [:]
//        self.departureStationsArray = [DepartureStation]()
//    }
//}



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