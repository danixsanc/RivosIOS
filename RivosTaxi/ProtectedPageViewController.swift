//
//  ProtectedPageViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 02/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import GoogleMaps
import UIKit
import GoogleMaps
import CoreLocation
import FBSDKLoginKit
import FBSDKCoreKit
import CoreData


class ProtectedPageViewController: UIViewController,UISearchBarDelegate, LocateOnTheMap {
    let moc = DataController().managedObjectContext
    
    var Maps_Latitude = 0.0
    var Maps_Longitude = 0.0
    var latitude_ini = 0.0
    var longitude_ini = 0.0
    var latitude_fin = 0.0
    var longitude_fin = 0.0
    
    var marker_lat = 0.0
    var marker_lon = 0.0
    var marker_destino = true
    var Tag = ""
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var SolicitarButtonOutlet: UIButton!
    @IBOutlet weak var Pickip_place: UILabel!
    var C_Id = ""
    @IBAction func refresh_button(sender: AnyObject) {
        Pickip_place.text = "Seleccione lugar de salida"
        Pickip_place.textColor = UIColorFromRGB(0x027AFE)
        refreshButton.enabled = false
        mapView.clear()
        mapCenterPinImage.hidden = false
        marker_destino = true
      
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if(segue.sourceViewController .isKindOfClass(PaymentViewController))
        {
            Pickip_place.text = "Seleccione lugar de salida"
            refreshButton.enabled = false
            let alert = UIAlertView()
            alert.title = "Su transaccion a sido exitosa"
            alert.message = "Su transporte llegara en unos momentos, puede revisar los detalles de sus solicitudes en curso en la pestaña de Pendientes."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    @IBAction func SolicitarButton(sender: AnyObject) {
        
        if (Pickip_place.text == "Seleccione lugar de salida" && Pickip_place.text != "")
        {
            latitude_ini = Maps_Latitude
            longitude_ini = Maps_Longitude
            print("Ahora seleccione llegada")
            
            IsAirportLocation()
            let position = CLLocationCoordinate2DMake(Maps_Latitude, Maps_Longitude)
            let marker = GMSMarker(position: position)
            marker.icon = GMSMarker.markerImageWithColor(UIColorFromRGB(0x027AFE))
            marker.title = "Lugar de Salida"
            marker.flat = true
            marker.map = mapView
            refreshButton.enabled = true
            
            print(latitude_ini)
            print(longitude_ini)
            
            
            
        }else if (Pickip_place.text == "Seleccione Destino" && Pickip_place.text != "")
        {
            //SwiftLoading().showLoading()
            latitude_fin = Maps_Latitude
            longitude_fin = Maps_Longitude
            let position = CLLocationCoordinate2DMake(Maps_Latitude, Maps_Longitude)
            if (marker_destino == false)
            {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Aviso!"
                alertView.message = "Ya existe un destino seleccionado, si desea cambiar lo toque el botón de rerescar"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }else
            {
                
                let marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                marker.title = "Lugar de Destino"
                marker.map = mapView
                mapCenterPinImage.hidden = true
                marker_destino = false
                self.mapView.camera = GMSCameraPosition.cameraWithTarget(position, zoom:14)
                
            }
            
            
           // self.performSegueWithIdentifier("PaymentView", sender: self)
        }else {
            
        }
        
    }
    
    @IBOutlet weak var Placesview: UIView!
    var searchResultController:SearchResultsController!
    var resultsArray = [String]()
    var googleMapsView:GMSMapView!
    
    
    @IBAction func showSearchController(sender: AnyObject)
    {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    @IBOutlet weak var addressField: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?
    var emailDC = LoginPageViewController()
    let dataProvider = GoogleDataProvider()
    
    let searchRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.enabled = false
        fetchProfile()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        
    }
    
    func fetchProfile(){
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Perfil")
        
        
        
        // Execute Fetch Request
        do {
            let result = try moc.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                if let name = managedObject.valueForKey("name"), email = managedObject.valueForKey("email"), phone = managedObject.valueForKey("phone"), img = managedObject.valueForKey("userImage") {
                    print("Listo_")
  
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            self.addressField.unlock()
            if let address = response?.firstResult() {
                let FullGoogleJson = address
                
                let lines = address.lines as! [String]
                let coordinate = address.coordinate
                
                self.Maps_Latitude = coordinate.latitude
                self.Maps_Longitude = coordinate.longitude
                
                print("Linea de direccion: \(lines)")
                print("Coordenadas: \(coordinate)")
                print("Json De Google Por completo: \(FullGoogleJson)")
                self.addressField.text = lines.joinWithSeparator("\n")
                print(self.Maps_Latitude)
                print(self.Maps_Longitude)
                
                let labelHeight = self.addressField.intrinsicContentSize().height
    
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
                
                UIView.animateWithDuration(0.25) {
                    self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LeftSideButtonTapped(sender: AnyObject) {

        SideBarViewController().fetchProfile()
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if(!isUserLoggedIn){
            
            self.performSegueWithIdentifier("MainView", sender: self);
            print("Has iniciado sesion")
        }
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
    }
    
    
    
    
    /*@IBAction func LogoutButtonTapped(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        self.performSegueWithIdentifier("MainView", sender: self);
        
        print("Sesion cerrada")
        
    }*/
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            let target = CLLocationCoordinate2DMake(lat, lon)
            self.mapView.camera = GMSCameraPosition.cameraWithTarget(target, zoom:15)
            
            print("Este es un mensaje de prueba, bien echoo!!!")
            
            //marker.title = title
            //marker.map = self.googleMapsView
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "PaymentView" {
            let PayView: PaymentViewController = segue.destinationViewController as! PaymentViewController
            PayView.latitude_Destino = latitude_fin
            PayView.longitude_Destino = longitude_fin
            PayView.latitude_Salida = latitude_ini
            PayView.longitude_Salida = longitude_ini
            
        }
    }
    
    //Ubicacion
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
       
    func IsAirportLocation(){
        
        
        let tag = "GetIfIsAirport";
        var lat = "\(latitude_ini)"
        var lon = "\(longitude_ini)"
        
        
        
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
                        Tag = "GetPriceAirportToColony"
                        Pickip_place.text = "Seleccione Destino"
                        Pickip_place.textColor = UIColor.redColor()
                        print(jsonData)
                        
                    } else if(success == 2)
                    {
                        
                        
                        Tag = "VerifyDestination"
                        Pickip_place.text = "Seleccione Destino"
                        Pickip_place.textColor = UIColor.redColor()
                        
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
    
  
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
}

extension ProtectedPageViewController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            
            
            
           // mapView.padding = UIEdgeInsets(top: 200, left: 0, bottom: 100, right: 0)
            
            
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
         
            locationManager.stopUpdatingLocation()
            //fetchNearbyPlaces(location.coordinate)
        }
    }
    
}
// MARK: - GMSMapViewDelegate
extension ProtectedPageViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(mapView: GMSMapView!, willMove gesture: Bool)
    {
        addressField.lock()
        
        if (gesture) {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
    
    
    
}