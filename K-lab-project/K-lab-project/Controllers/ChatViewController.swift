//  ContentView.swift
//  TestApp
//
//  Created by 허준호 on 10/30/23.
//

import SwiftUI

//말풍선 모양을 정의한 곳입니다 (노란색 말풍선용)
struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Drawing a speech bubble shape
        let radius: CGFloat = 20
        let arrowHeight: CGFloat = 20

        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - arrowHeight, y: rect.maxY - arrowHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}

//말풍선 모양을 정의한 곳입니다 (회색 말풍선용)
struct InvertedSpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Drawing an inverted speech bubble shape
        let radius: CGFloat = 20
        let arrowHeight: CGFloat = 20

        path.move(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: true)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: true)
        path.addLine(to: CGPoint(x: rect.minX + arrowHeight, y: rect.maxY - arrowHeight))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: true)

        return path
    }
}

//제가 만든 NavigationBar를 위한 구조체입니다.
struct CustomNavigationBar: ViewModifier {
    var title: String

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            HStack {

                Spacer()
                
                //네비 바에는 상대방의 ID 값만이 들어갈 것임
                Text(title)
                    .foregroundColor(.black)
                    .font(.title2)

                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 50) //화면에서 잘 보이게 하기 위해서 top에다가 padding 줬습니다..
            .frame(height: 105) // 네비바 높이 조절했습니다..
            .background(Color(red: 255/255, green: 193/255, blue: 7/255)) //배경색깔 조절했습니다.. (RGB 값으로)
            
        }
    }
}

struct ChatViewController: View {
    @StateObject var viewModel = ChatViewModel()
    
    //새로 쓰여질 메시지들 저장할 String 변수입니다.
    @State var user_name: String = "ssilver0104@gmail.com"

    var body: some View {
        //여백을 해결하기 위해 spacing을 0으로 설정했습니다.
        VStack(spacing: 0) {
            //제가 Custom한 Naviagtion Bar을 사용하기 위해 modifier를 불렀습니다.
            Text("Your Content Here")
                .modifier(CustomNavigationBar(title: user_name))
            
            //채팅방에서 사용하게 될 ScrollView입니다.
            //VStack으로 구성했고, 채팅창에 치는 것 족족 자동으로 누적될 것입니다.
            ScrollView {
                VStack(spacing: 12) {
                    //각 채팅 내용에 id 값을 부여합니다 (id 값은 그 자체 (\.self))
                    ForEach(viewModel.messages, id: \.self) { message in
                        ChatBubble(message: message, isUser: message.isSentByUser())
                    }
                }
                .padding()
                .padding(.bottom, 20)
            }
            
            //채팅을 입력하는 창입니다.
            ChatInputView(viewModel: viewModel)
        }
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                viewModel.connectToServer() //Server에 먼저 연결한다
                viewModel.createChatRoom { //채팅방을 create한다
                    if let roomID = viewModel.chatRoom?.roomId { //roomID를 정상적으로 서버로부터 받아왔다면, roomID를 저장하여, StompTopic으로 구독한다.
                        viewModel.subscribeToRoom(roomID: roomID, senderID: user_name)
                    }
                }
            }
//            DispatchQueue.main.async {
////                viewModel.connectToServer() //Server에 먼저 연결한다
//                
//            }
        }
        //lastSentMessage를 이용하여 UI 업데이트
        .onChange(of: viewModel.lastSentMessage) { newMessage in
            // Handle changes in lastSentMessage, update UI if needed
            if let newMessage = newMessage, !newMessage.isEmpty {
                // Assuming you have a method to add the new message to your messages array
                viewModel.addMessage(newMessage)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
        
    }
}

struct ChatInputView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 50)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.yellow, lineWidth: 2)
                )
                .overlay(
                    HStack {
                        TextField("Type your message :)", text: $viewModel.newMessage)
                            .padding(.leading, 15)

                        Spacer()

                        Button(action: {
                            viewModel.sendMessage() //전송 버튼을 누르면 메시지를 보낸다
                            viewModel.newMessage = "" //TextField를 비우는 역할을 한다
                        }) {
                            Image("ArrowRightCircle")
                                .padding(.horizontal, 10)
                                .foregroundColor(.black)
                        }
                    }
                )
        }
        .padding()
        .padding(.bottom, 85)
    }
}

struct ChatBubble: View {
    let message: String
    let isUser: Bool

    var body: some View {
        HStack {
            if isUser { //내가 입력한 경우라면
                Spacer()
                Text(message)
                    .padding(10)
                    .background(SpeechBubble().fill(Color.yellow))
                    .foregroundColor(.white)
            } else { //내가 입력한 경우가 아니라면
                Image("profile")
                    .frame(width: 30, height: 30)
                    .padding(.top, 40)
                Text(message)
                    .padding(10)
                    .background(InvertedSpeechBubble().fill(Color.gray))
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}

extension String {
    func isSentByUser() -> Bool {
        // Implement your logic to determine if the message is sent by the user
        return true // Replace with your logic
    }
}

#Preview {
    ChatViewController()
}
