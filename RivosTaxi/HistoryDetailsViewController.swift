//
//  HistoryDetailsViewController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 05/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit

class HistoryDetailsViewController: UIViewController {

    
    @IBOutlet weak var saliida: UILabel!
    
    @IBOutlet weak var ciudad: UILabel!
    @IBOutlet weak var destino: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var request_date: UILabel!
    var Request_ID = ""
    var tag = "Get_Client_History_Details"
    var lat_i = ""
    var lon_i = ""
    var lat_f = ""
    var lon_f = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftLoading().showLoading()
    data()
        SwiftLoading().hideLoading()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func data(){
        
       // let tag = "Get_Client_History";
        //params: Client_Id
       // let cd = "63";
        
        do {
            let post:NSString = "Tag=\(tag)&Request_Id=\(Request_ID)"
            
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
                    
                    //let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: .MutableContainers) as? NSDictionary
                    
                    print(jsonData)
                    
                    let result = jsonData!["Request1"]
                    let cabbie_id = result!["Cabbie_Id"]
                    let date = result!["Date"] as! String
                    lat_i = result!["Latitude_In"] as! String
                    lon_i = result!["Longitude_In"] as! String
                    lat_f = result!["Latitude_Fn"] as! String
                    lon_f = result!["Longitude_Fn"] as! String
                    let driver_name = result!["Name"] as! String
                    
                    request_date.text = date
                    driverName.text = driver_name
                    setUsersClosestCity()
                    UserCityFinal()
                    
                    
                    
                    
                    //******************************************************************
                    
                    let success:NSInteger = jsonData!.valueForKey("Success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        /* let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Si"
                        alertView.message = "Cierto"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()*/
                        
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData!["error_message"] as? NSString != nil {
                            error_msg = jsonData!["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
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
    
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        //let locationManager = CLLocationManager()
        
        var lat_ini = (lat_i as NSString).doubleValue
        var lon_ini = (lon_i as NSString).doubleValue
        
        
        
        //error
        let Coordinates_ini = CLLocation(latitude:lat_ini as! CLLocationDegrees , longitude: lon_ini as! CLLocationDegrees)
       
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
                    self.saliida.text = locationName as String
                }
                
                // Street address
                if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString
                {
                    print(street)
                    
                }
                
                // City
                if let city = placeMark.addressDictionary?["City"] as? NSString
                {
                    print(city)
                    self.ciudad.text = city as String
                }
                
                // Country
                if let country = placeMark.addressDictionary?["Country"] as? NSString
                {
                    print(country)
                }
        }
 
    }
    func UserCityFinal()
    {
        SwiftLoading().showLoading()
        let geoCoder = CLGeocoder()
        //let locationManager = CLLocationManager()
        var lat_fin = (lat_f as NSString).doubleValue
        var lon_fin = (lon_f as NSString).doubleValue
        
        
        //error
     
        let Coordinates_fin = CLLocation(latitude:lat_fin as! CLLocationDegrees , longitude: lon_fin as! CLLocationDegrees)
        geoCoder.reverseGeocodeLocation(Coordinates_fin)
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
                
                // Street address
                if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString
                {
                    print(street)
                }
                
                // City
                if let city = placeMark.addressDictionary?["City"] as? NSString
                {
                    print(city)
                }
                
                // Country
                if let country = placeMark.addressDictionary?["Country"] as? NSString
                {
                    print(country)
                }
        }
       SwiftLoading().hideLoading() 
    }
    
    
}
