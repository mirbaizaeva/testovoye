//
//  TabBarController.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = Constants.Color.baseColor
                
            let viewController = ViewController()
            let favoritesViewController = FavoritesViewController()
                
            let navigationController = UINavigationController(rootViewController: viewController)
            let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
                
            navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"),selectedImage: UIImage(systemName: "house.fill"))
            favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"),selectedImage: UIImage(systemName: "heart.fill"))
                
            self.viewControllers = [navigationController, favoritesNavigationController]
        }
}
