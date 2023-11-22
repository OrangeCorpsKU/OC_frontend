//
//  WeatherView.swift
//  K-lab-project
//
//  Created by 허준호 on 11/13/23.
//

import SwiftUI
import UIKit

    //대각선을 그리기 위한 함수입니다
    struct DiagonalLine: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            return path
        }
    }
    
    struct WeatherView: View {
        
        //버튼을 눌렀을 때 액션들을 수행하기 위한 State 값들입니다.
        @State private var firstButtonColor: Color = Color.yellow
        @State private var secondButtonColor: Color = Color.gray
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
                HStack(spacing: 0) {
                    Button(action: {
                        // Add action here
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 28) //가운데로 맞춘 것처럼 보기 위해 padding 값 임의 조절했습니다
                    
                    //News, Weather 간 전환할 수 있는 버튼입니다
                    HStack(spacing: 4) {
                        Spacer()
                        Button("News") {
                            withAnimation {
                                if firstButtonColor == Color.gray {
                                    firstButtonColor = Color.yellow
                                    secondButtonColor = Color.gray
                                }
                            }
                        }
                        .frame(width: 120, height: 52)
                        .foregroundColor(.black)
                        .background(firstButtonColor)
                        .cornerRadius(10)
                        
                        Button("Weather") {
                            withAnimation {
                                if secondButtonColor == Color.gray {
                                    firstButtonColor = Color.gray
                                    secondButtonColor = Color.yellow
                                }
                            }
                        }
                        .frame(width: 120, height: 52)
                        .foregroundColor(.black)
                        .background(secondButtonColor)
                        .cornerRadius(10)
                        Spacer()
                    }
                    .frame(width: 260, height: 64)
                    .background(Color.gray)
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                
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

//Preview를 위한 Code
#Preview {
    WeatherView()
}

