//
//  MyTableViewCell.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 12/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {


    @IBOutlet weak var AcercaDeImg: UIImageView!
    @IBOutlet weak var SubtitleAcercaDeItemLabel: UILabel!
    @IBOutlet weak var AcercaDeItemLabel: UILabel!
    
    
    @IBOutlet weak var question_answer: UILabel!
    @IBOutlet weak var helpItemLabel: UILabel!
    @IBOutlet weak var menuItemLabel: UILabel!

    @IBOutlet weak var itemImage: UIImageView!

    @IBOutlet weak var profileItemLabel: UILabel!
    
    @IBOutlet weak var payItemLabel: UILabel!
    @IBOutlet weak var editItemTextfield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}
