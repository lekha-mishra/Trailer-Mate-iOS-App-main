//
//  ViewController.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: AppConstants.house)
        vc2.tabBarItem.image = UIImage(systemName: AppConstants.playCircle)
        vc3.tabBarItem.image = UIImage(systemName: AppConstants.magnifyingglass)
        vc4.tabBarItem.image = UIImage(systemName: AppConstants.arrowDowntoLine)
        
        vc1.title = AppConstants.home
        vc2.title = AppConstants.ComingSoon
        vc3.title = AppConstants.TopSearch
        vc4.title = AppConstants.download
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}

