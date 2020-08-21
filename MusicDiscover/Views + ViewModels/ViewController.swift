//
//  ViewController.swift
//  MusicDiscover
//
//  Created by Eunjin on 8/11/20.
//  Copyright © 2020 EunjinKim. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController {

  let viewModel: MusicListViewModelProtocol = MusicListViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.getMusics()
  }
}
