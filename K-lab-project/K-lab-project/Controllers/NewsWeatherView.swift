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

//날짜 Format과 관련된 date
func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd HH:mm"
    return dateFormatter.string(from: date)
}

//TimeStamp값에서 시간 값을 뽑아주는 함수 (24시간제를 쓸 겁니다)
func convertTimeStampToTime(timestamp: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"
    
    return dateFormatter.string(from: date)
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
    //날씨 관련 업무를 처리하기 위한 모델 객체 weatherViewModel를 하나 생성할거야
    @ObservedObject var weatherViewManageModel = WeatherViewModel()
    
    //버튼을 눌렀을 때 액션들을 수행하기 위한 State 값들입니다.
    @State private var shadowOption: CGFloat = 2
    @State private var noneShadowOption: CGFloat = 0
    
    //날씨 정보 표시를 위한 변수들입니다 (모두 임시 값을 집어넣어 놓은 상태)
    @State var location_name: String = "South Korea"
    @State var time: Int = 12
    @State var humidity: Int = 60
    @State var imageName: String = "rainWithThunder"
    
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
                            
                            //나라 이름 출력
                            Text(location_name)
                                    .bold()
                            Spacer()
                            
                            // Output country name
//                            if let country = weatherViewManageModel.weatherForecast?.city.country {
//                                Text(country)
//                                    .bold()
//                                Spacer()
//                            }
                            
                        }
                        Text("After 24 hours")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        //날씨 정보들을 해당 ScrollView에 집어넣을 것입니다. (가로 방향으로 Scroll할 것이며, 스크롤바를 숨깁니다)
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            HStack(spacing: 0){
                                if let weatherForecast = weatherViewManageModel.currentweatherForecast {
                                    ForEach(weatherForecast.list, id: \.dt) { weather in
                                        //각 날씨 정보를 표시하는 Segment입니다.
                                        VStack(spacing: 2)
                                        {
                                            Text(convertTimeStampToTime(timestamp:TimeInterval(weather.dt))+":00") //시간 정보입니다 (24시간제 적용)
                                                .padding(.vertical, 5)
                                            
                                            //청명할 때(이때는 2가지로 나뉨)를 제외하고는 그에 맞는 아이콘 이름 쓰면 될 듯
                                            if weather.weather.first!.main == "Clear"
                                            {
                                                Image("Clear_light")
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.yellow)
                                            } else {
                                                Image(weather.weather.first!.main) //날씨 정보 아이콘입니다
                                                    .foregroundColor(.yellow)
                                            }
                                            
                                            //습도 정보를 넣기 위한 곳입니다.
                                            HStack(spacing: 4)
                                            {
                                                Image("humidity")
                                                Text("\(weather.main.humidity)%")
                                            }
                                            .padding(.vertical, 5)
                                            
                                            Text("\(Int(weather.main.temp.rounded()))℃") //기온 정보입니다 (Double형에서 Int형으로 type casting!)
                                                .padding(.top, 5)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 15)
                                    }
                                }
                            }
                        }
                        //내가 선택한 나라를 기준으로 표시 된다는 메시지 표시
                        Text("Displays weather information based on the country selected by the user.")
                            .font(.system(size: 10, weight: .ultraLight))
                            .padding(.leading)
                    }
                    .onAppear { //현재 위도, 경도 기준은 한국 기준
                        weatherViewManageModel.fetchWeatherInfo_current(latitude: 37,  longitude: 127, apiKey: "1bab82c0dcc474332fcbc0b87089af2c")
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .frame(height: 240)
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
                            Text("After 4 Days")
                                .font(Font.custom("Inter", size: 16))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                            Spacer()
                        }
                        //주간 날씨를 나타냅니다
                        HStack(spacing: 0){
                            //4일치 날씨 정보를 받아오는 데에 성공했다면
                            if let weatherForecast_aboutFourDays = weatherViewManageModel.afterFourDaysWeatherForecast {
                                ForEach(0..<4, id: \.self) { index in
                                    //각 날씨 정보를 표시하는 Segment입니다.
                                    VStack(spacing: 2)
                                    {
                                        Text(weatherForecast_aboutFourDays.list[index].formattedDate ?? "No Date Info") //날짜 정보입니다
                                            .font(Font.custom("Inter", size: 15))
                                            .foregroundColor(.black);
                                        
                                        GeometryReader { geometry in
                                            //날씨 정보를 2개 연속으로 보여줘야 하니.. ZStack 사용
                                            ZStack {
                                                //대각선을 먼저 그립니다
                                                DiagonalLine()
                                                    .stroke(Color.black, lineWidth: 2)
                                                    .frame(width: geometry.size.width, height: 60)
                                                
                                                //날씨 표시하는 아이콘 2가지 (Clear인 경우에는 낮과 밤을 나눠야 하므로 예외처리 진행)
                                                VStack(spacing: 20) {
                                                    if weatherForecast_aboutFourDays.list[index].weatherAt9AM == "Clear" {
                                                        Image("Clear_light")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.black)
                                                            .padding(.leading, 20)
                                                    } else {
                                                        Image(weatherForecast_aboutFourDays.list[index].weatherAt9AM ?? "failed")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.black)
                                                            .padding(.trailing, 20)
                                                    }
                                                    
                                                    if weatherForecast_aboutFourDays.list[index].weatherAt9PM == "Clear" {
                                                        Image("Clear_night")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.black)
                                                            .padding(.leading, 20)
                                                    } else {
                                                        Image(weatherForecast_aboutFourDays.list[index].weatherAt9PM ?? "failed")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.black)
                                                            .padding(.leading, 20)
                                                    }
                                                }
                                            }
                                            .frame(width: geometry.size.width, height: 60)
                                            .padding(.top, 10)
                                        }
                                        
                                        //습도 정보를 넣기 위한 곳입니다.
                                        HStack(spacing: 4)
                                        {
                                            Image("humidity")
                                            Text("\(weatherForecast_aboutFourDays.list[index].main.humidity)%")
                                                .font(Font.custom("Inter", size: 14))
                                                .foregroundColor(.black);
                                        }
                                        .padding(.vertical, 5)
                                        
                                        Text("\(weatherForecast_aboutFourDays.list[index].maxTemp ?? 100)℃") //최고 기온 정보입니다 (받아온 정보가 없다면 100으로 일단 setting)
                                            .padding(.top, 5)
                                        
                                        Rectangle() //온도 바 표시
                                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                            .frame(width: 7, height: 50)
                                        
                                        Text("\(weatherForecast_aboutFourDays.list[index].minTemp ?? -100)℃") //최저 기온 정보입니다(받아온 정보가 없다면 -100으로 일단 setting)
                                            .padding(.top, 5)
                                        
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 15)
                                }
                            }
                            
                        }
                        .onAppear { //현재 위도, 경도 기준은 한국 기준
                            weatherViewManageModel.fetchWeatherInfo_afterFourDays(latitude: 37,  longitude: 127, apiKey: "1bab82c0dcc474332fcbc0b87089af2c")
                        }
                        .padding(.vertical, 5)
                    }
                    
                )
                .padding(.top, 20)
        }
    }
}

