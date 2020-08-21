//
//  MusicListViewController.swift
//  MusicDiscover
//
//  Created by Eunjin on 8/11/20.
//  Copyright © 2020 EunjinKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: implement bottom activity indicator
class MusicListViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  private let searchController = UISearchController(searchResultsController: nil)
  private var activityIndicatorForSearchBar: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.backgroundColor = .systemGroupedBackground
    return activityIndicator
  }()

  var viewModel: MusicListViewModelProtocol?
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setCollectionView()
    setSearchController()
    setNavigationBar()
    bind()
    setCollectionViewFlowLayout()

  }

  func bind() {
    guard let viewModel = viewModel else { return }

    viewModel.musics
      .bind(to: collectionView.rx.items(cellIdentifier: MusicListCollectionCell.identifier, cellType: MusicListCollectionCell.self)) { (row, musicInfo, cell) in
        cell.setData(with: musicInfo)
      }
      .disposed(by: disposeBag)

    viewModel.isLoading
      .bind(to: activityIndicatorView.rx.isAnimating)
      .disposed(by: disposeBag)

    viewModel.isLoading
      .bind(to: activityIndicatorForSearchBar.rx.isAnimating)
      .disposed(by: disposeBag)

    // Pagination
    collectionView.rx.prefetchItems
      .map { indexpaths in indexpaths.map { $0.item }}
      .withLatestFrom(viewModel.musics.map { $0.count - 1 }) { (items: $0, lastIndex: $1) }
      .filter { event in
        return event.items.contains(where: { $0 >= event.lastIndex })
      }
      .map { _ in }
      .bind(to: viewModel.requestNextPage)
      .disposed(by: disposeBag)

    searchController.searchBar.rx.text.orEmpty
      .debounce(.seconds(1), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .map( { $0.lowercased()})
      .bind(to: viewModel.searchKeyword)
      .disposed(by: disposeBag)

    viewModel.musics
      .filter { $0.isEmpty }
      .map { _ in }
      .bind(to: viewModel.requestNextPage)
      .dispose()
  }

  private func setCollectionViewFlowLayout() {
    let itemsInARow = 2
    let itemSpacing: CGFloat = 16
    let itemSize = (UIScreen.main.bounds.width - (itemSpacing * CGFloat(itemsInARow + 1))) / CGFloat(itemsInARow)
    let itemCGSize = CGSize(width: itemSize, height: itemSize)

    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
    flowLayout.minimumInteritemSpacing = itemSpacing
    flowLayout.minimumLineSpacing = itemSpacing
    flowLayout.itemSize = itemCGSize
    collectionView.collectionViewLayout = flowLayout
  }

  private func setCollectionView() {
    collectionView.alwaysBounceVertical = true
  }

  private func setSearchController() {
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search"
    navigationItem.searchController = searchController

    searchController.searchBar.searchTextField.leftView?.addSubview(self.activityIndicatorForSearchBar)
  }

  private func setNavigationBar() {
    title = "Discover"
    navigationController?.navigationBar.prefersLargeTitles = true
    definesPresentationContext = true
  }
}
