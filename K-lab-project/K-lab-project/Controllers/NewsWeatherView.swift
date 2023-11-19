//
//  NewsWeatherView.swift
//  K-lab-project
//
//  Created by 허준호 on 11/19/23.
//

import SwiftUI

//대각선을 그리기 위한 함수입니다
struct DiagonalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
}

//Custom된 News, Weather View간 전환하게 만들어 주는 Segmented Control
struct CustomSegmentedPicker_forNewsWeatherView: View {
    var items: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 10) {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    self.selection = item
                })
                {
                    Text(item)
                        .frame(width: 130, height: 50)
                        .background(self.selection == item ? Color.yellow : Color.gray)
                        .foregroundColor(self.selection == item ? Color.black : Color.black)
                        .cornerRadius(5)
                        .shadow(color: self.selection == item ? Color.black.opacity(0.5) : Color.clear, radius: 5, x: 0, y: 0)
                }
            }
        }
        .padding(5)
        .background(Color.gray)
        .cornerRadius(5)
    }
}

//WeatherView 코드가 너무 길어서 struct로 따로 뺐어
struct WeatherView: View {
    //버튼을 눌렀을 때 액션들을 수행하기 위한 State 값들입니다.
    @State private var shadowOption: CGFloat = 2
    @State private var noneShadowOption: CGFloat = 0
    
    //날씨 정보 표시를 위한 변수들입니다 (모두 임시 값을 집어넣어 놓은 상태)
    @State var location_name: String = "Netherlands"
    @State var time: Int = 12
    @State var humidity: Int = 60
    @State var temperature: Int = 20
    @State var imageName: String = "rainWithThunder"
    
    @State var imageName_usingInWeekWeather1: String = "clearMorning"
    @State var imageName_usingInWeekWeather2: String = "clearNight"
    @State var HighestTemperature_usingInWeekWeather: Int = 25
    @State var LowestTemperature_usingInWeekWeather: Int = 15
    
    var body: some View {
        VStack{
            //상단 박스입니다
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 390, height: 242)
                .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.2))
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay(
                    VStack(spacing: 2) {
                        Spacer()
                        HStack(spacing: 0) {
                            Spacer()
                            Image("carbon_location")
                                .frame(width: 32, height: 32)
                                .foregroundColor(.yellow)
                            Text(location_name)
                                .bold()
                            Spacer()
                        }
                        Text("Today")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        //날씨 정보들을 해당 ScrollView에 집어넣을 것입니다. (가로 방향으로 Scroll할 것이며, 스크롤바를 숨깁니다)
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            HStack(spacing: 0){
                                ForEach(0..<8, id: \.self) { index in
                                    //각 날씨 정보를 표시하는 Segment입니다.
                                    VStack(spacing: 2)
                                    {
                                        Text("\(time) AM") //시간 정보입니다
                                            .padding(.vertical, 5)
                                        Image(imageName) //날씨 정보 아이콘입니다
                                            .foregroundColor(.yellow)
                                        
                                        //습도 정보를 넣기 위한 곳입니다.
                                        HStack(spacing: 4)
                                        {
                                            Image("humidity")
                                            Text("\(humidity)%")
                                        }
                                        .padding(.vertical, 5)
                                        
                                        Text("\(temperature)℃") //기온 정보입니다
                                            .padding(.top, 5)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 15)
                                }
                            }
                        }
                    }
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                        .frame(height: 220)
                )
            
            
            //하단 박스입니다
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 390, height: 291)
                .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.2))
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay(
                    VStack{
                        //상단의 Week 글자입니다
                        HStack{
                            Text("Week")
                                .font(Font.custom("Inter", size: 16))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                            Spacer()
                        }
                        //주간 날씨를 나타냅니다
                        HStack(spacing: 0){
                            ForEach(0..<5, id: \.self) { index in
                                //각 날씨 정보를 표시하는 Segment입니다.
                                VStack(spacing: 2)
                                {
                                    Text("\(time) AM") //시간 정보입니다
                                        .font(Font.custom("Inter", size: 15))
                                        .foregroundColor(.black);
                                    
                                    GeometryReader { geometry in
                                        //날씨 정보를 2개 연속으로 보여줘야 하니.. ZStack 사용
                                        ZStack {
                                            //대각선을 먼저 그립니다
                                            DiagonalLine()
                                                .stroke(Color.black, lineWidth: 2)
                                                .frame(width: geometry.size.width, height: 60)
                                            
                                            //날씨 표시하는 아이콘 2가지
                                            VStack(spacing: 20) {
                                                Image(imageName_usingInWeekWeather1)
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.black)
                                                    .padding(.trailing, 20)
                                                
                                                Image(imageName_usingInWeekWeather2)
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.black)
                                                    .padding(.leading, 20)
                                            }
                                        }
                                        .frame(width: geometry.size.width, height: 60)
                                        .padding(.top, 10)
                                    }
                                    
                                    //습도 정보를 넣기 위한 곳입니다.
                                    HStack(spacing: 4)
                                    {
                                        Image("humidity")
                                        Text("\(humidity)%")
                                            .font(Font.custom("Inter", size: 14))
                                            .foregroundColor(.black);
                                    }
                                    .padding(.vertical, 5)
                                    
                                    Text("\(HighestTemperature_usingInWeekWeather)℃") //최고 기온 정보입니다
                                        .padding(.top, 5)
                                    
                                    Rectangle() //온도 바 표시
                                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                        .frame(width: 7, height: 50)
                                    
                                    Text("\(LowestTemperature_usingInWeekWeather)℃") //최저 기온 정보입니다
                                        .padding(.top, 5)
                                    
                                }
                                .padding(.horizontal, 10)
                                .padding(.bottom, 15)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                )
                .padding(.top, 20)
        }
    }
}

