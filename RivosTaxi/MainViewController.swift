//
//  MainViewController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 12/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class MainViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
        
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        
        if(isUserLoggedIn)
        {
            NSLog("Login SUCCESS");
            
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            prefs.setInteger(1, forKey: "isUserLoggedIn")
            prefs.synchronize()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }


    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Verificar login con fb
        if(FBSDKAccessToken.currentAccessToken() != nil)
        {
            NSLog("Login SUCCESS");
            
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

            prefs.setInteger(1, forKey: "isUserLoggedIn")
            prefs.synchronize()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        
    }
    
       
    

}
