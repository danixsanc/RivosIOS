//
//  AcercaDeViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 30/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit

class AcercaDeViewController: UIViewController  {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Exit(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }

    
 


}
