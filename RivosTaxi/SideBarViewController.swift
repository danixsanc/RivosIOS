//
//  SideBarViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 12/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import CoreData

class SideBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let moc = DataController().managedObjectContext
    var Client_Id = ""
    var C_Id = ""
    
    
    
    @IBOutlet weak var userName: UILabel!
    
    
    
    @IBOutlet weak var image: UIImageView!
    
    var mycell:MyTableViewCell!
    
    //Sidebar Menu
    var menuItems:[String] = ["Solicitar","Solicitudes", "Pagos","Favoritos", "Historial", "Perfil", "Ayuda"];
    var menuIcons = ["ic_local_taxi","ic_flag", "ic_credit_card", "ic_star", "ic_watch_later", "ic_person", "ic_live_help"];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true

        
        fetchProfile()
        fetchPhoto()
                  
        // Do any additional setup after loading the view.
    }
    
    func fetchPhoto(){
        
        let fetchRequest = NSFetchRequest(entityName: "Perfil")
        
        
        
        // Execute Fetch Request
        do {
            let result = try moc.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                if let img = managedObject.valueForKey("userImage") {
                    
                    image.image! = (img as? UIImage)!
                    
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    
    func fetchProfile(){
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Perfil")
        

        
        // Execute Fetch Request
        do {
            let result = try moc.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                if let name = managedObject.valueForKey("name") {
                    print(name)
                    userName.text = name as? String
                    //image?.image = userImage as? UIImage
                    print("Correct")
                    
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func deletePerfil() {
    
        let request = NSFetchRequest(entityName: "Perfil")
        request.returnsObjectsAsFaults = false
    
            do {
                let perfilEntities = try moc.executeFetchRequest(request)
    
                if perfilEntities.count > 0 {
    
                    for result: AnyObject in perfilEntities{
                        moc.deleteObject(result as! NSManagedObject)
                        print("Profile has been Deleted")
                    }
                    try moc.save()
                }
            }
            catch let error as NSError {
                debugPrint(error)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuItems.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        mycell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! MyTableViewCell


        var bleachimage = UIImage(named: menuIcons[indexPath.row])
        
        
        mycell.imageView?.image  = bleachimage
        mycell.menuItemLabel.text = menuItems[indexPath.row]
        mycell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return mycell;
    }
 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        switch(indexPath.row)
        {
            
        case 0:
            
            
            var protectedViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! ProtectedPageViewController
            
            let protectedNavController = UINavigationController(rootViewController: protectedViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = protectedNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break;
            
        case 1:
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
           self.performSegueWithIdentifier("requestView", sender: nil)
            
            break;

        case 2:
            
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("PagosView", sender: nil)
            
            break;
            
        case 3:
            
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("favoritesView", sender: nil)
            
            break;
       
        case 4:
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("historyView", sender: nil)
            
            break;
            
        case 5:
            
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("profileView", sender: nil)
            
            break;
            
 
        case 6:
            
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("contactView", sender: nil)
            
            break;
    
       
            
        default:
            
            print("\(menuItems[indexPath.row]) is selected");
            
        }
    }
    

    
    
    }
