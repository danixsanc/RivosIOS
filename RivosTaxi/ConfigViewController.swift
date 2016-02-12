//
//  ConfigViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 12/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit

class ConfigViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate {
        var mycell:MyTableViewCell!
    var menuItems:[String] = [];
    var menuIcons = ["ic_person", "ic_mail", "ic_phone_iphone"];
   
    @IBOutlet weak var profileImg: UIImageView!
   // @IBOutlet weak var userName: UILabel!
    var userName = ""
    var userEmail = ""
    var userPhone = ""
    
    let moc = DataController().managedObjectContext
     var Client_Id = ""
    var C_Id = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchProfile()
        fetchPhoto()

        // Do any additional setup after loading the view.
        //SwiftLoading().showLoading()
        //SwiftLoading().hideLoading()
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        //items
        menuItems.insert(userName, atIndex: 0)
        menuItems.insert(userEmail, atIndex: 1)
        menuItems.insert(userPhone, atIndex: 2)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
  
    

    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
    @IBAction func SendCode(sender: AnyObject) {
        //Add sendCode
        
    }
    
 
    @IBAction func LogoutButtonTapped(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        deletePerfil()
        deleteUserID()
        deleteFavorites()
        

         NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
       
       self.dismissViewControllerAnimated(true, completion: nil)
        //self.performSegueWithIdentifier("mainView", sender: self);
        
        print("Sesion cerrada")

        
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
    
    func deletePerfil()
        {
            // let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            //let context: NSManagedObjectContext = appDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "Perfil")
            request.returnsObjectsAsFaults = false
    
            do
            {
                let perfilEntities = try moc.executeFetchRequest(request)
    
                if perfilEntities.count > 0
                {
    
                    for result: AnyObject in perfilEntities
                    {
                        moc.deleteObject(result as! NSManagedObject)
                        print("Profile has been Deleted")
                    }
                    try moc.save()
                }
            }
            catch let error as NSError
            {
                debugPrint(error)
            }
        }
    func deleteUserID() {
        // let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let context: NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let UserEntities = try moc.executeFetchRequest(request)
            
            if UserEntities.count > 0 {
                
                for result: AnyObject in UserEntities{
                    moc.deleteObject(result as! NSManagedObject)
                    print("User ID has been Deleted")
                }
                try moc.save()
            }
        }
        catch let error as NSError {
            debugPrint(error)
        }
    }
    func deleteFavorites() {
        // let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let context: NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Favoritos")
        request.returnsObjectsAsFaults = false
        
        do {
            let favoritesEntities = try moc.executeFetchRequest(request)
            
            if favoritesEntities.count > 0 {
                
                for result: AnyObject in favoritesEntities{
                    moc.deleteObject(result as! NSManagedObject)
                    print("Favoritos has been Deleted")
                }
                try moc.save()
            }
        }
        catch let error as NSError {
            debugPrint(error)
        }
    }
    func fetchPhoto(){
        
        let fetchRequest = NSFetchRequest(entityName: "Perfil")
        
        
        
        // Execute Fetch Request
        do {
            let result = try moc.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                if let img = managedObject.valueForKey("userImage") {
                    
                    profileImg.image! = (img as? UIImage)!
                    
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    func fetchProfile(){
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Perfil")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute Fetch Request
        do {
            let result = try moc.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                if let name = managedObject.valueForKey("name"), email = managedObject.valueForKey("email"), phone = managedObject.valueForKey("phone")
                {
                
                    print("\(name) \(email) \(phone)")
                  
                    userName = (name as! String)
                    userEmail = (email as! String)
                    userPhone = (phone as! String)
                    //userName!.text = name as? String
                   // profileImg.image = userImage as? UIImage
                  
                }
                
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    //Table functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return menuItems.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        mycell = tableView.dequeueReusableCellWithIdentifier("MyCellProfile", forIndexPath: indexPath) as! MyTableViewCell
        
        var bleachimage = UIImage(named: menuIcons[indexPath.row])
        mycell.imageView?.image  = bleachimage
        mycell.profileItemLabel.text = menuItems[indexPath.row]
        
        return mycell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    //end
    

    
 

}
