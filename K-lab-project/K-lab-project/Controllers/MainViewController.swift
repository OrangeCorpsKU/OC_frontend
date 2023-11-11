//
//  MainViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/30.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var newsArray: [News] = [
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000"),
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000")
    ]

    
    @IBOutlet weak var mainNews_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainNews_tableView.dataSource = self
        mainNews_tableView.delegate = self //delegate를 설정해야 한답니다!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainNews_tableView.dequeueReusableCell(withIdentifier: "MainNewsTableViewCell", for: indexPath) as! MainNewsTableViewCell
        
        cell.mainNewsImageView.image = newsArray[indexPath.row].newsImage
        cell.mainNewsHeadLine.text = newsArray[indexPath.row].newsHeadLine
        cell.mainNewsMainText.text = newsArray[indexPath.row].newsMainText
        
//        cell.delegate = self // Set the delegate to self
        
        return cell
    }
    
    // Implement the MainNewsTableViewCellDelegate method
//        func didTapCell() {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your actual storyboard name
//            if let hostingController = storyboard.instantiateViewController(withIdentifier: "HostingControllerIdentifier") as? HostingController {
//                self.navigationController?.pushViewController(hostingController, animated: true)
//            }
//        }
}
