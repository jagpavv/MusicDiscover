//
//  MusicInfo.swift
//  MusicDiscover
//
//  Created by Eunjin on 8/11/20.
//  Copyright © 2020 EunjinKim. All rights reserved.
//

import Foundation

struct MusicInfo: Codable {
  let name: String
  let listenerCount: Int
  let genres: [String]
  let currentTrack: CurrentTrack
}
