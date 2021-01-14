//
//  ClientCell.swift
//  Tenes
//
//  Created by Nico Cobelo on 14/01/2021.
//

import UIKit

class ClientCell: UITableViewCell {

    @IBOutlet var clientName: UILabel!
    @IBOutlet var boxesOwed: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
