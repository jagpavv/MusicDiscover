//
//  MusicService.swift
//  MusicDiscover
//
//  Created by Eunjin on 8/11/20.
//  Copyright © 2020 EunjinKim. All rights reserved.
//

import Foundation
import RxSwift

protocol MusicServiceProtocol {
  var isLoading: BehaviorSubject<Bool> { get }
  func fetchMusics(with keyword: String?) -> Single<MusicResult>
}

class MusicService: MusicServiceProtocol {
  let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)

  enum Target {
    case musicList
    case search

    var path: String {
      switch self {
      case .musicList:
        return "/v2/5df79a3a320000f0612e0115"
      case .search:
        return "/v2/5df79b1f320000f4612e011e"
      }
    }
  }

  private var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  private var task: URLSessionDataTask?

  func fetchMusics(with keyword: String?) -> Single<MusicResult> {
    return Single.create { single in
      let disposable = Disposables.create()
      let baseURL = "http://www.mocky.io"
      let path = (keyword ?? "").isEmpty ? MusicService.Target.musicList.path : MusicService.Target.search.path
      guard let url = URL(string: baseURL + path) else {
        single(.error(NSError()))
        return disposable
      }
      self.isLoading.onNext(true)
      URLSession.shared.dataTask(with: url) { data, response, error in
        self.isLoading.onNext(false)
        if let error = error {
          single(.error(error))
        }

        guard let data = data else { return }
        do {
          let decoded = try self.jsonDecoder.decode(MusicResult.self, from: data)
          single(.success(decoded))
        } catch {
          single(.error(error))
        }
      }.resume()
      return disposable
    }
  }
}
