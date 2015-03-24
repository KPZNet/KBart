//
//  Stations.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import Foundation

func CallBARTAPI_Stations() -> NSData
{
    let urlPath:String = "http://api.bart.gov/api/stn.aspx?cmd=stns&key=\(BARTAPI_LIC_KEY)"
    var url: NSURL = NSURL(string: urlPath)!
    var request1: NSURLRequest = NSURLRequest(URL: url)
    var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
    var error: NSErrorPointer = nil
    var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
    
    return dataVal
}

func Load_AEXML_into_BART_Stations(fromAEXMLDocument doc : AEXMLDocument, withStationList _stationList:StationList) -> StationList
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
            
            _stationList.stations[stationKey] = newStation
            _stationList.stationArray.append(newStation)
        }
    }
    else
    {
        var msg:String = "There are no BART Stations retrieved"
        println(msg)
    }
    
    return _stationList
    
}
func GetBARTStationsLive() -> StationList
{
    sleep(10)
    var data = CallBARTAPI_Stations();
    var errorData: NSError?
    var doc = AEXMLDocument(xmlData: data, error: &errorData)!
    var stationList:StationList = StationList()
    Load_AEXML_into_BART_Stations(fromAEXMLDocument: doc, withStationList: stationList)
    return stationList
}
func GetBARTStationsFile() -> StationList
{
    let xmlPath = NSBundle.mainBundle().pathForResource("BARTStations", ofType: "xml")
    let data = NSData(contentsOfFile: xmlPath!)
    var errorData: NSError?
    var doc = AEXMLDocument(xmlData: data!, error: &errorData)!
    var stationList:StationList = StationList()
    Load_AEXML_into_BART_Stations(fromAEXMLDocument: doc, withStationList: stationList)
    return stationList
}

func GetBARTStationsLiveAsynch(handler: (StationList) -> Void)
{
    
    let url:NSURL = NSURL(string:"http://api.bart.gov/api/stn.aspx?cmd=stns&key=\(BARTAPI_LIC_KEY)")!
    let request:NSURLRequest = NSURLRequest(URL:url)
    let queue:NSOperationQueue = NSOperationQueue()
    let queuebert = dispatch_get_main_queue()
    
    NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:
        { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var errorData: NSError?
            var doc = AEXMLDocument(xmlData: data, error: &errorData)!
            var stationList : StationList = StationList()
            Load_AEXML_into_BART_Stations(fromAEXMLDocument: doc, withStationList: stationList)
            handler(stationList)
    })
}


func CallBARTAPI_ETD(forStation _forStation : String) -> NSData
{
    let urlPath:String = "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=\(_forStation)&key=\(BARTAPI_LIC_KEY)"
    
    var url: NSURL = NSURL(string: urlPath)!
    var request1: NSURLRequest = NSURLRequest(URL: url)
    var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
    var error: NSErrorPointer = nil
    var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
    
    return dataVal
}

func Load_AEXML_into_DestinationStations(fromAEXMLDocument doc : AEXMLDocument, withDestinationStations _destinationStations:DestinationStations) -> DestinationStations
{
    _destinationStations.stations.removeAll()
    _destinationStations.stationArray.removeAll()
    
    
    if(doc["root"]["station"]["etd"].all != nil)
    {
        for stat in doc["root"]["station"]["etd"].all!
        {
            var departingStationKey = stat["abbreviation"].stringValue
            
            var newStation :DestinationStation = DestinationStation()
            
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
                    
                    newStation.trainArray.append(newTrain)
                }
            }
            else
            {
                var msg:String = "Departing Station \(departingStationKey) has no trains"
                println(msg)
            }
            _destinationStations.stations[departingStationKey] = newStation
            _destinationStations.stationArray.append(newStation)
        }
    }
    else
    {
        var msg:String = "Station \(_destinationStations.stationAbbr) has no departures"
        println(msg)
    }
    
    return _destinationStations
}

func GetDestinationStations(forStation _forStation:String) -> DestinationStations
{
    var data = CallBARTAPI_ETD(forStation:_forStation);
    var errorData: NSError?
    var doc = AEXMLDocument(xmlData: data, error: &errorData)!
    var stationList:DestinationStations = DestinationStations(forStation:_forStation)
    Load_AEXML_into_DestinationStations(fromAEXMLDocument: doc, withDestinationStations: stationList)
    return stationList
}

func GetDestinationStationsAsynch(forStation _forStation:String, handler: (DestinationStations) -> Void)
{
    
    let url:NSURL = NSURL(string:"http://api.bart.gov/api/etd.aspx?cmd=etd&orig=\(_forStation)&key=\(BARTAPI_LIC_KEY)")!
    let request:NSURLRequest = NSURLRequest(URL:url)
    let queue:NSOperationQueue = NSOperationQueue()
    
    NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:
        { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var errorData: NSError?
            var doc = AEXMLDocument(xmlData: data, error: &errorData)!
            var stationList:DestinationStations = DestinationStations(forStation: _forStation)
            Load_AEXML_into_DestinationStations(fromAEXMLDocument: doc, withDestinationStations: stationList)
            handler(stationList)
    })
}


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

class DestinationStation
{
    var name:String
    var abbr:String
    
    var trainArray : [DepartingTrain]
    
    init()
    {
        name = "name"
        abbr = "abbr"
        
        self.trainArray = [DepartingTrain]()
    }
    
    subscript(key: Int) -> DepartingTrain
        {
            var Stat : DepartingTrain = trainArray[key]
            return Stat
    }
}

class DestinationStations
{
    var stations:[String:DestinationStation] = [:]
    var stationArray : [DestinationStation] = [DestinationStation]()
    var stationAbbr:String = ""
    
    
    init(forStation _forStationAbbrev:String)
    {
        stationAbbr = _forStationAbbrev
    }
    
    subscript(key: String) -> DestinationStation
        {
            var Stat : DestinationStation = stations[key]!
            return Stat
    }
    subscript(key: Int) -> DestinationStation
        {
            var Stat : DestinationStation = stationArray[key]
            return Stat
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
    
    
}