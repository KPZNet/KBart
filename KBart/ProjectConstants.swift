//
//  ProjectConstants.swift
//  KBart
//
//  Created by KenCeglia on 3/18/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import Foundation
import UIKit


let BARTAPI_LIC_KEY:String = "ZUKP-YX9M-Q5DQ-8UTV"


func ClassName(forObject _forObject:Any) -> String
{
    return _stdlib_getDemangledTypeName(_forObject).componentsSeparatedByString(".").last!
}

