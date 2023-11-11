//
//  HostingController.swift
//  K-lab-project
//
//  Created by 허준호 on 11/8/23.
//

//SwiftUI로 작성된 View를 여기에 인자로 넘겨줌으로서 "SwiftUI to UIKit"을 실현함
//(WeatherViewController(SwiftUI로 작성됨)를 StoryBoard에 implement하기 위한 작업)

import SwiftUI
import UIKit

class HostingController: UIHostingController<WeatherViewController>, WeatherViewDelegate {
    
    //UI 요소들에 대한 IBOutlet connections
    @IBOutlet var backButton: UIButton!
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var weatherButton: UIButton!
    //더 필요하면 추가할 수도 있겠죠
    
    //NewsButton을 클릭했을 때의 Action!
    @IBAction func newsButtonTapped(_ sender: UIButton) {
        //newsButton에 관한 action 추가
    }
    
    //WeatherButton을 클릭했을 때의 Action!
    @IBAction func weatherButtonTapped(_ sender: UIButton) {
        //WeatherButton에 관한 action 추가
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: WeatherViewController())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //추가적인 사항이 필요할 경우 여기에 추가 세팅을 위한 코드를 더 집어넣으면 될 듯 함
        
        rootView.delegate = self //Set the delegate of the WeatherViewController to self
    }
    
    //WeatherViewDelegate 메서드를 구현하여 뒤로 가는 버튼 탭을 처리합니다.
    func didTapBackButton() {
        // Add your code to navigate back to the MainViewController here
        if let mainViewController = presentingViewController as? MainViewController {
            mainViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}
