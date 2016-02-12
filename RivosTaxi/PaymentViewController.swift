//
//  PaymentViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 22/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class PaymentViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var mycell:MyTableViewCell!
    
    let a = "Salida"
    let b = "Destino"
    let c = "Precio"
    
   
    
    var latitude_Salida = 0.0
    var longitude_Salida = 0.0
    var latitude_Destino = 0.0
    var longitude_Destino = 0.0
    
    let moc = DataController().managedObjectContext
    var C_Id = ""
    
    @IBOutlet weak var payPalButton: UIButton!
    
    var driver_name = ""
    

    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    @IBOutlet weak var taxista: UILabel!
    @IBOutlet weak var salida: UILabel!
    @IBOutlet weak var destino: UILabel!
    @IBOutlet weak var price: UILabel!
    

    
    var menuItems:[String] = [];
    var menuIcons = ["ic_flight_takeoff", "ic_flight_land", "ic_attach_money"];
    

    
    
    var precio = ""

   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        dataPay()
        setUsersClosestCityDestino()
        setUsersClosestCitySalida()
        

        


        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
      

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ConektaPay" {
            let PayView: ConektaViewController = segue.destinationViewController as! ConektaViewController
            PayView.latitude_fin = latitude_Destino
            PayView.longitude_fin = longitude_Destino
            PayView.latitude_ini = latitude_Salida
            PayView.longitude_ini = longitude_Salida
            
        }
    }
    
    
    
    
    
    func setUsersClosestCityDestino()
    {
        let geoCoder = CLGeocoder()
        //let locationManager = CLLocationManager()
        
        //error
        let Coordinates_ini = CLLocation(latitude:latitude_Destino , longitude: longitude_Destino )
        
        geoCoder.reverseGeocodeLocation(Coordinates_ini)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // Address dictionary
                print(placeMark.addressDictionary)
                
                
                // Location name
                if let locationName = placeMark.addressDictionary?["Name"] as? NSString
                {
                    print(locationName)
                    self.destino.text = locationName as String
                    
                }
                
                
        }
        
    }
    
    func setUsersClosestCitySalida()
    {
        let geoCoder = CLGeocoder()
        //let locationManager = CLLocationManager()
        
        
        
        //error
        let Coordinates_ini = CLLocation(latitude:latitude_Salida, longitude: longitude_Salida)
        
        geoCoder.reverseGeocodeLocation(Coordinates_ini)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // Address dictionary
                print(placeMark.addressDictionary)
                
                
                // Location name
                if let locationName = placeMark.addressDictionary?["Name"] as? NSString
                {
                    print(locationName)
                   self.salida.text = locationName as String

                }
                
                SwiftLoading().hideLoading()
        }
        
    }
    
    
    
    func dataPay(){
        
        
        let tag = "GetPriceOfTravel";
        
        let lat = "\(latitude_Destino)"
        let lon = "\(longitude_Destino)"
        
        do {
            let post:NSString = "Tag=\(tag)&Latitude=\(lat)&Longitude=\(lon)"
            
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
                        
                        precio = (jsonData as NSDictionary) ["Price"] as! String
                        print("El precio es: \(precio)")
                        
                        //label
                        
                        price.text = (jsonData as NSDictionary) ["Price"] as! String
                        

                        print("El precio es: \(price)")
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                    }else if(success == 0){
                        
                        precio = (jsonData as NSDictionary) ["Price_D"] as! String
                        print("El precio es: \(precio)")
                        
                        //label
                        
                        price.text = (jsonData as NSDictionary) ["Price_D"] as! String
                        
                        
                        print("El precio es: \(price)")
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }else {
                        var error_msg:NSString
                        
                        if jsonData["Error_Msg"] as? NSString != nil {
                            error_msg = jsonData["Error_Msg"] as! NSString
                        } else {
                            error_msg = "Actualmente el servicio de RivosTaxi no esta disponible en su localizacion"
                            payPalButton.enabled = false
                            
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Lo sentimos"
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
    
    
    func dataGetCloseCabbie(){
        
        
        let tag = "GetCloseCabbie";
        //let ci = LoginPageViewController().fetch() as! String
        
        
        do {
            let post:NSString = "Tag=\(tag)&Latitude=\(latitude_Salida)&Longitude=\(longitude_Salida)"
            
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
                        Set_Request()
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
    
    //Table functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return menuItems.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        mycell = tableView.dequeueReusableCellWithIdentifier("MyCellPay", forIndexPath: indexPath) as! MyTableViewCell
        
        var bleachimage = UIImage(named: menuIcons[indexPath.row])
        mycell.imageView?.image  = bleachimage
        mycell.payItemLabel.text = menuItems[indexPath.row]
        
        return mycell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    //end

    
    
    
    
}

