//
//  AppDelegate.swift
//  MusicDiscover
//
//  Created by Eunjin on 8/11/20.
//  Copyright © 2020 EunjinKim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    self.window = UIWindow(frame: UIScreen.main.bounds)

    let musicService = MusicService()
    let musicListViewModel = MusicListViewModel(service: musicService)

    let storyboard = UIStoryboard(name: "MusicListViewController", bundle: nil)
    let musicListViewController = storyboard.instantiateViewController(withIdentifier: "MusicListViewController") as! MusicListViewController

    musicListViewController.viewModel = musicListViewModel

    let navigationController = UINavigationController()
    navigationController.viewControllers = [musicListViewController]
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    return true
  }
}
