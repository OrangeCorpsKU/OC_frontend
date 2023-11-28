//
//  NewsViewModel.swift
//  K-lab-project
//
//  Created by 허준호 on 11/22/23.
//

import Foundation
import CoreLocation
import SwiftUI

//서버로부터 응답받기 위한 NewsResponse
struct NewsResponse: Codable {
    let data: [NewsItem]
}

//각 뉴스 아이템을 표현하기 위한 structure
struct NewsItem: Codable, Hashable {
    let url: String
    let headLine: String
    let summary: String
    let publishedDate: String
    let country: String
}

//NewsView에 관한 NewsViewModel
class NewsViewModel: NSObject, ObservableObject, URLSessionDelegate {
    
    //뉴스 item(NewsItem)들의 정보를 담는 list
    @Published var newsItems: [NewsItem] = []
    @Published var resultCode: Int = 0
    @Published var message: String = ""
        
    //뉴스 정보 불러오는 함수 (아무것도 불러오는 게 없으면 걍 return)
    func fetchNews(user_id: String) {
        guard let url = URL(string: "http://3.38.49.6:8080/news?userId=\(user_id)") else {
            print("URL 불러오기 실패")
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)

        
//        //request body를 위해 Json Data를 만들어낸다 (매개변수로 들어온 user_id를 이용해서)
//        let jsonBody = ["user": user_id]
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) else {
//            print("Json을 인코딩하는 데에 실패했습니다")
//            return
//        }
//        
//        //변경된 URL을 이용해서 URLRequest를 생성하고, Json data를 갖다 붙인다
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("에러 메시지: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            //오류 있으면 오류 잡아내기
            //JSONDecoder()로 json을 decoding 할 것입니다
            do {
                print(String(data: data, encoding: .utf8) ?? "Data is not valid UTF-8")
                let jsonDecoder = JSONDecoder()
                let decodedNewsItems = try jsonDecoder.decode([NewsItem].self, from: data)
                
                // Update the newsItems property on the main thread
                DispatchQueue.main.async {
                    self.newsItems = decodedNewsItems
                }
            } catch {
                print("An error occurred while decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    // URLSessionDelegate method to handle SSL errors
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}


