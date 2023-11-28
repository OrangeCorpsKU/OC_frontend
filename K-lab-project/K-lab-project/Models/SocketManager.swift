//
//  SocketManager.swift
//  K-lab-project
//
//  Created by 허준호 on 11/27/23.
//

//해당 클래스는 socket connection을 control 및 message sending/reciving을 담당할 것이다
import Foundation
import SwiftSocket

class SocketManager {
    static let shared = SocketManager()
    
    private var client: TCPClient?
    
    //class 초기화하기 위한 init()
    private init() {}
    
    //서버에 연결하기 위한 함수
    func connectToServer() {
        //서버에 연결하기 위한 code를 여기에 적을 것이다
        //서버의 ip 주소와 port를 특정할 필요가 있다
        client = TCPClient(address: "your_server_ip", port: 12345) // Replace with your server's IP and port
        // Implement logic to handle the connection
    }
    
    func sendMessage(_ message: String) {
        //서버에 메시지를 send 하기 위한 code를 여기에 적을 것이다
        guard let client = client else { return }
        _ = client.send(string: message)
    }
    
    func receiveMessage() -> String? {
        //서버로부터 메시지를 receive 하기 위한 code를 여기에 적을 것이다
        guard let client = client else { return nil }
        // Implement logic to receive a message from the server
        if let data = client.read(1024, timeout: 10) {
            return String(bytes: data, encoding: .utf8)
        } else { //read에서 받아온 것이 없다면
            return nil
        }
    }
}

