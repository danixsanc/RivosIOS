//
//  ConektaViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 30/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit
import CoreData



class ConektaViewController: UIViewController, UITextFieldDelegate {
  
    let moc = DataController().managedObjectContext
    let dropDown = DropDown()
    var tokenID = ""
    var client_card_number = ""
    var client_card_name = ""
    var client_card_cvc = ""
    var client_card_expMonth = ""
    var client_card_expYear = ""
    var client_pay_email = ""
    var client_pay_phone = ""
    var driver_name = ""
    
    var latitude_ini = 0.0
    var longitude_ini = 0.0
    var latitude_fin = 0.0
    var longitude_fin = 0.0
    var travel_price = ""
    
    var C_Id = ""
    
    @IBOutlet weak var Month: UIButton!
    @IBOutlet weak var CardNumber: UITextField!
    @IBOutlet weak var card_name: UITextField!
    
    @IBOutlet weak var ExpTime: UITextField!
    @IBOutlet weak var CVV: UITextField!
    
    
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ConektaPay(sender: AnyObject) {
        ConektaPay()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.dataSource = [
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10",
            "11",
            "12"
        ]
        
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.Month.setTitle(item, forState: .Normal)
        }
        dropDown.anchorView = Month
        dropDown.bottomOffset = CGPoint(x: 0, y:Month.bounds.height)
        
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == CardNumber
        {
            
        
            //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
            if range.length > 0
            {
                return true
            }
        
            //Dont allow empty strings
            if string == " "
            {
                return false
            }
        
            //Check for max length including the spacers we added
            if range.location == 20
            {
                return false
            }
        
        }
        if textField == ExpTime
        {
            //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
            if range.length > 0
            {
                return true
            }
            
            //Dont allow empty strings
            if string == " "
            {
                return false
            }
            
            //Check for max length including the spacers we added
            if range.location == 4
            {
                return false
            }
        }
        if textField == CVV
        {
            //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
            if range.length > 0
            {
                return true
            }
            
            //Dont allow empty strings
            if string == " "
            {
                return false
            }
            
            //Check for max length including the spacers we added
            if range.location == 4
            {
                return false
            }
        }
        return true
    }
    
    
    
    //dismiss keyboard with touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }
    
    
    //dismiss keyboard with return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
        
        
    }
    
 
    
    func Pay(){
        
        fetchProfile()
        
        let tag = "Process_Pay";
        let
        price = "500"
        let Name = card_name.text!
        
      
        
        do {
            let post:NSString = "Tag=\(tag)&Token=\(tokenID)&Price=\(price)&Name=\(Name)&Email=\(client_pay_email)&Phone=\(client_pay_phone)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string:"http://appm.rivosservices.com/conekta/proces_pay.php")!
            
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
                    
                    //let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: .MutableContainers) as? NSDictionary
                    
                    
                    
                    //******************************************************************
                    
                    let success:NSInteger = jsonData!.valueForKey("Success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        
                        
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData!["error_message"] as? NSString != nil {
                            error_msg = jsonData!["error_message"] as! NSString
                        } else {
                            error_msg = "No se ha encontrado registros"
                            
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Fallo"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Connection Failed"
                    alertView.message = "Verifique su conexion a internet"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                let alertView: UIAlertView = UIAlertView()
                alertView.title = "Connection Failed"
                alertView.message = "La conexion fallo, verifique que este conectado a internet"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } catch {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Connection Failed"
            alertView.message = "Server Error"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
    
    func ConektaPay(){
        client_card_number = CardNumber.text!
        client_card_name = card_name.text!
        client_card_cvc = CVV.text!
        client_card_expMonth = (Month.titleLabel?.text!)!
        client_card_expYear = ExpTime.text!
        
        let conekta = Conekta()
        
        conekta.delegate = self
        
        conekta.publicKey = "key_H9xwdHFLt9Vy9vYMh1DP3zw"
        
        conekta.collectDevice()
        
        let card = conekta.Card()
        
        card.setNumber(client_card_number, name: client_card_name, cvc: client_card_cvc, expMonth: client_card_expMonth, expYear: client_card_expYear)
        
        let token = conekta.Token()
        
        token.card = card
        
        token.createWithSuccess({ (data) -> Void in
            print(data)
            if let tok = data["id"]
            {
                self.tokenID = tok as! String
                self.Pay()
                
                print(self.tokenID)
            }else{
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Aviso"
                alertView.message = "Tarjeta invalida, Verifique que los datos proporcionados son correctos"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()

            }
            }, andError: { (error) -> Void in
                print(error)
        })
        
    }
    
    @IBAction func showOrDismiss(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    @IBAction func viewTapped() {
        view.endEditing(false)
    }
    
    func fetchProfile(){
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Perfil")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute Fetch Request
        do {
            let result = try moc.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                if let email = managedObject.valueForKey("email"), phone = managedObject.valueForKey("phone") {
                    print("\(email) \(phone)")
                    
                   self.client_pay_email = email as! String
                    self.client_pay_phone = phone as! String
                    //userName!.text = name as? String
                    // profileImg.image = userImage as? UIImage
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func dataGetCloseCabbie(){
        
        
        let tag = "GetCloseCabbie";
        //let ci = LoginPageViewController().fetch() as! String
        
        
        do {
            let post:NSString = "Tag=\(tag)&Latitude=\(latitude_ini)&Longitude=\(longitude_ini)"
            
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
                        driver_name = ((jsonData as NSDictionary)["Cabbie1"] as! NSDictionary) ["Name"] as! String
                        print("El nombre es = \(driver_name)")
                        
                        print(jsonData)
                        SwiftLoading().showLoading()
                        //Set_Request()
                        SwiftLoading().hideLoading()
                        //self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
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
    
    func Set_Request() {
        let tag = "Set_Client_History";
        //let ci = LoginPageViewController().fetch() as! String
        
        fetch()
        let cabbie_id =  "4";
        
        let price_id = "1";
        let lat = "24.764023";
        let lon = "-107.469505";
        
        let lat_f = "24.8206139";
        let lon_f = "-107.4250127";
        
        do {
            let post:NSString = "Tag=\(tag)&Latitude_In=\(lat)&Longitude_In=\(lon)&Latitude_Fn=\(lat_f)&Longitude_Fn=\(lon_f)&Client_Id=\(C_Id)&Cabbie_Id=\(cabbie_id)&Price_Id=\(price_id)"
            
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
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        self.performSegueWithIdentifier("UnwindBackToProtectedPage", sender: self)
                        
                        
                        print("PayPal Payment Success !")
                        
                        //self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
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

    func fetch() {
        
        let userFetch = NSFetchRequest(entityName: "User")
        
        var fetchedUser:[User]
        
        do {
            
            
            fetchedUser = try moc.executeFetchRequest(userFetch) as! [User]
            
            print(fetchedUser.first!.valueForKey("client_id")!)
            C_Id = fetchedUser.first!.valueForKey("client_id")! as! String
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
        
    }



    
}