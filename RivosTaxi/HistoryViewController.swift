//
//  HistoryViewController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 29/12/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit

import SwiftyJSON
class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var resultsLabel: UILabel!
    
    var Names = [String]()
    // Names = ["mario"]
    var Dates = [String]()
    var RequestID = [String]()
    var segueID = ""
    
    @IBOutlet weak var HistoryTable: UITableView!
 

    var searchResults = [String]() //Array of dictionary
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        SwiftLoading().showLoading()
        data()
        SwiftLoading().hideLoading()
       
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    func data(){
        
        let tag = "Get_Client_History";
        //params: Client_Id
        let cd = "88";
        
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
                    
                    //let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: .MutableContainers) as? NSDictionary
                    
                    
                    
                    
                    
                    
                    var i = 0
                    var n = "Request"
                    if var end = jsonData!["num"] as? Int
                    {
                        print(end)
                        for item in jsonData! {
                            i++
                            if i > end {
                                break;
                            }
                            n = "Request"+String(i)
                            var result = jsonData![n] as? NSDictionary
                            /*
                            
                            //Ini
                            if let lat_i = result!["Latitude_In"] as? String
                            {
                            print(lat_i)
                            }
                            if let lon_i = result!["Longitude_In"] as? String
                            {
                            print(lon_i)
                            }
                            
                            
                            //Destino
                            if let lat_f = result!["Latitude_Fn"] as? String
                            {
                            print(lat_f)
                            }
                            
                            
                            if let lon_f = result!["Longitude_Fn"] as? String
                            {
                            print(lon_f)
                            }*/
                            
                            if let Name = result!["Name"] as? String
                            {
                                Names.append(Name)
                                print(Name)
                                
                            }
                            if let Date = result!["Date"] as? String
                            {
                                
                                Dates.append(Date)
                                print(Date)
                            }
                            if let request_id = result!["Request_Id"] as? String
                            {
                                print(request_id)
                                RequestID.append(request_id)
                            }
                            
                            
                        }

                    }else{
                        print("No results")
                   
                                      }
                    
                    
                    
                    
                    
                    
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
                            error_msg = "No se ha encontrado registros"
                            resultsLabel.text = "No se encontraron registros..."
                            
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
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return Names.count
    }
    
    
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
      //  var myCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        var cell: UITableViewCell = HistoryTable.dequeueReusableCellWithIdentifier("myCell")!
       
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "myCell")
        
        //var dict = searchResults[indexPath.row]
        cell.textLabel?.text = self.Names[indexPath.row]
        cell.detailTextLabel?.text = self.Dates[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //cell. = RequestID[indexPath.row]
        
       // myCell.detailTextLabel?.text = dict["Date"]
        return cell    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        segueID = RequestID[row]
        print(RequestID[row])
        self.performSegueWithIdentifier("HistoryDetail", sender: indexPath)
       

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "HistoryDetail" {
            let secondVC: HistoryDetailsViewController = segue.destinationViewController as! HistoryDetailsViewController
            
            secondVC.Request_ID = segueID
        }
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let delete = UITableViewRowAction(style: .Normal, title: "Borrar" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
           
        })
        
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }

}
