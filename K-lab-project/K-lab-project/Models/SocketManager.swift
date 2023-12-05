//
//  SocketManager.swift
//  K-lab-project
//
//  Created by 허준호 on 11/27/23.
//

//해당 클래스는 socket connection을 control 및 message sending/reciving을 담당할 것이다
import Foundation
import Starscream

enum StompCommand: String {
    case connect
    case disconnect
    case subscribe
    case send
    // Add other STOMP commands as needed
}

struct StompFrame {
    let command: StompCommand
    let headers: [String: String]
    let body: String?

    init(command: StompCommand, headers: [String: String] = [:], body: String? = nil) {
        self.command = command
        self.headers = headers
        self.body = body
    }

    func toString() -> String {
        // Implementation here
        return ""
    }
}

struct Constants {
    static let serverURL = "ws://3.38.49.6:8080/chat/room"
}

class SocketManager: NSObject, WebSocketDelegate {
    
    static let shared = SocketManager()
    
    private var socket: WebSocket?
    
    //WebSocket과 관련하여 발생할 수 있는 상황들을 switch statement로 나누어 놓은 것
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers): //WbeSocket이 정상적으로 연결되었을 때
            // Handle the WebSocket connection
            print("WebSocket is connected with headers: \(headers)")
        case .disconnected(let reason, let code): //WebSocket이 disconnected되었을 때
            // Handle the WebSocket disconnection
            print("WebSocket is disconnected with reason: \(reason) and code: \(code)")
        case .text(let string):
            // Handle received text data
            print("Received text data: \(string)")
            // You can process the received text data as needed for your chat application
        case .binary(let data):
            // Handle received binary data
            print("Received binary data: \(data)")
            // You can process the received binary data as needed for your chat application
        case .ping(_):
            // Handle ping
            break
        case .pong(_):
            // Handle pong
            break
        case .viabilityChanged(_):
            // Handle viability changed
            break
        case .reconnectSuggested(_):
            // Handle reconnect suggestion
            break
        case .cancelled:
            // Handle cancellation
            break
        case .error(let error):
            // Handle error
            print("WebSocket encountered an error: \(error?.localizedDescription ?? "Unknown error")")
        case .peerClosed:
            // Handle the peer closing the connection
            print("Peer closed the connection!")

            // Additional actions you may want to take, such as updating UI or notifying the user
        }
    }
    
    private override init() {
        super.init()
        configureSocket()
    }
    
    //Socket을 Configure하기 위함
    private func configureSocket() {
        let urlString = Constants.serverURL
        guard let url = URL(string: urlString) else {
            print("Invalid WebSocket URL")
            return
        }
        socket = WebSocket(request: URLRequest(url: url))
        socket?.delegate = self
    }
    
    //server에 연결하기 위한 함수
    func connectToServer() {
        print("Connecting to server....")
        socket?.connect()
    }
    
    //서버로부터 Disconnect하기 위한 함수
    func disconnectFromServer() {
        socket?.disconnect()
    }
    
    //채팅방을 만들어주는 function
    func createChatRoom(withName name: String, completion: @escaping (Result<ChatRoom, Error>) -> Void) {
        // Create a POST request to create a chat room
//        let urlString = Constants.serverURL
//        socket = WebSocket(request: URLRequest(url: URL(string: urlString)!))
//        socket?.delegate = self
        
        //url을 이요해서 서버에 요청을 보낸다
        //POST 요청으로 보내야 한다
        let url = URL(string: "http://3.38.49.6:8080/chat/room?name=\(name)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Log the request details
//            print("Request URL: \(request.url?.absoluteString ?? "N/A")")
//            print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
//            print("Request Parameter: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "N/A")")

            guard let data = data, error == nil else {
                // Log the error details
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error!))
                return
            }

            // Log the response details
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Response Status Code: \(httpResponse.statusCode)")
//            }

            do {
                let chatRoom = try JSONDecoder().decode(ChatRoom.self, from: data)
                completion(.success(chatRoom))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func subscribeToRoom(roomID: String, senderID: String) {
        let stompSubscribeFrame = StompFrame(command: .subscribe, headers: ["destination": "/topic/\(roomID)"])
        print(stompSubscribeFrame)
        sendMessage(message: stompSubscribeFrame.toString(), senderID: senderID, roomID: roomID)
    }
    
    func handleStompMessage(_ message: String) {
        print("Received STOMP message: \(message)")
        // Process the STOMP message
    }
    
    // Modify sendMessage function in SocketManager
    func sendMessage(message: String, senderID: String, roomID: String) {
        
        // Check if the message is empty before sending (빈 메시지인지 체크)
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Do nothing if the message is empty
            print("Empty message. Not sending.")
            return
        }
        
        let chatMessage = [
            "type": "CHAT",
            "sender": senderID,
            "message": message,
            "roomId": roomID
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: chatMessage)
            socket?.write(data: jsonData)
            print(chatMessage)
            print("jsonData write 성공")
        } catch {
            print("Error serializing chat message: \(error.localizedDescription)")
        }
    }
    
    func receiveMessage(completion: @escaping (String) -> Void) {
        
        //socket?.onEvent는 텍스트 메시지를 포함한 다양한 WebSocket event들을 처리한다
        socket?.onEvent = { [weak self] event in
            switch event { //텍스트 메시지가 들어오면, 텍스트를 추출한다
            case .text(let text):
                do {
                    if let jsonData = text.data(using: .utf8),
                       let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let messageType = json["type"] as? String,
                       messageType == "CHAT",
                       let senderID = json["sender"] as? String,
                       let message = json["message"] as? String {

                        DispatchQueue.main.async {
                            // Handle the received message
                            let formattedMessage = "\(senderID): \(message)"
                            completion(formattedMessage)
                        }
                    }
                } catch {
                    print("Error deserializing chat message: \(error.localizedDescription)")
                }
            default:
                break
            }
        }
    }
    
    // WebSocketDelegate methods and other necessary methods go here
}

