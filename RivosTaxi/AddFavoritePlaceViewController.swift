//
//  AddFavoritePlaceViewController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 15/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//
import UIKit
import GoogleMaps
import CoreData
import TextFieldEffects
class AddFavoritePlaceViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap, UITextFieldDelegate {
    
    let moc = DataController().managedObjectContext
    var C_Id = ""
    var latitude = 0.0
    var longitude = 0.0
    @IBAction func SetFavoritePlaceDone(sender: AnyObject)
    {
        let Place_Name = self.PlaceNameTextField!.text!
        let Place_Desc = self.LocationResultsLabel!.text!
        
        if ( Place_Name == "Search" || latitude == 0 || longitude == 0 ) {
            
            let alert = UIAlertView(title: "Informacion incompleta", message: "Es necesario que asigne un nombre y seleccione una ubicacion para poder agregar su lugar favorito.", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            
        }else
        {
            Set_Favorite_Place()
            print("El lugar es: \(Place_Name)")
            print("El lugar es: \(Place_Desc)")
            print("Latitude y long\(latitude)\(longitude)")
            self.LocationResultsLabel!.text = "Search"
            
        }
    }
    
    
    @IBOutlet weak var PlaceNameTextField: TextFieldEffects!
    
    @IBOutlet weak var LocationResultsLabel: UILabel!
    var result = [String]()
    var searchResultController:SearchResultsController!
    var resultsArray = [String]()
    var googleMapsView:GMSMapView!
    
    @IBAction func ShowSearchBar(sender: AnyObject)
    {
        self.LocationResultsLabel.text = "Search"
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var placesMapview: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    //dismiss keyboard with touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }
    
    
    //dismiss keyboard with return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //http://swiftdeveloperblog.com/dismiss-keyboard-example-in-swift/
        textField.resignFirstResponder()
        return true;
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.googleMapsView =  GMSMapView(frame: self.placesMapview.frame)
        self.view.addSubview(self.googleMapsView)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        let geoCoder = CLGeocoder()
        //let locationManager = CLLocationManager()
        
        //error
        let Coordinates_ini = CLLocation(latitude:lat , longitude: lon )
        
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
                if let locationLocality = placeMark.addressDictionary?["SubLocality"] as? NSString
                {
                    // print(locationName)
                    self.result.append(locationLocality as String)
                    
                    
                }
                
                // Location name
                if let locationName = placeMark.addressDictionary?["Name"] as? NSString
                {
                    self.result.append(locationName as String)
                    
                    
                }
                
                let Desc_place = self.result.joinWithSeparator(", ")
                
                
                self.LocationResultsLabel!.text = Desc_place
                
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 15)
            self.googleMapsView.camera = camera
            
            marker.title = title
            marker.map = self.googleMapsView
            self.latitude = lat
            self.longitude = lon
        }
    }
    
    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String){
            
            let placesClient = GMSPlacesClient()
            placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
                self.resultsArray.removeAll()
                if results == nil {
                    return
                }
                for result in results!{
                    if let result = result as? GMSAutocompletePrediction{
                        self.resultsArray.append(result.attributedFullText.string)
                    }
                }
                self.searchResultController.reloadDataWithArray(self.resultsArray)
            }
    }
    func Set_Favorite_Place(){
        
        let tag = "Set_Favorite_Place";
        fetch()
        let lat = "\(latitude)"
        let lon = "\(longitude)"
        let placeName = self.PlaceNameTextField!.text!
        let placeDesc = self.LocationResultsLabel!.text!
        do {
            let post:NSString = "Tag=\(tag)&Latitude=\(lat)&Longitude=\(lon)&Place_Name=\(placeName)&Place_Desc=\(placeDesc)&Client_Id=\(C_Id)"
            
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
                    
                    
                    
                    
                    
                    
                    //******************************************************************
                    
                    let success:NSInteger = jsonData!.valueForKey("Success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Bien"
                        alertView.message = "Se a logrado agregar su lugar indicado a favoritos correctamente."
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData!["error_message"] as? NSString != nil {
                            error_msg = jsonData!["error_message"] as! NSString
                        } else {
                            error_msg = "No se ha podido agregar a favoritos, por favor intentelo mas tarde"
                            
                            
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
