//
//  ChatViewModel.swift
//  K-lab-project
//
//  Created by 허준호 on 12/4/23.
//

import Foundation

struct ChatRoom: Decodable {
    let roomId: String?
    let roomName: String?
}

// ChatViewModel.swift
class ChatViewModel: ObservableObject {
    @Published var messages: [String] = ["Hello", "Hi there!", "How are you?"]
    @Published var newMessage: String = ""
    @Published var chatRoom: ChatRoom?
    @Published var user_name: String = "ssilver0104@gmail.com"
    
    @Published var lastSentMessage: String? //맨 마지막으로 내가 보낸 메시지

    private let socketManager = SocketManager.shared

    func connectToServer() {
        socketManager.connectToServer()
    }

    func createChatRoom(successCallback: @escaping () -> Void) {
        socketManager.createChatRoom(withName: user_name) { result in
            switch result {
            case .success(let chatRoom):
                DispatchQueue.main.async {
                    self.chatRoom = chatRoom
                    successCallback()
                }
            case .failure(let error):
                print("Error creating chat room: \(error.localizedDescription)")
            }
        }
    }

    func subscribeToStompTopic(roomID: String) {
        socketManager.subscribeToStompTopic(roomID: roomID)
    }

    func sendMessage() {
        //채팅방이 존재하지 않는다면 Error 메시지를 출력할 것이다
        guard let roomID = chatRoom?.roomId else {
            print("Error: No chat room available")
            return
        }
        
        //socketManager에서 관리하고 있는 sendMessage()를 호출한다
        socketManager.sendMessage(message: newMessage, senderID: user_name, roomID: roomID)
        
        // Set lastSentMessage to the newMessage
        lastSentMessage = newMessage
        newMessage = ""  // Clear the newMessage after sending
        
    }
    
    // Modify receiveMessage function in ChatViewModel
    func receiveMessage() {
        guard let roomID = chatRoom?.roomId else {
            print("Error: No chat room available")
            return
        }

        SocketManager.shared.receiveMessage { message in
            do {
                if let jsonData = message.data(using: .utf8),
                   let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let messageType = json["type"] as? String,
                   messageType == "CHAT",
                   let senderID = json["sender"] as? String,
                   let message = json["message"] as? String {

                    DispatchQueue.main.async {
                        // Handle the received message
                        let formattedMessage = "\(senderID): \(message)"
                        self.messages.append(formattedMessage)
                    }
                }
            } catch {
                print("Error deserializing chat message: \(error.localizedDescription)")
            }
        }
    }
    
    //보내진 메시지들에다가 보낸 메시지를 append 하기 위한 addMessage()
    func addMessage(_ message: String) {
        DispatchQueue.main.async { //Main Thread에서 시행되도록 한다.
            self.messages.append(message)
        }
    }
}
