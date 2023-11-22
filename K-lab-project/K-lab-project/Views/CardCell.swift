//
//  CardCell.swift
//  K-lab-project
//
//  Created by 정소은 on 11/21/23.
//

// CardCell.swift

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel
    
    func configure(with question: String, answer: String?) {
        questionLabel.text = question
        answerLabel.text = answer
    }

    func flip() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
}
