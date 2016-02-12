//
//  AddCabbieViewController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 15/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit

class AddCabbieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cabbieResultsLabel: UILabel!
    @IBOutlet weak var cabbieTable: UITableView!
    //var cabbie = [String]()
    var Names = [String]()
    var CabbieID = [String]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        todo()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func todo(){
        
        let tag = "Get_Cabbie_History";
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
                    
                    //let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: .MutableContainers) as? NSDictionary
                    
                    
                    
                    print(jsonData)
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
                            n = "Cabbie_Id"+String(i)
                            var result = jsonData![n] as? NSDictionary
                            
                            
                            if let Name = result!["Name"] as? String
                            {
                                Names.append(Name)
                                print(Name)
                                
                            }
                        
                            
                            if let request_id = result!["Cabbie_Id"] as? String
                            {
                                print(request_id)
                                CabbieID.append(request_id)
                            }
                            
                            
                        }
                        print(Names)
                        cabbieTable.reloadData()
                        
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
                            error_msg = "No se encontro historial de conductores que lo hayan atendido atneriormente"
                           cabbieResultsLabel!.text = "No se encontraron resultados..."
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
    
    
    // MARK: - Table view data source
    

    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Names.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = cabbieTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        
        cell.textLabel!.text = self.Names[indexPath.row]
      // cell.textLabel!.text = "Hello"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        // Configure the cell...
        
        return cell
    }
    


}
