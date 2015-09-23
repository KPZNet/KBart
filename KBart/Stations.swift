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
    let url: NSURL = NSURL(string: urlPath)!
    let request1: NSURLRequest = NSURLRequest(URL: url)
    let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
    let dataVal: NSData =  try! NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
    
    return dataVal
}
func CallBARTAPI_Stations_Asynch(handler: (StationList) -> Void)
{
    
    let url:NSURL = NSURL(string:"http://api.bart.gov/api/stn.aspx?cmd=stns&key=\(BARTAPI_LIC_KEY)")!
    let request:NSURLRequest = NSURLRequest(URL:url)
    let queue:NSOperationQueue = NSOperationQueue()
    
    NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:
        { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            let doc = try! AEXMLDocument(xmlData: data!)
            let stationList : StationList = StationList()
            Load_AEXML_into_BART_Stations(fromAEXMLDocument: doc, withStationList: stationList)
            handler(stationList)
    })
}

func Load_AEXML_into_BART_Stations(fromAEXMLDocument doc : AEXMLDocument, withStationList _stationList:StationList) -> StationList
{
    
    // parse known structure
    if(doc["root"]["stations"]["station"].all != nil)
    {
        for stat in doc["root"]["stations"]["station"].all!
        {
            let stationKey = stat["abbr"].stringValue
            
            let newStation :Station = Station(  fromName:stat["name"].stringValue,
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
        let msg:String = "There are no BART Stations retrieved"
        print(msg)
    }
    
    return _stationList
    
}
func GetBARTStationsLive() -> StationList
{
    
    let data = CallBARTAPI_Stations();
    let doc = try! AEXMLDocument(xmlData: data)
    let stationList:StationList = StationList()
    Load_AEXML_into_BART_Stations(fromAEXMLDocument: doc, withStationList: stationList)
    return stationList
}
func ReadBARTStationsFromFile() -> StationList
{
    let xmlPath = NSBundle.mainBundle().pathForResource("BARTStations", ofType: "xml")
    let data = NSData(contentsOfFile: xmlPath!)
    let doc = try! AEXMLDocument(xmlData: data!)
    let stationList:StationList = StationList()
    Load_AEXML_into_BART_Stations(fromAEXMLDocument: doc, withStationList: stationList)
    return stationList
}




func CallBARTAPI_ETD(forStation _forStation : String) -> NSData
{
    let urlPath:String = "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=\(_forStation)&key=\(BARTAPI_LIC_KEY)"
    
    let url: NSURL = NSURL(string: urlPath)!
    let request1: NSURLRequest = NSURLRequest(URL: url)
    let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
    let dataVal: NSData =  try! NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
    
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
            let departingStationKey = stat["abbreviation"].stringValue
            
            let newStation :DestinationStation = DestinationStation()
            
            newStation.name = stat["destination"].stringValue
            newStation.abbr = stat["abbreviation"].stringValue
            
            if(stat["estimate"].all != nil)
            {
                for train in stat["estimate"].all!
                {
                    let newTrain :DepartingTrain = DepartingTrain()
                    
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
                let msg:String = "Departing Station \(departingStationKey) has no trains"
                print(msg)
            }
            _destinationStations.stations[departingStationKey] = newStation
            _destinationStations.stationArray.append(newStation)
        }
    }
    else
    {
        let msg:String = "Station \(_destinationStations.stationAbbr) has no departures"
        print(msg)
    }
    
    return _destinationStations
}

func GetDestinationStations(forStationAbbr _forStationAbbr:String) -> DestinationStations
{
    let data = CallBARTAPI_ETD(forStation:_forStationAbbr);
    let doc = try! AEXMLDocument(xmlData: data)
    let stationList:DestinationStations = DestinationStations(forStation:_forStationAbbr)
    Load_AEXML_into_DestinationStations(fromAEXMLDocument: doc, withDestinationStations: stationList)
    return stationList
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
    
    var trainArray : [DepartingTrain] = [DepartingTrain]()
    
    init()
    {
        name = "name"
        abbr = "abbr"
    }
    func NumberOfTrains() -> Int
    {
        return trainArray.count
    }
    subscript(key: Int) -> DepartingTrain?
        {
            var returnStat : DepartingTrain?
            
            if( key <= (NumberOfTrains()-1) )
            {
                returnStat = trainArray[key]
            }
            return returnStat
    }
}

class DestinationStations
{
    var stations:[String:DestinationStation] = [:]
    var stationArray : [DestinationStation] = [DestinationStation]()
    var stationAbbr:String = ""
    
    func NumberOfStations() -> Int
    {
        return stations.count
    }
    
    init(forStation _forStationAbbrev:String)
    {
        stationAbbr = _forStationAbbrev
    }
    
    subscript(key: String) -> DestinationStation
        {
            let Stat : DestinationStation = stations[key]!
            return Stat
    }
    subscript(key: Int) -> DestinationStation
        {
            let Stat : DestinationStation = stationArray[key]
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
            let Stat : Station = stations[key]!
            return Stat
    }
    subscript(key: Int) -> Station
        {
            let Stat : Station = stationArray[key]
            return Stat
    }
    
    func NumberOfStations() -> Int
    {
        return stations.count
    }
    
    
}