//
//  MainNewsTableViewCell.swift
//  K-lab-project
//
//  Created by 정소은 on 10/31/23.
//

import UIKit

class MainNewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainNewsImageView: UIImageView!
    @IBOutlet weak var mainNewsHeadLine: UILabel!
    @IBOutlet weak var mainNewsMainText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
