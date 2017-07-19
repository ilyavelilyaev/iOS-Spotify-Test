//
//  Track.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation

struct Track {

    let id: String
    let name: String

    var album: Album!

    init(id: String, name: String) {
        self.id = id
        self.name = name
        album = nil
    }

    init(id: String, name: String, album: Album) {
        self.id = id
        self.name = name
        self.album = album
    }

}
