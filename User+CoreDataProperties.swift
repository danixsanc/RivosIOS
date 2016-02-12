//
//  User+CoreDataProperties.swift
//  
//
//  Created by Ramón Quiñonez on 19/10/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var email: String?
    

}

extension Perfil{
    
    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var userImage: NSData?
    

}