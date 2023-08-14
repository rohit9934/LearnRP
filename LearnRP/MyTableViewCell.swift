//
//  MyTableViewCell.swift
//  LearnRP
//
//  Created by Rohit Sharma on 24/06/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var giveLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(data: Int){
        giveLabel.text = String(data)
    }
    
}