//총체적인 NewsWeatherView
struct NewsWeatherView: View {
    
    //버튼을 눌렀을 때 액션들을 수행하기 위한 State 값들입니다.
    @State private var selectedSegment = "News"
    @State private var NewsCellImageName = "newspaper"
    @State private var NewsCellTitle = "Default News Title"
    @State private var NewsCellSummary = "Default news summary. This phrase is coming up because I didn't get any information from outside. This is likely an error to the website waiting for a response or receiving it."
    
    var body: some View {
        VStack{
            //UIKit에서의 Segmented Control과 동일한(혹은 유사한) 기능을 함
            CustomSegmentedPicker_forNewsWeatherView(items: ["News", "Weather"], selection: $selectedSegment)
                .padding()
            
            //NewsView에 관한 곳이야!
            if selectedSegment == "News" {
                ScrollView {
                    //10개의 Cell을 우선 ScrollView 내부에 만들어 놓을거야. 각 Cell엔 id를 순차적으로 부여할거야 (id는 0~9)
                    ForEach(0..<10, id: \.self) { index in
                        //TableCell 한 개의 역할을 한다
                        HStack(spacing: 8) {
                            Image(systemName: NewsCellImageName)
                                .frame(width: 112, height: 112)
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                                .padding()
                            //오른쪽의 제목과 글씨 영역
                            VStack(spacing: 8) {
                                //제목
                                Text(NewsCellTitle)
                                    .font(Font.system(size: 16).bold())
                                    .multilineTextAlignment(.leading)
                                //내용
                                Text(NewsCellSummary)
                                    .font(Font.system(size: 10))
                            }
                        }
                        .frame(width: 360, height: 116)
                        .onTapGesture {
                            //탭했을 때 수행할 Action을 적을 것이야!
                            print("누른 Hstack의 ID는 \(index)야!")
                            //id를 이용해서 다른 Action들도 수행할 수 있음!
                        }
                    }
                }
            //WeatherView에 관한 곳이야!
            } else {
                WeatherView()
            }
            Spacer()
        }
        .navigationTitle("Segmented Control Example")
    }
}

//Preview를 위한 Code
#Preview {
    NewsWeatherView()
}
