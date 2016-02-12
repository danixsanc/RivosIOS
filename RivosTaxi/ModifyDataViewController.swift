//
//  ModifyDataViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 04/11/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import CoreData
import TextFieldEffects

class ModifyDataViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var user_name = ""
    var user_email = ""
    var user_phone = ""
    let moc = DataController().managedObjectContext
    var C_Id = ""
    let picker = UIImagePickerController()
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameText: TextFieldEffects!
    @IBOutlet weak var userEmailText: TextFieldEffects!
    @IBOutlet weak var userPhoneText: TextFieldEffects!
    var userPassword = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
        fetchProfile()
        fetchPhoto()
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        picker.delegate = self   //the required

        
        
        
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
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImg.contentMode = .ScaleAspectFit
            profileImg.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    /*
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImg.contentMode = .ScaleAspectFit //3
        profileImg.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }*/
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true,
            completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                if let name = managedObject.valueForKey("name"), email = managedObject.valueForKey("email"), phone = managedObject.valueForKey("phone") {
                    print("\(name) \(email) \(phone)")
                    userNameText?.text = name as? String
                    userEmailText?.text = email as? String
                    userPhoneText?.text = phone as? String

                    
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
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
    

    
    
    @IBAction func editPhoto(sender: UIBarButtonItem) {
        
        picker.editing = true
        
        
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        
        //self.presentViewController(picker, animated: false, completion: nil)
        
        
        
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
            animated: true,
            completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = sender
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    

    
    
    @IBAction func CorrectData(sender: UIBarButtonItem) {
        
        verifyPassword()
        
    }
    
    func verifyPassword(){
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Enter Text",
            message: "Enter some text below",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                
                textField.placeholder = "Ingrese su contraseña.."
                textField.secureTextEntry = true
                
        })
        
        
        let action = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    self!.userPassword = enteredText!
                    print(self!.userPassword)
                    self!.VerifyPasswordDataBase()
                    // self!.passtext.text = enteredText
                }
            })
        
        alertController?.addAction(action)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
        
    }
    
    
    func updateProfile(){
        let tag1 = "UpdateUser"
        
        let Name2 = userNameText.text!
        let Email2 = userEmailText.text!
        let Phone2 = userPhoneText.text!

        fetch()
        
        
        
        
        do {
            let post:NSString = "Tag=\(tag1)&Client_Id=\(C_Id)&Email=\(Email2)&Name=\(Name2)&Phone=\(Phone2)&Password=\(userPassword)"
            
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
                    
                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let success:NSInteger = jsonData.valueForKey("Success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Exito"
                        alertView.message = "Datos modificados correctamente."
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                        let perfil = jsonData["User"]
                        user_name = perfil!["Name"] as! String
                        user_email = perfil!["Email"] as! String
                        user_phone = perfil!["Phone"] as! String
                        deletePerfil()
                        PerfilSave()
                        
                        PerfilSavePhoto()
                        
                        print("Datos Modificados")
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                        
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["Error_Msg"] as? NSString != nil {
                            error_msg = jsonData["Error_Msg"] as! NSString
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
    }
    
    
    
    func VerifyPasswordDataBase(){
        let tagVP = "VerifyPassword"
        
        fetch()

        
        do {
            let post:NSString = "Tag=\(tagVP)&Client_Id=\(C_Id)&Password=\(userPassword)"
            
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
                    
                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let success:NSInteger = jsonData.valueForKey("Success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        
                        updateProfile()
                        PerfilSavePhoto()
                        
 //UIImageWriteToSavedPhotosAlbum(self.profileImg.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
                       
                       
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["Error_Msg"] as? NSString != nil {
                            error_msg = jsonData["Error_Msg"] as! NSString
                        } else {
                            error_msg = "Contraseña incorrecta"
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Error"
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
    
    
    
    
    
    
    func deletePerfil() {
        // let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let context: NSManagedObjectContext = appDel.managedObjectContext!
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
    
    func PerfilSave(){
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Perfil", inManagedObjectContext: moc)
        
        // add our data
        // entity.setValue(Unique_Id, forKey: "unique_id")
        entity.setValue(user_name, forKey: "name")
        entity.setValue(user_email, forKey: "email")
        entity.setValue(user_phone, forKey: "phone")
        //entity.setValue(profileImg, forKey: "userImage")
        // we save our entity
        do {
            try moc.save()
            
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func PerfilSavePhoto(){
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Perfil", inManagedObjectContext: moc)
        

        entity.setValue(self.profileImg.image, forKey: "userImage")
        
        // we save our entity
        do {
            try moc.save()
            print("Foto guardada")
            
            
        } catch {
            fatalError("Failure to save context: \(error)")
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
