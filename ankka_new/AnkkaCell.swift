//
//  AnkkaCell.swift
//  ankka_new
// Sisältää AnkkaListViewControllerin TableView:n yhden solun labelit
//
//  Created by Matti Saarela on 24/01/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class AnkkaCell: UITableViewCell {
    
    @IBOutlet weak var datetime_label: UILabel!
    @IBOutlet weak var desc_label: UILabel!
    @IBOutlet weak var species_label: UILabel!
    @IBOutlet weak var count_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
