//
//  PagosViewController.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 10/02/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit

class PagosViewController: UIViewController {

    
    var cards = ["02930948298349822"]
    @IBOutlet weak var card_table: UITableView!
    @IBAction func Add_Credit_Card(sender: AnyObject)
    {
        
    }
    @IBAction func DismissWindow(sender: AnyObject)
    {
       
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //  var myCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        var cell: UITableViewCell = card_table.dequeueReusableCellWithIdentifier("cardsCell")!
        
        cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cardsCell")
        
        cell.textLabel?.text = cards[indexPath.row]
        /*//var dict = searchResults[indexPath.row]
        cell.textLabel?.text = self.Names[indexPath.row]
        cell.detailTextLabel?.text = self.Dates[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //cell. = RequestID[indexPath.row]
        
        // myCell.detailTextLabel?.text = dict["Date"]*/
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
       /* let row = indexPath.row
        segueID = RequestID[row]
        print(RequestID[row])
        self.performSegueWithIdentifier("HistoryDetail", sender: indexPath)*/
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      /*  if segue.identifier == "HistoryDetail" {
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
    

    
    

}
