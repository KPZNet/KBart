//
//  FirstViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/17/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController
{
    var ktView:KTViewController = KTViewController(nibName : "KTViewController", bundle : nil)
    
    @IBAction func OnKTView(sender: AnyObject)
    {
        dispatch_async(dispatch_get_main_queue(),
            {
                self.view.addSubview(self.ktView.view)
                self.ktView.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.ktView.view.alpha = 0
                UIView.animateWithDuration(0.25, animations:
                    {
                    self.ktView.view.alpha = 1;
                    self.ktView.view.transform = CGAffineTransformMakeScale(1, 1);
                })
        })
        
        
        var st:String = _stdlib_getDemangledTypeName(ktView).componentsSeparatedByString(".").last!
        
        

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    @IBAction func checkStations(sender: AnyObject)
    {
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let aVariable = appDelegate.stationList
//        
//        var stat : Station = aVariable["K"]
    }
}

