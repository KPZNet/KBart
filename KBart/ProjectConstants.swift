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

enum ViewPlacementEnum {case top, center, bottom, custom}

func ClassName(forObject _forObject:Any) -> String
{
    return "" //_stdlib_getDemangledTypeName(_forObject).componentsSeparatedByString(".").last!
}

func SetRoundedViewBox(forView _forView:UIView)
{
    _forView.layer.cornerRadius = 5.0
    _forView.layer.masksToBounds = true
    _forView.layer.borderWidth = 0.5
    _forView.layer.borderColor = UIColor.black.cgColor
}

func SetRoundedButton(forButton _forButton:UIButton)
{
    _forButton.layer.cornerRadius = 5.0
    _forButton.layer.masksToBounds = true
    _forButton.layer.borderWidth = 0.5
    _forButton.layer.borderColor = UIColor.black.cgColor
}
