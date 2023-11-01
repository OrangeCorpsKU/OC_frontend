//
//  UICreatAccount.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/29.
//

import Foundation

class UICreateAcocunt: UIViewController {
    //변수명
    

    @IBOutlet weak var SignupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        
        Divider()
        SignupButton.layer.borderWidth = 1
        SignupButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        SignupButton.layer.cornerRadius = 12
    }
    
    //동작
    
    

    }
