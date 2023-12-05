//
//  NewsViewModel.swift
//  K-lab-project
//
//  Created by 허준호 on 11/22/23.
//

import Foundation
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
    let imgUrl: String? //null로 들어올 수도 있어서 그에 대한 예외처리
}

//NewsView에 관한 NewsViewModel
class NewsViewModel: NSObject, ObservableObject, URLSessionDelegate {
    
    //뉴스 item(NewsItem)들의 정보를 담는 list
    @Published var newsItems: [NewsItem] = []
    @Published var resultCode: Int = 0
    @Published var message: String = ""
    
    //Pagination 개념을 위한 변수들입니당!
    var currentNewsIndex: Int = 0
    var isLoading: Bool = false
        
    //뉴스 정보 불러오는 함수 (아무것도 불러오는 게 없으면 걍 return)
    func fetchNews(user_id: String, index: Int) {
        guard !isLoading else {
            return //한 작업이 이미 progress에 있다면 더 이상 새로운 request를 만들지 않음 (한번에 한 progress씩 수행하도록 함)
        }
        
        isLoading = true //isLoading을 true로 변환
        
        //Api를 통해서 userid와 index 값을 넘겨줄 것임
        guard let url = URL(string: "http://3.38.49.6:8080/news?userId=\(user_id)&index=\(index)") else {
            print("URL 불러오기 실패")
            isLoading = false //isLoading 변수를 false로 변경한다
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)

        
        let task = session.dataTask(with: url) { data, response, error in
            
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.currentNewsIndex = index + 1
                }
            }
            
            guard let data = data, error == nil else {
                print("에러 메시지: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            //오류 있으면 오류 잡아내기
            //JSONDecoder()로 json을 decoding 할 것입니다
            do {
//                print(String(data: data, encoding: .utf8) ?? "Data is not valid UTF-8")
                let jsonDecoder = JSONDecoder()
                let decodedNewsItems = try jsonDecoder.decode([NewsItem].self, from: data)
                print(decodedNewsItems)
                
                // Update the newsItems property on the main thread
                DispatchQueue.main.async {
                    if index == 0 {
                        //만약 지금이 first page라면, 지금 existing하는 items들을 replace한다
                        self.newsItems = decodedNewsItems
                    } else {
                        //만약 지금이 first page가 아니라면, 새로운 item들을 append 한다
                        // Append new items only if they don't exist in the current list
                        for newItem in decodedNewsItems {
                            if !self.newsItems.contains(newItem) {
                                self.newsItems.append(newItem)
                            }
                        }
                    }
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


