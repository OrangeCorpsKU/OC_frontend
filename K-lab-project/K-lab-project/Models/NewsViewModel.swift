//
//  NewsViewModel.swift
//  K-lab-project
//
//  Created by 허준호 on 11/22/23.
//

import Foundation
import CoreLocation
import SwiftUI

//NewsItem들
struct NewsItem: Identifiable, Decodable {
    var id = UUID()
    let titleImage: URL
    let title: String
    let newsSummary: String
}

//NewsView에 관한 NewsViewModel
class NewsViewModel: NSObject, ObservableObject {
    
    //뉴스 item(NewsItem)들의 정보를 담는 list
    @Published var newsItems: [NewsItem] = []
        
    //뉴스 정보 불러오는 함수 (아무것도 불러오는 게 없으면 걍 return)
    func fetchNews() {
        guard let url = URL(string: "NEWS 정보 불러오는 API URL 넣을 것임!") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            //오류 있으면 오류 잡아내기
            //JSONDecoder()로 json을 decoding 할 것입니다
            do {
                let decoder = JSONDecoder()
                let newsData = try decoder.decode([NewsItem].self, from: data)
                DispatchQueue.main.async {
                    self.newsItems = newsData
                }
            } catch {
                print("An error occurred while decoding JSON: \(error)")
            }
        }.resume()
    }
}
