//
//  PendingRequestsViewController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 21/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit
import CoreData
class PendingRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var PendingTable: UITableView!
    let moc = DataController().managedObjectContext
    var C_Id = ""
    var Dates = [String]()
    var RequestID = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SwiftLoading().showLoading()
        Pending_Request()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return Dates.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //  var myCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        var cell: UITableViewCell = PendingTable.dequeueReusableCellWithIdentifier("PendingCell")!
        
        cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "PendingCell")
        
        cell.textLabel?.text = Dates[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //cell. = RequestID[indexPath.row]
        
        // myCell.detailTextLabel?.text = dict["Date"]
        return cell    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        /*
        let row = indexPath.row
        segueID = RequestID[row]
        print(RequestID[row])
        self.performSegueWithIdentifier("HistoryDetail", sender: indexPath)*/
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        /*if segue.identifier == "HistoryDetail" {
        let secondVC: HistoryDetailsViewController = segue.destinationViewController as! HistoryDetailsViewController
        
        secondVC.Request_ID = segueID
        }*/
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
    
    func Pending_Request()
    {
        let tag = "Get_Client_History_Pending";
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
                    
                    
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: .MutableContainers) as? NSDictionary
                    
                    print(jsonData)
                    //******************************************************************
                    
                    let success:NSInteger = jsonData!.valueForKey("Success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
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
                        }
                        
                        
                        SwiftLoading().hideLoading()
                        
                    } else {
                        var error_msg:NSString
                        SwiftLoading().hideLoading()
                        if jsonData!["error_message"] as? NSString != nil {
                            error_msg = jsonData!["error_message"] as! NSString
                            
                        } else {
                            SwiftLoading().hideLoading()
                            error_msg = "No se encontro historial de conductores que lo hayan atendido atneriormente"
                            
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Aviso"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    SwiftLoading().hideLoading()
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Connection Failed"
                    alertView.message = "Verifique su conexion a internet"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                SwiftLoading().hideLoading()
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
            SwiftLoading().hideLoading()
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
