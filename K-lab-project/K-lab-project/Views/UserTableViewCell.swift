//
//  UserTableViewCell.swift
//  K-lab-project
//
//  Created by 정소은 on 10/30/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
