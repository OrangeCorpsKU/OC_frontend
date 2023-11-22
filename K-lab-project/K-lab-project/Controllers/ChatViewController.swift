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
    var backBtnAction: () -> Void
    var TIDAction: () -> Void

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            HStack {
                //back Button을 눌렀을 때, 뒤로 가게 만들 겁니다
                Button(action: backBtnAction) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height:24)
                }

                Spacer()

                Text(title)
                    .foregroundColor(.black)
                    .font(.title2)

                Spacer()
                
                //TID Button을 눌렀을 때 TIDAction 메서드를 부를 겁니다
                Button(action: TIDAction) {
                    Image("eventIcon")
                        .foregroundColor(.black)
                        .frame(width: 24, height:24)
                }
            }
            .padding(.horizontal)
            .padding(.top, 50) //화면에서 잘 보이게 하기 위해서 top에다가 padding 줬습니다..
            .frame(height: 105) // 네비바 높이 조절했습니다..
            .background(Color(red: 255/255, green: 193/255, blue: 7/255)) //배경색깔 조절했습니다.. (RGB 값으로)
            
        }
    }
}

class ChatViewModel: ObservableObject {
    //위의 4개 미리 쳐져 있는 dummy data들입니다.
    @Published var messages: [String] = ["Hello", "Hi there!", "How are you?", "I'm good, thanks!"]
    @Published var newMessage: String = ""

    func sendMessage() {
        messages.append(newMessage)
        newMessage = ""
    }
}



struct ChatViewController: View {
    @StateObject var viewModel = ChatViewModel()
    
    //새로 쓰여질 메시지들 저장할 String 변수입니다.
    @State var name: String = "GichuL"

    var body: some View {
        //여백을 해결하기 위해 spacing을 0으로 설정했습니다.
        VStack(spacing: 0) {
            //제가 Custom한 Naviagtion Bar을 사용하기 위해 modifier를 불렀습니다.
            Text("Your Content Here")
                .modifier(CustomNavigationBar(title: name, backBtnAction: {}, TIDAction: {}))
            
            //채팅방에서 사용하게 될 ScrollView입니다.
            //VStack으로 구성했고, 채팅창에 치는 것 족족 자동으로 누적될 것입니다.
            ScrollView {
                VStack(spacing: 12) {
                    //각 채팅 내용에 id 값을 부여합니다 (id 값은 그 자체 (\.self))
                    ForEach(0..<viewModel.messages.count, id: \.self) { index in
                        
                        if index % 2 == 0 {
                            //자신이 말하는 것(노란색 말풍선) 관련
                            HStack {
                                Spacer()
                                Text(viewModel.messages[index])
                                    .padding(10)
                                    .background(
                                            SpeechBubble()
                                                .fill(Color.yellow)
                                        )
                                    .foregroundColor(.white)
                            }
                        } else {
                            //상대방이 말하는 것(회색 말풍선) 관련
                            HStack {
                                Image("profile")
                                    .frame(width: 30, height: 30)
                                    .padding(.top, 40)
                                Text(viewModel.messages[index])
                                    .padding(10)
                                    .background(
                                            InvertedSpeechBubble()
                                                .fill(Color.gray)
                                        )
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 20)
            }
            
            //채팅을 입력하는 창입니다.
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 2)
                    )
                    //기본적인 RoundedRectangle 위에다가 입력창과 버튼을 overlay 했습니다
                    .overlay(
                        HStack {
                            TextField("Type your message :)", text: $viewModel.newMessage)
                                .padding(.leading, 15)
                            
                            Spacer()
                            
                            //채팅 보내기 버튼입니다 (동그라미 버튼)
                            Button(action: {
                                viewModel.sendMessage()
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
        .navigationBarHidden(true) //네비 바를 숨깁니다
        .navigationBarTitleDisplayMode(.inline) //title을 가운데로 정렬하기 위한 코드입니다.
        .ignoresSafeArea() //레이아웃을 조정하기 위해 SafeArea를 무시함!
    }
}


#Preview {
    ChatViewController()
}
