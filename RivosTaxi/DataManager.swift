//
//  DataManager.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 29/12/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import Foundation

protocol SearchAPIProtocol {
    func didReceiveResults(dataObj: NSData)
    
}


class DataManager {
    var delegate: SearchAPIProtocol?
    
    func searchAPIFor(urlString: String) {
        
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                
                print(error!.localizedDescription)
            }
            self.delegate?.didReceiveResults(data!)
            
        })
        task.resume()
    }
    
}