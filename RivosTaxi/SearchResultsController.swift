//
//  SearchResultsController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 08/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit

protocol LocateOnTheMap{
    func locateWithLongitude(lon:Double, andLatitude lat:Double, andTitle title: String)
}

class SearchResultsController: UITableViewController {
   
    
    var lat:Double = 0.0
    var lon:Double = 0.0
    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchResults = Array()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")

        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath){
            // 1
            self.dismissViewControllerAnimated(true, completion: nil)
            //self.performSegueWithIdentifier("HistoryDetail", sender: indexPath)
            // 2
            let correctedAddress:String! = self.searchResults[indexPath.row].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.symbolCharacterSet())
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?radius=500&address=\(correctedAddress)&sensor=false")
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
                // 3
                do {
                    if data != nil{
                        let dic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
                        // print(dic)
                        self.lat = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat")?.objectAtIndex(0) as! Double
                        self.lon = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng")?.objectAtIndex(0) as! Double
                        let add = dic["results"]!.valueForKey("formatted_address")!
                        print(self.lat)
                        print(self.lon)
                        // 4
                        //let row = indexPath.row
                        
                        //self.title="test test"
                      self.delegate.locateWithLongitude(self.lon, andLatitude: self.lat, andTitle: self.searchResults[indexPath.row])
                       // self.navigationController?.popViewControllerAnimated(true)
                      
                    }
                    
                }catch {
                    print("Error")
                }
            }
            // 5
            task.resume()
            // self.performSegueWithIdentifier("ProtectedPageViewController", sender: indexPath)
            
            
    }
    
    
    func reloadDataWithArray(array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    

}
