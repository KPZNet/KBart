//
//  InitializingAppStatusView.swift
//  KBart
//
//  Created by KenCeglia on 3/23/15.
//  Copyright (c) 2015 KenCeglia. All rights reserved.
//

import UIKit

let XIB_NAME_InitializingAppStatusView:String = "InitializingAppStatusView"

class InitializingAppStatusView: UIViewController {
    
    fileprivate var viewPlacement : ViewPlacementEnum = ViewPlacementEnum.top
    fileprivate var customPlacement : CGFloat = 0.0
    
    var cancelCallback: ( () -> Void )?
    
    var pViewController:UIViewController?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func OnCancel(_ sender: AnyObject)
    {
        if let cC = cancelCallback
        {
            cC()
        }
    }
    
    
    convenience init(forController _forController:UIViewController, CancelHandler _cancelHandler: @escaping () -> Void, ViewPlacement _placement:ViewPlacementEnum = .top, CustomPlacement _customPlacement:CGFloat = 0.0)
    {
        self.init(nibName : XIB_NAME_InitializingAppStatusView, bundle : nil)
        self.pViewController = _forController
        
        cancelCallback = _cancelHandler
        Placement(Placement: _placement, CustomPlacement: _customPlacement)
    }
    
    func SetCancelHandler(handler _handler: @escaping () -> Void)
    {
       cancelCallback = _handler
    }
    
    func Placement(Placement _placement:ViewPlacementEnum, CustomPlacement _customPlacement:CGFloat = 0.0)
    {
        viewPlacement = _placement
        customPlacement = _customPlacement
    }
    
    fileprivate func PlaceView()
    {
        let pViewHeight : CGFloat = pViewController!.view!.bounds.height
        let selfHalfHeight : CGFloat = self.view.bounds.height / 2
        
        switch viewPlacement
        {
        case ViewPlacementEnum.top:
            self.view.center = pViewController!.view!.center
            self.view.center.y = selfHalfHeight + (pViewHeight * 0.1)
            
        case ViewPlacementEnum.center:
            self.view.center = pViewController!.view!.center
            
        case ViewPlacementEnum.bottom:
            self.view.center = pViewController!.view!.center
            self.view.center.y = (pViewHeight - (pViewHeight * 0.1)) - selfHalfHeight
            
        case ViewPlacementEnum.custom:
            self.view.center = pViewController!.view!.center
            self.view.center.y = selfHalfHeight + (pViewHeight * customPlacement)

        }
    }
    
    func ShowView()
    {
        self.pViewController?.view.addSubview(self.view)
        PlaceView()
        
        activityIndicator.startAnimating()
        
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
    
    func SetRoundedViewBox(forView _forView:UIView)
    {
        _forView.layer.cornerRadius = 5.0
        _forView.layer.masksToBounds = true
        _forView.layer.borderWidth = 0.5
        _forView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SetRoundedViewBox(forView: self.view)
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
