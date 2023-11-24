//
//  WeatherViewModel.swift
//  K-lab-project
//
//  Created by 허준호 on 11/21/23.
//


//User의 위치 정보를 바탕으로 Country Information을 얻기 위해 CoreLocation import!
import Foundation
import CoreLocation
import SwiftUI

//해당 WeatherViewModel은 날씨(Weather)와 관련된 data를 관리할 것입니다
//Swift의 URLSession을 사용하여 Json Response를 Parsing 가능
struct WeatherForecast: Codable {
    var list: [WeatherInfo]
    let city: City
}

struct WeatherInfo: Codable {
    let dt: Int
    var main: Main
    var weatherAt9AM: String? //나중에 추가할 값입니다. (오전 9시의 날씨 정보 description)
    var weatherAt9PM: String? //나중에 추가할 값입니다. (오후 9시의 날씨 정보 description)
    var formattedDate: String? //나중에 추가할 값입니다. (Date 값을 MM/dd의 형태로 변환하여 여기에다가 저장합니다)
    var formattedTime: String? //나중에 추가할 값입니다. (Time 값을 H의 형태로 변환하여 여기에다가 저장합니다)
    var minTemp: Int? //주간 날씨 list 생성에서 재사용하기 위해 선언할 것임 (Today 날씨에서는 사용하지 않음)
    var maxTemp: Int? //주간 날씨 list 생성에서 재사용하기 위해 사용할 것임 (Today 날씨에서는 사용하지 않음)
    var weather: [Weather]
}

struct Main: Codable {
    var temp: Double
    var humidity: Int
}

struct Weather: Codable {
    var main: String
    let icon: String
}

struct City: Codable {
    let country: String
}

//TimeStamp값에서 Date(날짜)값을 뽑아주는 함수(11/20, 11/21 이런 식으로 말이다)
func convertTimeStampToDate(timestamp: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd"
    
    return dateFormatter.string(from: date)
}

//TimeStamp값에서 시간 값을 뽑아주는 함수 (24시간제를 쓸 겁니다)
func convertTimeStampToHumanTime(timestamp: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"
    
    return dateFormatter.string(from: date)
}

//주간 날씨 list를 만들어내기 위한 filtering 함수
func processWeatherList(_ weatherList: [WeatherInfo]) -> [WeatherInfo] {
    var processedList: [WeatherInfo] = []
    
    //date 값을 이용해서 weatherList를 그룹화한다
    let groupedByDate = Dictionary(grouping: weatherList, by: { convertTimeStampToDate(timestamp: TimeInterval($0.dt)) })
    
    for(_, dailyWeatherList) in groupedByDate {
        
        print(dailyWeatherList.count)
        
        //그 날의 최고 기온, 최저 기온을 찾아낸다
        var maxTemp = Double.leastNormalMagnitude //가능한 가장 작은 value로 initialize
        var minTemp = Double.greatestFiniteMagnitude //가능한 가장 큰 value로 initialize
        
        for weatherInfo in dailyWeatherList {
            let temperature = weatherInfo.main.temp
            
            //더 높은 기온을 찾는다면 maxTemp update!
            if temperature > maxTemp {
                maxTemp = temperature
            }
            
            //더 낮은 기온을 찾는다면 minTemp update!
            if temperature < minTemp {
                minTemp = temperature
            }
        }
        
        //오전 9시와 오후 9시의 weather description(날씨 설명) 값을 찾는다
        let weatherAt9AM = dailyWeatherList.first(where: {convertTimeStampToHumanTime(timestamp: TimeInterval($0.dt)) == "09"})?.weather.first?.main ?? "Nothing"
        let weatherAt9PM = dailyWeatherList.first(where: {convertTimeStampToHumanTime(timestamp: TimeInterval($0.dt)) == "21"})?.weather.first?.main ?? "Nothing"
        
        //하루의 평균 습도를 계산한다
        let averageHumidity = dailyWeatherList.reduce(0, { $0 + $1.main.humidity}) / dailyWeatherList.count
        
        //Weather 객체 새로 하나 만들어서 processedWeatherInfo에다가 넣어줄 것이다
        let processedWeather = Weather(main: "\(weatherAt9AM)+\(weatherAt9PM)", icon: "")
        print(processedWeather.main)
        
        //위에 가공된 정보들을 바탕으로 새로운 WeatherInfo Object를 만든다
        var processedWeatherInfo = WeatherInfo(dt: dailyWeatherList.first?.dt ?? 0, main: Main(temp: 0, humidity: 0), weatherAt9AM: weatherAt9AM, weatherAt9PM: weatherAt9PM, formattedDate: "", formattedTime: "", minTemp: Int(minTemp), maxTemp: Int(maxTemp), weather: [processedWeather])
        processedWeatherInfo.formattedDate = convertTimeStampToDate(timestamp: TimeInterval(Int(dailyWeatherList.first!.dt)))
        processedWeatherInfo.formattedTime = convertTimeStampToHumanTime(timestamp: TimeInterval(dailyWeatherList.first?.dt ?? 0))
        processedWeatherInfo.main.temp = maxTemp // You can choose to store minTemp, weatherAt9AM, weatherAt9PM, and averageHumidity similarly
        processedWeatherInfo.main.humidity = averageHumidity
        
        //processedList에다가 가공된 데이터들을 갖다 붙인다
        processedList.append(processedWeatherInfo)
    }
    //dt값(UTC timestamp 값)을 이용해서 오름차순으로 processedList를 정렬한다
    processedList.sort {$0.dt < $1.dt}
    
    //processedList를 돌려준다
    return processedList
}

