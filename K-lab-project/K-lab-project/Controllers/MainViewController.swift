//
//  MainViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/30.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var newsArray: [News] = [
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000"),
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000")
    ]

    
    
    
    @IBOutlet weak var mainWeather_tableView: UITableView!
    @IBOutlet weak var mainNews_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainNews_tableView.dataSource = self
        mainNews_tableView.delegate = self
        
        let tapNewsGesture = UITapGestureRecognizer(target: self, action: #selector(didNewsTapView(_:)))
        
        let tapWeatherGesture = UITapGestureRecognizer(target: self, action: #selector(didWeatherTapView(_:)))

        mainNews_tableView.addGestureRecognizer(tapNewsGesture)
        mainWeather_tableView.addGestureRecognizer(tapWeatherGesture)
        
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
    
    @objc func didNewsTapView(_ sender: UITapGestureRecognizer) {
        
        // 테이블 뷰가 탭되었을 때 실행되는 코드
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "NewsViewController")
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    

    @objc private func didWeatherTapView(_ sender: UITapGestureRecognizer) {
        let hostingController = WeatherViewHostingController(rootView: WeatherViewController())
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }

}