//NewsView도 그냥 struct로 따로 뺄게
struct NewsView: View {
    
    //News 정보를 불러오고 관리하는 newsViewModel 생성
    @StateObject private var newsViewModel = NewsViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(newsViewModel.newsItems) { newsItem in
                NewsCell(newsItem: newsItem)
                    .onTapGesture {
                        // Perform actions when a news cell is tapped
                        print("News item tapped with ID: \(newsItem.id)")
                        // Additional actions can be performed based on the news item
                    }
                }
            }
            .onAppear {
                //View가 보일 때 News 정보 가져온다!
                newsViewModel.fetchNews()
        }
    }
}

//NewsCell 역할을 하는 코드가 길어져서 따로 뺐습니다!
struct NewsCell: View {
    let newsItem: NewsItem

    var body: some View {
        HStack(spacing: 8) {
            // Assuming the titleImage is a URL, you can use a suitable image loading library
            Image(systemName: "newspaper")
                .resizable()
                .cornerRadius(8)
                .frame(width: 112, height: 112)

            VStack(spacing: 8) {
                Text(newsItem.title)
                    .font(Font.system(size: 16).bold())
                    .multilineTextAlignment(.leading)

                Text(newsItem.newsSummary)
                    .font(Font.system(size: 10))
            }
        }
        .frame(width: 360, height: 116)
    }
}

//총체적인 NewsWeatherView
struct NewsWeatherView: View {
    
    //버튼을 눌렀을 때 액션들을 수행하기 위한 State 값들입니다.
    @State private var selectedSegment = "News"
    
    var body: some View {
        VStack{
            //UIKit에서의 Segmented Control과 동일한(혹은 유사한) 기능을 함
            CustomSegmentedPicker_forNewsWeatherView(items: ["News", "Weather"], selection: $selectedSegment)
                .padding()
            
            //NewsView에 관한 곳이야!
            if selectedSegment == "News" {
                NewsView()
            //WeatherView에 관한 곳이야!
            } else {
                WeatherView()
            }
            Spacer()
        }
    }
}

//Preview를 위한 Code
#Preview {
    NewsWeatherView()
}
