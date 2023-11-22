//
//  ContainerViewController_NewsWeather.swift
//  K-lab-project
//
//  Created by 허준호 on 11/13/23.
//

import UIKit
import SwiftUI

//WeatherUIController, HostingController_forWeatherView 관련해서는 코드가 그리 길지 않아 여기에 그냥 추가합니다.
class WeatherUIController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //추가 동작이 필요하면 여기에 추가할 수도 있겠죠?
    }
}

//Generics Type에 SwiftUI 뷰를 넣어주기만 하면 완성
final class HostingController_forWeatherView: UIHostingController<WeatherView>
{
    
}

//해당 class는 UISegmentedControl을 포함하며, 다른 2가지 view controller(News, Weather)들의 container 역할을 하게 될 것임
class ContainerViewController_NewsWeather: UIViewController {
//    var newsViewController: NewsViewController!
    var weatherViewController: WeatherUIController!
    
    //-IBOutlets에 관한 것들
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    //LifeCycle 관련한 내용
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    //Private 메소드
    private func setupViewControllers() {
        //Storyboard에서 UIKit view controller들을 instantiate한다
        //Storyboard의 이름은 "Main"이어야 합니다
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        newsViewController = storyboard.instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController
        weatherViewController = storyboard.instantiateViewController(withIdentifier: "WeatherUIController") as? WeatherUIController
        
        //newsViewController를 child view controller로 추가한다
//        addChild(newsViewController)
//        newsViewController.view.frame = containerView.bounds
//        containerView.addSubview(newsViewController.view)
//        newsViewController.didMove(toParent: self)
        
        //weatherViewController(SwiftUI 기반)를 child view controller로 추가한다
        addChild(weatherViewController)
        weatherViewController.view.frame = containerView.bounds
        containerView.addSubview(weatherViewController.view)
        weatherViewController.didMove(toParent: self)
    }
    
    //-IBActions 관련 내용
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        //선택된 segment index에 기반하여 view controller 간의 toggle을 시도
        switch sender.selectedSegmentIndex {
        case 0:
//            newsViewController.view.isHidden = false
            weatherViewController.view.isHidden = true
        case 1:
//            newsViewController.view.isHidden = true
            weatherViewController.view.isHidden = false
        default:
            break
        }
    }
}

