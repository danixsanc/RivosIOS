//
//  ContactViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 22/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import TextFieldEffects
class ContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mycell:MyTableViewCell!
    let a = "Asistencia telefónica"
    let b = "Preguntas frecuentes"
    let c = "Contáctanos"
    let d = "Acerca De"

    
    var menuItems:[String] = [];
    var menuIcons = ["ic_phone_in_talk", "ic_question_answer", "ic_inbox", "ic_description"];
    
         override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            //itemsTable
            menuItems.insert(a, atIndex: 0)
            menuItems.insert(b, atIndex: 1)
            menuItems.insert(c, atIndex: 2)
            menuItems.insert(d, atIndex: 3)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    //Table functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return menuItems.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        mycell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! MyTableViewCell
        
        var bleachimage = UIImage(named: menuIcons[indexPath.row])
        mycell.imageView?.image  = bleachimage
        
        mycell.helpItemLabel.text = menuItems[indexPath.row]
        

        return mycell;
    }
    

    
   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        

        switch(indexPath.row)
        {
            
        case 0:
            
            let phone = "tel://6673171415";
            let url:NSURL = NSURL(string:phone)!;
            UIApplication.sharedApplication().openURL(url);
            
            break;
            
        case 1:
            
            self.performSegueWithIdentifier("question_answer", sender: indexPath)
            break;

            
        case 2:
       
            let email = "yozzibeens@gmail.com"
            let url = NSURL(string: "mailto:\(email)")
            UIApplication.sharedApplication().openURL(url!)
            break;
        case 3:
           self.performSegueWithIdentifier("acerca_de", sender: indexPath)
            break;
            
        default:
            print("\(menuItems[indexPath.row]) is selected");
            
        }
    }
     //end
}
