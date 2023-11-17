//
//  ChatUIController.swift
//  K-lab-project
//
//  Created by 허준호 on 11/10/23.
//

import UIKit
import SwiftUI

class ChatUIController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //여기에다가 난 HostingController_forChatView를 embed하고 싶어요
        let swiftUIViewCotnroller = HostingController_forChatView(rootView: ChatViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [swiftUIViewCotnroller]
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}
