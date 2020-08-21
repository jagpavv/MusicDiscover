//
//  MusicListViewModel.swift
//  MusicDiscover
//
//  Created by Eunjin on 8/11/20.
//  Copyright © 2020 EunjinKim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MusicListViewModelProtocol {
  // Input(Action)
  var searchKeyword: PublishSubject<String> { get }
  var requestNextPage: PublishSubject<Void> { get }

  // Output(State)
  var musics: BehaviorSubject<[MusicInfo]> { get }
  var isLoading: BehaviorRelay<Bool> { get }
}

class MusicListViewModel: MusicListViewModelProtocol {

  var requestNextPage: PublishSubject<Void> = PublishSubject()
  var searchKeyword: PublishSubject<String> = PublishSubject()

  let musics: BehaviorSubject<[MusicInfo]> = BehaviorSubject(value: [])
  let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  private let page: BehaviorSubject<Int> = BehaviorSubject(value: 0)

  private let musicService: MusicServiceProtocol
  let disposeBag = DisposeBag()

  init(service: MusicServiceProtocol) {
    musicService = service
    bind()
  }

  func bind() {
    musicService.isLoading
      .bind(to: isLoading)
      .disposed(by: disposeBag)

    searchKeyword
      .map { _ in [] }
      .bind(to: musics)
      .disposed(by: disposeBag)

    // Reset current page when search keyword is changed
    searchKeyword
      .map { _ in 0 }
      .bind(to: page)
      .disposed(by: disposeBag)

    let request = Observable.combineLatest(requestNextPage, searchKeyword) { (request: $0, keyword: $1) }
      .withLatestFrom(page) { (keyword: $0.1, page: $1) }
      .filter { $0.keyword.isEmpty && $0.page < 5 }
      .share()

    request
      .flatMap { _ in
        self.musicService.fetchMusics(with: nil)
      }
      .map { $0.data.sessions }
      .withLatestFrom(musics) { (fetched: $0, exsting: $1) }
      .map { $0.exsting + $0.fetched }
      .bind(to: musics)
      .disposed(by: disposeBag)

    // Limit the maximum page to 5
    request
      .map { $0.page + 1}
      .bind(to: page)
      .disposed(by: disposeBag)

    searchKeyword
      .filter { !$0.isEmpty }
      .flatMap { keyword in
        self.musicService.fetchMusics(with: keyword)
      }
      .map { $0.data.sessions.shuffled() }
      .bind(to: musics)
      .disposed(by: disposeBag)
  }
}