//WeatherViewModel class를 만들어 놓고, fetchWeatherInfo() 메소드를 이 class 내에 구현
class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentweatherForecast: WeatherForecast?
    @Published var afterFourDaysWeatherForecast: WeatherForecast?
    @Published var country: String?
    
    //사용자의 위치 정보 처리를 위해 LocationManager 객체를 생성합니다
    private var locationManager = CLLocationManager()
    
    //사용자에게 위치 정보 처리를 물어봐야 하니까.. request를 위한 함수 추가
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    //사용자의 위치 정보에 기반하여 나라 정보를 받아오기 위한 함수 implement
    func getCountryFromLocation(completion: @escaping (String?) -> Void) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        if let location = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard let country = placemarks?.first?.country else {
                    completion(nil)
                    return
                }
                completion(country)
            }
        } else {
            completion(nil)
        }
    }
    
    //상단 박스의 정보(Today Weather)를 받아오는 함수
    func fetchWeatherInfo_current(latitude: Double, longitude: Double, apiKey: String) {
        //8개의 날씨 정보(3시간 간격)를 list로 받아온다(cnt=8)
        //units=metric을 통해, 날씨 정보를 섭씨 단위로 받아온다
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&exclude=minutely&cnt=8&appid=\(apiKey)&units=metric") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherForecast = try decoder.decode(WeatherForecast.self, from: data)
                DispatchQueue.main.async {
                    self.currentweatherForecast = weatherForecast
                }
            } catch {
                print("JSON decoding 중 오류 발생: \(error)")
            }
        }.resume()
    }
    
    //하단 박스의 정보(After4Days Weather)를 받아오는 함수
    func fetchWeatherInfo_afterFourDays(latitude: Double, longitude: Double, apiKey: String) {
        //40개의 날씨 정보(3시간 간격)를 list로 받아온다(cnt=40)
        //units=metric을 통해, 날씨 정보를 섭씨 단위로 받아온다
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&exclude=minutely&cnt=40&appid=\(apiKey)&units=metric") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                var weatherForecast = try decoder.decode(WeatherForecast.self, from: data)
                var firstTimeStamp: Int = 0
                var firstDate: String = ""
                
                //list의 첫번째 요소에서 날짜 정보를 구해서 firstDate에 저장한다.
                firstTimeStamp = weatherForecast.list[0].dt
                firstDate = convertTimeStampToDate(timestamp: TimeInterval(firstTimeStamp))
                print(firstDate)
                
                //filter 함수를 이용해서, 처음 날짜와 다른 것들만 list에 넣어준다 (32개만 넣어준다)
                // Ensure that result.count < 32 is checked before starting the reduction
                let afterFourDaysWeatherList = weatherForecast.list.filter { item in
                    return convertTimeStampToDate(timestamp: TimeInterval(item.dt)) != firstDate
                }.prefix(32)
                
                //내가 원하는 정보들로 가공해서 새로운 processedWeatherList를 새로 생성
                let processedWeatherList = processWeatherList(Array(afterFourDaysWeatherList))
                
                //weatherForecast 정보를 processedWeatherList로 업데이트
                weatherForecast.list = processedWeatherList
                
                //가공된 것으로 넘겨준다
                DispatchQueue.main.async {
                    self.afterFourDaysWeatherForecast = weatherForecast
                }
            } catch {
                print("JSON decoding 중 오류 발생: \(error)")
            }
        }.resume()
    }
}

