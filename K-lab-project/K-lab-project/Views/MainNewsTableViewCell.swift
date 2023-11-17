//
//  MainNewsTableViewCell.swift
//  K-lab-project
//
//  Created by 정소은 on 10/31/23.
//

import UIKit

protocol MainNewsTableViewCellDelegate: AnyObject {
    func didTapCell()
}

class MainNewsTableViewCell: UITableViewCell {
    
    //delegate 선언
    weak var delegate: MainNewsTableViewCellDelegate?
    
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
    
    //Add an action for when the cell is tapped
    @IBAction func cellTapped(_ sender: Any) {
            delegate?.didTapCell()
        }

}
