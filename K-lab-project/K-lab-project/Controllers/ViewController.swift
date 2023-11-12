//
//  ViewController.swift
//  K-lab project
//
//  Created by 정소은 on 2023/10/28.
//

import UIKit
import GoogleSignIn

class  ViewController: UIViewController{
    

    @IBOutlet weak var SignUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        //기존 로그인한 경우 바로 페이지 이동
        checkState()
    }
    
    
    func setup(){
        
        SignUpBtn.layer.borderWidth = 1
        SignUpBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        SignUpBtn.layer.cornerRadius = 12

    }
    
    }
    
extension ViewController{
    
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn{ user, erro in
            if erro != nil || user == nil {
                print("Not Sign In")
            }else{
                guard let user = user else {return}
                guard let profile = user.profile else {return}
                
                // 유저 데이터 로드
                self.loadUserData(profile)
            }
            
        }
    }
    
    //구글 로그인
    func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if error != nil {
                let popup = UIAlertController(title: "로그인 실패", message: "다시 로그인해주세요", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true)
                return
            }
            
            // 로그인 성공시
            guard let user = signInResult?.user else { return }
            guard let profile = user.profile else { return }
            
            // 유저 데이터 로드
            self.loadUserData(profile)
        }
    }

    //유저 데이터 전달
    func loadUserData(_ profile: GIDProfileData) {
        let emailAddress = profile.email
        let fullName = profile.name
        let profilePicUrl = profile.imageURL(withDimension: 180)
        
        // 이미지 다운로드
        if let profilePicUrl = profilePicUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profilePicUrl) {
                    if let userImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            let userData = User(userImage: userImage, userName: fullName, userEmail: emailAddress)
                            self.moveNextPage(_data: userData)
                        }
                    }
                }
            }
        }
    }

    
    // 메인으로 바로 가기
    func moveNextPage(_data: User) {
        if let vcName = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            vcName.User = _data
            vcName.modalPresentationStyle = .fullScreen
            vcName.modalTransitionStyle = .crossDissolve
            self.present(vcName, animated: true, completion: nil)
        }
    }


}

extension ViewController{
    
    @IBAction func clickGoogleLogin(_sender:Any){
        googleLogin()
    }
    
}
    

