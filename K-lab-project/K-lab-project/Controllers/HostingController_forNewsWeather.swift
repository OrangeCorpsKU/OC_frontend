//
//  HostingController_forNewsWeather.swift
//  K-lab-project
//
//  Created by 허준호 on 11/19/23.
//

import SwiftUI
import UIKit

//NewsWeatherView를 StoryBoard에다가 적용하기 위한 HostingController
class HostingController_forNewsWeather: UIHostingController<NewsWeatherView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: NewsWeatherView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
