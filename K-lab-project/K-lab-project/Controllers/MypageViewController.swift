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
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var birthLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var textFields: [UITextField] = []
    var labels: [UILabel] = []
    
    //edit 상태
    var editStatus:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        textFields = [userNameTextField,countryTextField,dayTextField,birthTextField]
        labels = [userNameLabel,countryLabel,dayLabel,birthLabel]
        userNameTextField.isHidden = true

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
    
    
    // edit 버튼을 눌렀다면
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if editStatus {
                    for (textField, label) in zip(textFields, labels) {
                        label.text = textField.text
                        label.isHidden = false
                        textField.isHidden = true
                    }
                    editButton.setTitle("Edit", for: .normal)
                } else {
                    // 수정중일 경우
                    for (textField, label) in zip(textFields, labels) {
                        textField.text = label.text
                        textField.isHidden = false
                        label.isHidden = true
                    }
                    editButton.setTitle("Save", for: .normal)
                }
                editStatus.toggle()
        
    }
    
    
    
    
}
