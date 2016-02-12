//
//  CodeModifyViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 13/11/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit


class CodeModifyViewController: UIViewController {

    @IBOutlet weak var codeText: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ModifyDataReal(sender: UIBarButtonItem) {
        
        //let tagCode = "Code" //Client_ID and Code
        
        let tagCode = "Code";
        let cod = codeText.text!
        let c = "24";
        
        do {
            let post:NSString = "Tag=\(tagCode)&Client_Id=\(c)&Code=\(cod)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string:"http://appm.rivosservices.com/")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    //var error: NSError?
                    
                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    
                    
                    
                    let success:NSInteger = jsonData.valueForKey("Success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Exito"
                        alertView.message = "Codigo correcto"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show();
                        let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("ModifyDataViewController") as! ModifyDataViewController
                        let loginPageNav = UINavigationController(rootViewController: loginPage)
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.window?.rootViewController = loginPageNav
                        print("yeah")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["Error_Msg"] as? NSString != nil {
                            error_msg = jsonData["Error_Msg"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                let alertView: UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } catch {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Server Error"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
    }

}
