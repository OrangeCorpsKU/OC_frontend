//
//  MypageViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 10/30/23.
//

import UIKit

class MypageViewController: UIViewController {

    @IBOutlet var mypage_stackViewCells: [UIStackView]!
    @IBOutlet var myPage_textField: [UITextField]!
    @IBOutlet weak var myPageImageView: UIImageView!
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    func setUI(){
        //유저의 이미지
        myPageImageView.layer.cornerRadius =  myPageImageView.frame.width / 2
        myPageImageView.layer.borderWidth = 2
        myPageImageView.layer.borderColor = UIColor.gray.cgColor
        
        //
        for i in myPage_textField {
            i.borderStyle = .none
        }
        for i in mypage_stackViewCells{
            i.layer.cornerRadius = 8;
            i.layer.masksToBounds = true;
        }
        
        
        editButton.layer.cornerRadius = 8;
        editButton.layer.masksToBounds = true;
        
        deleteButton.layer.cornerRadius = 8;
        deleteButton.layer.masksToBounds = true;
    }
}
