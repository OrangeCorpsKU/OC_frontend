//
//  CoupleRegisterViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/30.
//

import UIKit

class CoupleRegisterViewController: UIViewController,UITableViewDataSource{
    
    var UserArray: [User] = [
        User(userImage: UIImage(systemName: "person"),userName: "soeun", userEmail: "soeun@gmail.com"),
        User(userImage: UIImage(systemName: "person"),userName: "soeun", userEmail: "soeun@gmail.com")
    ]
    
    @IBOutlet weak var user_tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_tableView.dataSource = self

    }
    

    @IBAction func BackButtonPressed(_ sender: UIButton) {
                dismiss(animated: true)
    }
    
    
    @IBAction func SearchButtonPressed(_ sender: UIButton) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
                vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
                vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
                self.present(vcName!, animated: true, completion: nil)
    }
    
    
    //tableView
    //몇개의 컨텐츠를 표시할 것인지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray.count
    }
    
    //셀그리기〰️
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = user_tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        cell.userImageView.image = UserArray[indexPath.row].userImage
        cell.userNameLabel.text = UserArray[indexPath.row].userName
        cell.userEmailLabel.text = UserArray[indexPath.row].userEmail
        
        return cell
        
    }
    

}
