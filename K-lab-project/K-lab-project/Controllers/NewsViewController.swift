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

        // Register the NewsTableViewCell for the "NewsTableViewCell" identifier
        news_tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell

        if let newsImage = newsArray[indexPath.row].newsImage {
            cell.newsImageView.image = newsImage
        } else {
            //newsImage가 nil값이라면, default image를 주도록 한다.
            cell.newsImageView.image = UIImage(named: "defaultImage")
        }

        cell.newsHeadLine.text = newsArray[indexPath.row].newsHeadLine
        cell.newsMainText.text = newsArray[indexPath.row].newsMainText

        return cell
    }

}

