//
//  CustomTabBarController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 17/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let controller1 = MyTrailersViewController()
        controller1.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)

        let controller2 = RequestsViewController()
        controller2.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)

        let controller3 = UIViewController()

        let controller4 = ReminderViewController()
        controller4.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 4)

        let controller5 = ProfileViewController()
        controller5.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 5)

        self.tabBar.tintColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        self.tabBar.unselectedItemTintColor = UIColor(named: "grey")

        viewControllers = [controller1, controller2, controller3, controller4, controller5]
        setupMiddleButton()
    }

    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "example"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }

    @objc private func menuButtonAction(sender: UIButton) {
    }
}
