//
//  MainViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/30.
//

import UIKit

class MainViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var newsArray: [News] = [
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000"),
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000")
    ]

    
    
    
    @IBOutlet weak var mainNews_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainNews_tableView.dataSource = self
        mainNews_tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mainNews_tableView.addGestureRecognizer(tapGesture)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainNews_tableView.dequeueReusableCell(withIdentifier: "MainNewsTableViewCell", for: indexPath) as! MainNewsTableViewCell
        
        cell.mainNewsImageView.image = newsArray[indexPath.row].newsImage
        cell.mainNewsHeadLine.text = newsArray[indexPath.row].newsHeadLine
        cell.mainNewsMainText.text = newsArray[indexPath.row].newsMainText
        
        
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // 테이블 뷰가 탭되었을 때 실행되는 코드
        if sender.state == .ended {
            // 스토리보드에서 다른 뷰 컨트롤러로 이동
            if let NewsViewController = storyboard?.instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController {
                navigationController?.pushViewController(NewsViewController, animated: true)
            }
        }
    }
    
    
    
    

   
}
