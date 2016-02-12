//
//  Repository.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 31/12/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import Foundation

import UIKit

class Repository {
    
    var name: String?
    var date: String?
    //var html_url: String?
    
    init(json: NSDictionary) {
        self.name = json["name"] as? String
        self.date = json["description"] as? String
        //self.html_url = json["html_url"] as? String
    }
}