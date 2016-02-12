//
//  FavoritesViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 22/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import CoreData
class FavoritesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    let moc = DataController().managedObjectContext
    var C_Id = ""
    var segue: String = "addCabbieTableViewController"
    //Table Taxistas
    var Names = [String]()
    var Company = [String]()
    var Dates = [String]()
    var CabbieID = [String]()
    //Table Places
    var PlacesNames = [String]()
    var Place_Id = [String]()
    
    @IBAction func addFavorite(sender: AnyObject) {
        
            performSegueWithIdentifier(segue, sender: nil)
        
            }
    
    @IBOutlet weak var mySegmented: UISegmentedControl!
    @IBOutlet weak var myTableFav: UITableView!
    
   // let add:[String] = ["Agregar"]
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     SwiftLoading().showLoading()
        places()
    SwiftLoading().hideLoading()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func segmentedButton(sender: AnyObject) {
        switch(mySegmented.selectedSegmentIndex)
        {
        case 0:
            
           segue = "addCabbieTableViewController"
           
            myTableFav.reloadData()
            break
        case 1:
            
           segue = "addFavoritePlaces"
           
             myTableFav.reloadData()
            break
            
        default:
            break
            
        }
        
        
    }
    
   
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        
        switch(mySegmented.selectedSegmentIndex)
        {
        case 0:
            
            returnValue = Names.count
            break
        case 1:
            returnValue = PlacesNames.count
            break
            
            
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    //http://swiftdeveloperblog.com/uisegmentedcontrol-with-uitableview-example-in-swift-part-2/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var myCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MyCellFav")!
        
        myCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "MyCellFav")
        // var myCell = tableView.dequeueReusableCellWithIdentifier("MyCellFav", forIndexPath: indexPath)
        // myCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "MyCellFav")
        
        switch(mySegmented.selectedSegmentIndex)
        {
        case 0:
            print(Names)
            print(Company)
            myCell.textLabel!.text = Names[indexPath.row]
            myCell.detailTextLabel!.text = Company[indexPath.row]
           // myCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            break
        case 1:
            print(PlacesNames)
            print(Place_Id)
            myCell.textLabel!.text = PlacesNames[indexPath.row]
            myCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            // myCell.detailTextLabel!.text =
            
            break
            
        default:
            break
            
        }
        
        
        return myCell
    }
    //-----
 
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
   
    }
    
    
   internal func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        var Editar = UITableViewRowAction()
        var Eliminar = UITableViewRowAction()
        
        switch(mySegmented.selectedSegmentIndex)
        
        {
            case 0:
         
           
                Eliminar = UITableViewRowAction(style: .Normal, title: "Eliminar" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                
                
                self.Names.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                
                print("Se elimino")
                })
            Eliminar.backgroundColor = UIColor.redColor()
            
      
        
        
        break
        case 1:
            Editar = UITableViewRowAction(style: .Normal, title: "Editar" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                
            })
            Editar.backgroundColor = UIColor.blueColor()
            Eliminar = UITableViewRowAction(style: .Normal, title: "Eliminar" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                
                let row = indexPath.row
                let placeId = self.Place_Id[row]
                let tag = "Delete_Favorite_Place";
                self.fetch()
                do {
                    let post:NSString = "Tag=\(tag)&Client_Id=\(self.C_Id)&Place_Id=\(placeId)"
                    
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
                                self.PlacesNames.removeAtIndex(indexPath.row)
                                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                                
                                print("Se elimino")
                                
                                
                                
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
                
            })
            Eliminar.backgroundColor = UIColor.redColor()
        break
        default:
        break
        }
        return [Editar, Eliminar]
    }
    //===
    
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //----
        @IBAction func refresh(sender: AnyObject) {
        myTableFav.reloadData()
        
    }
    
    
    /*func cabbies(){
        // Do any additional setup after loading the view.
        let tag = "Get_Favorite_Cabbie";
        //params: Client_Id
        let cd = "63";
        
        do {
            let post:NSString = "Tag=\(tag)&Client_Id=\(cd)"
            
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
                    
                    
                    
                    
                    var i = 0
                    var n = "Request"
                    if var end = jsonData["num"] as? Int
                    {
                        print(end)
                        for item in jsonData {
                            i++
                            if i > end {
                                break;
                            }
                            n = "Cabbie_Id"+String(i)
                            var result = jsonData[n] as? NSDictionary
                            
                            
                            if let Name = result!["Name"] as? String
                            {
                                Names.append(Name)
                                print(Name)
                                
                            }
                            if let companies = result!["Company"] as? String
                            {
                                Company.append(companies)
                                print(companies)
                            }
                            
                            if let request_id = result!["Cabbie_Id"] as? String
                            {
                                print(request_id)
                                CabbieID.append(request_id)
                            }
                            
                            
                        }
                        
                    }else{
                        print("No results")
                        
                    }
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        print("Found favs")
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
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
        
        
    }*/
    
    //===========
    func places()
    {
        
        let tag = "Get_Favorite_Place";
        //params: Client_Id
        fetch()
    
            do {
                let post:NSString = "Tag=\(tag)&Client_Id=\(C_Id)"
    
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
                        } catch let error as NSError
                            {
                                reponseError = error
                                urlData = nil
                            }
    
                if ( urlData != nil )
                {
                    let res = response as! NSHTTPURLResponse!;
    
                    NSLog("Response code: %ld", res.statusCode);
    
                        if (res.statusCode >= 200 && res.statusCode < 300)
                        {
                            let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
    
                            NSLog("Response ==> %@", responseData);
    

    
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
    
                            let success:NSInteger = jsonData.valueForKey("Success") as! NSInteger
    
    
    
    
                            var i = 0
                            var n = "Place"
                            if var end = jsonData["num"] as? Int
                            {
                                print(end)
                                for item in jsonData
                                {
                                    i++
                                    if i > end
                                    {
                                        break;
                                    }
                                    n = "Place"+String(i)
                                    var result = jsonData[n] as? NSDictionary
    
    
                                    if let placeName = result!["Place_Name"] as? String
                                    {
                                        PlacesNames.append(placeName)
                                        print(placeName)
    
                                    }
                                 
    
                                    if let request_id = result!["Place_Favorite_Id"] as? String
                                    {
                                        print(request_id)
                                        Place_Id.append(request_id)
                                    }
    
                                    //print(PlacesNames)
                                }
    
                            }else
                            {
                                print("No results")
    
                            }
    
                            //[jsonData[@"success"] integerValue];
    
                            NSLog("Success: %ld", success);
    
                            if(success == 1)
                            {
                                print("Found favs")
    
                            } else {
                                var error_msg:NSString
    
                                if jsonData["error_message"] as? NSString != nil {
                                    error_msg = jsonData["error_message"] as! NSString
                                } else {
                                    error_msg = "No has añadido favoritos"
                                }
                                let alertView:UIAlertView = UIAlertView()
                                alertView.title = "Aviso"
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
