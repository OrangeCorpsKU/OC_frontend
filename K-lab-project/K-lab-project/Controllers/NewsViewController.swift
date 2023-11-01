//
//  NewsViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 10/31/23.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource {
    
    var newsArray: [News] = [
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000"),
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000")
    ]
    

    @IBOutlet weak var news_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        news_tableView.dataSource = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = news_tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        cell.newsImageView.image = newsArray[indexPath.row].newsImage
        cell.newsHeadLine.text = newsArray[indexPath.row].newsHeadLine
        cell.newsMainText.text = newsArray[indexPath.row].newsMainText
        
        return cell
        
    }

}
