//
//  ExampleChildViewController.swift
//  KBart
//
//  Created by KenCeglia on 3/22/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

class ExampleChildViewController: UIViewController {
    
    var pViewController:UIViewController?
    
    convenience init(forController _forController:UIViewController)
    {
        self.init(nibName : "ExampleChildViewController", bundle : nil)
        self.pViewController = _forController
    }
    @IBAction func OnClose(sender: AnyObject)
    {
        self.CloseView()
    }
    
    func ShowView()
    {
        self.pViewController?.view.addSubview(self.view)
        /*
        dispatch_async(dispatch_get_main_queue(),
        {
        self.pViewController?.view.addSubview(self.view)
        self.view.transform = CGAffineTransformMakeScale(0.0, 0.0)
        self.view.alpha = 0
        UIView.animateWithDuration(0.25, animations:
        {
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        })
        })
        */
        
    }
    func CloseView()
    {
        self.view.removeFromSuperview()
        /*
        dispatch_async(dispatch_get_main_queue(),
        {
        /*
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        UIView.animateWithDuration(2.0, animations:
        {
        self.view.alpha = 0;
        self.view.transform = CGAffineTransformMakeScale(0, 0);
        })
        */
        self.view.removeFromSuperview()
        })
        */
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
