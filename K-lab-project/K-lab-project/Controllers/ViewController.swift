//
//  ViewController.swift
//  K-lab project
//
//  Created by 정소은 on 2023/10/28.
//

import UIKit
import GoogleSignIn
import SwiftUI

class  ViewController: UIViewController {
    

    @IBOutlet weak var SignUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        
        SignUpBtn.layer.borderWidth = 1
        SignUpBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        SignUpBtn.layer.cornerRadius = 12

    }
    
    //동작
    
    
    
    @IBAction func SignUpBtnTapped(_ sender: UIButton) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController")
                vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
                vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
                self.present(vcName!, animated: true, completion: nil)
    }
    
    
    }
    

    
    

