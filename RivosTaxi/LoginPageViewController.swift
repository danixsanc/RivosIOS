//
//  LoginPageViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 02/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import FBSDKCoreKit
import CoreData
import TextFieldEffects


class LoginPageViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, NSFetchedResultsControllerDelegate {
    
    //FavoritesSave
    var place_name = ""
    var place_favorite = ""
    var desc_place = ""
    var latitude = ""
    var longitude = ""
    //Perfil save
    var user_name = ""
    var user_email = ""
    var user_phone = ""
    
    var Client_Id = ""

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var userEmailTextField: TextFieldEffects!
    @IBOutlet weak var userPasswordTextField: TextFieldEffects!
    
    var C_Id = ""

    // create an instance of our managedObjectContext
    let moc = DataController().managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)

        // Do any additional setup after loading the view.
        loginButton.delegate = self
        loginButton.readPermissions=["public_profile","email","user_friends"]
        //loginButton.setTitle("FB", forState: UIControlState.Normal)
        
        
        //Icons TextFields
      /*  userEmailTextField.leftViewMode = UITextFieldViewMode.Always
        userEmailTextField.leftView = UIImageView(image: UIImage(named: "ic_email_18pt"))
        
        userPasswordTextField.leftViewMode = UITextFieldViewMode.Always
        userPasswordTextField.leftView = UIImageView(image: UIImage(named: "ic_lock_18pt"))*/
        
       


    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        
        if(isUserLoggedIn)
        {
            NSLog("Login SUCCESS");
            
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            prefs.setInteger(1, forKey: "isUserLoggedIn")
            prefs.synchronize()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }


    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Verificar login con fb
        if(FBSDKAccessToken.currentAccessToken() != nil)
        {
            NSLog("Login SUCCESS");

            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

            prefs.setInteger(1, forKey: "isUserLoggedIn")
            prefs.synchronize()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
      

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    //FB
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        
        //Verifica si hay algun tipo de error
        if( error != nil)
        {
            print(error.localizedDescription, terminator: "")
            return
        }
        
        //Condicion para verificar el token de fb
        if let userToken = result.token{
            //Get user acces token
            let token:FBSDKAccessToken=result.token
            //Imprime el token y ID dl registro
            print("Token = \(FBSDKAccessToken.currentAccessToken().tokenString)", terminator: "")
            
            print("User ID = \(FBSDKAccessToken.currentAccessToken().userID)", terminator: "")
            
            
            
            //Mostrar info en consola
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"])
            
            graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
                
                
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(error)", terminator: "")
                }
                    
                else{
                    
                    print("fetched user: \(result)", terminator: "")
                    
                    let userEmail : NSString = result.valueForKey("email") as! NSString
                    print("User Email is: \(userEmail)", terminator: "")
                    
                    
                    let tag = "Login_Fb";
                    do {
                        let post:NSString = "Tag=\(tag)&Email=\(userEmail)"
                        
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
                                    NSLog("Login SUCCESS");
                                    
                                    self.seedUser()
                                    
                                    
                                    let perfil = jsonData["User"]
                                    self.user_name = perfil!["Name"] as! String
                                    self.user_email = perfil!["Email"] as! String
                                    self.user_phone = perfil!["Phone"] as! String
                                    self.PerfilSave()
                                  
                                    self.GetFavoritePlaces()
                                    
                                    
                                    
                                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                    prefs.setObject(userEmail, forKey: "Email")
                                    prefs.setInteger(1, forKey: "isUserLoggedIn")
                                    prefs.synchronize()
                                    
                                    self.dismissViewControllerAnimated(true, completion: nil)
       
                                   /* let loginPage1 = self.storyboard?.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! ProtectedPageViewController
                                    let loginPageNav1 = UINavigationController(rootViewController: loginPage1)
                                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = loginPageNav1*/
                                   // self.performSegueWithIdentifier("loginView", sender: nil)
                                    
                                   // self.dismissViewControllerAnimated(true, completion: nil)

                                }
                                    
                                
                                else {
                                    var error_msg:NSString
                                    
                                    if jsonData["Error_message"] as? NSString != nil {
                                        error_msg = jsonData["Error_message"] as! NSString
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
                            let alertView:UIAlertView = UIAlertView()
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
            }
        }
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
    
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    

    @IBAction func LoginButtonTapped(sender: AnyObject) {
        let userEmail:NSString = userEmailTextField.text!;
        let userPassword:NSString = userPasswordTextField.text!;
        
       
        if ( userEmail.isEqualToString("") || userPassword.isEqualToString("") ) {
            
            let alert = UIAlertView(title: "Error", message: "Informacion incompleta.", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            
        } else if (userPassword.length  < 5 ) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "FALLÓ EL REGISTRO"
            alertView.message = "La contraseña debe contener minimo 5 caractéres."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        }
            
        else if !isValidEmail(userEmail as String)
        {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "FALLÓ EL REGISTRO"
            alertView.message = "Email incorrecto."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }

        
        
        else {
            let tag = "Login";
            do {
                let post:NSString = "Tag=\(tag)&Email=\(userEmail)&Password=\(userPassword)"
            
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
                        NSLog("Success: %ld", success);
                        
                        if(success == 1)
                        {
                          
                            Client_Id = ((jsonData as NSDictionary) ["User"] as! NSDictionary) ["Client_Id"] as! String
                            seedUser()
                            
                            
                            let perfil = jsonData["User"]
                            user_name = perfil!["Name"] as! String
                            user_email = perfil!["Email"] as! String
                            user_phone = perfil!["Phone"] as! String
                            PerfilSave()
                           GetFavoritePlaces()
                            
                            NSLog("Login SUCCESS");
                     
                          

                            
                            //fetch()
                            
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(userEmail, forKey: "Email")
                            prefs.setInteger(1, forKey: "isUserLoggedIn")
                            prefs.synchronize()
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            
                            
                            
                          
                            
                        }else if(success==0){
                            let alertView:UIAlertView = UIAlertView()
                            alertView.title = "FALLÓ EL PROCESO"
                            alertView.message = "Nombre de usuario o contraseña incorrectas"
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            
                            
                            
                        }
                            
                        else {
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
    
    
    func seedUser(){
        
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
       
        // add our data
       // entity.setValue(Unique_Id, forKey: "unique_id")
        entity.setValue(Client_Id, forKey: "client_id")
        // we save our entity
        do {
            try moc.save()
            
            
        } catch {
            fatalError("Failure to save context: \(error)")
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
        // we save our entity
        do {
            try moc.save()
            
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    func FavoritosSave(){
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Favoritos", inManagedObjectContext: moc)
        
        // add our data
        // entity.setValue(Unique_Id, forKey: "unique_id")
        
        entity.setValue(place_name, forKey: "place_name")
        entity.setValue(place_favorite, forKey: "place_favorite_id")
        entity.setValue(desc_place, forKey: "desc_place")
        entity.setValue(latitude, forKey: "latitude")
        entity.setValue(longitude, forKey: "longitude")
        
        // we save our entity
        do {
            try moc.save()
            
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func GetFavoritePlaces()
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
                    
                    //var error: NSError?
                    
                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    
                    let success:NSInteger = jsonData.valueForKey("Success") as! NSInteger
                    
                    
                    
                    
                    
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        let entity = NSEntityDescription.insertNewObjectForEntityForName("Favoritos", inManagedObjectContext: moc)
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
                                    place_name = placeName
                                    print(placeName)
                                    
                                }
                                
                                if let placefavorite = result!["Place_Favorite_Id"] as? String
                                {
                                    place_favorite = placefavorite
                                    print(placefavorite)
                                    
                                }
                                if let descplace = result!["Desc_Place"] as? String
                                {
                                    desc_place = descplace
                                    print(descplace)
                                    
                                }
                                if let lat = result!["Latitude"] as? String
                                {
                                    latitude = lat
                                    print(lat)
                                    
                                }
                                if let lon = result!["Longitude"] as? String
                                {
                                    longitude = lon
                                    print(lon)
                                    
                                }
                                FavoritosSave()
                                //print(PlacesNames)
                            }
                            
                        }else
                        {
                            print("No results")
                            
                        }
                        print("Found favs")
                        SwiftLoading().hideLoading()
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            SwiftLoading().hideLoading()
                            error_msg = "No has añadido favoritos"
                        }
                        SwiftLoading().hideLoading()
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
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                SwiftLoading().hideLoading()
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
            SwiftLoading().hideLoading()
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Server Error"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
        
    }
    

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User is logged out");
    }

    }



