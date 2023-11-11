//
//  NewsTableViewCell.swift
//  K-lab-project
//
//  Created by 정소은 on 10/31/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsHeadLine: UILabel!
    @IBOutlet weak var newsMainText: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

