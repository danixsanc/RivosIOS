//
//  TableCell.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 29/12/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import Foundation

class TableCell: UITableViewCell, SearchAPIProtocol {
    let dataManagerObj = DataManager()
    
    func setUpCell(urlString: String){
        dataManagerObj.delegate = self
        dataManagerObj.searchAPIFor(urlString)
    }
    
    func didReceiveResults(dataObj: NSData){
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.imageView?.image = UIImage(data: dataObj)
            self.setNeedsLayout()
        });
        
    }
}
