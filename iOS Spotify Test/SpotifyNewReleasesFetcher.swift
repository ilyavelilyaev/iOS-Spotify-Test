//
//  SpotifyNewReleasesFetcher.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation

enum NewReleasesOrder {

    case newest
    case artistName
    case albumName

}

enum SpotifyNewReleasesFetcherError {

    case unableToGetToken
    case fetchingError
    case other(String)

}

protocol SpotifyNewReleasesFetcherDelegate: class {

    func fetcherDownloadedNewItems(fetcher: SpotifyNewReleasesFetcher)
    func fetcherFailedGettingItems(fetcher: SpotifyNewReleasesFetcher,
                                   error: SpotifyNewReleasesFetcherError)

}

class SpotifyNewReleasesFetcher {

    weak var delegate: SpotifyNewReleasesFetcherDelegate?

    private var mainCache = [Track]()
    private var orderedCache = [Track]()

    private var currentOrder = NewReleasesOrder.newest

    private var lastFetchedAlbumIndex = 0
    private var fetching = false

    private let albumFetcher = SpotifyAlbumFetcher()
    private let tracksFetcher = SpotifyTracksFetcher()

    /// Call to load first tracks.
    func loadTracks() {
        guard mainCache.count == 0 else { return }
        fetchNew()
    }

    func getTracksCount() -> Int {
        return mainCache.count
    }

    /// idx Should always be less than count
    func getTrack(idx: Int, ordering: NewReleasesOrder) -> Track? {
        guard idx < mainCache.count else { return nil }
        if currentOrder != ordering {
            generateOrderedCache(order: ordering)
        }

        // if there is only 7 items left to show, start loading new
        if orderedCache.count - idx < 7 {
            fetchNew()
        }

        return orderedCache[idx]
    }

    private func generateOrderedCache(order: NewReleasesOrder) {
        let sortingClosure: (Track, Track) -> Bool
        switch order {
        case .newest:
            orderedCache = mainCache
            currentOrder = .newest
            return
        case .artistName:
            sortingClosure = { track1, track2 in
                return track1.album.artists < track2.album.artists
            }
        case .albumName:
            sortingClosure = { track1, track2 in
                return track1.album.name < track2.album.name
            }
        }
        orderedCache = mainCache.sorted(by: sortingClosure)
        currentOrder = order
    }

    private func fetchNew() {
        guard let token = SpotifyManager.shared.getToken() else {
            delegate?.fetcherFailedGettingItems(fetcher: self, error: .unableToGetToken)
            return
        }
        if fetching { return }
        fetching = true
        let limit = 20
        albumFetcher.fetchAlbums(token: token, offset: lastFetchedAlbumIndex, limit: limit) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .albums(let albums):
                strongSelf.lastFetchedAlbumIndex += limit
                strongSelf.fetchTracks(albums: albums)
                break
            case .error(let error):
                strongSelf.delegate?.fetcherFailedGettingItems(fetcher: strongSelf,
                                                               error: .other(error))
                strongSelf.fetching = false
            }
        }

    }

    private func fetchTracks(albums: [Album]) {
        guard let token = SpotifyManager.shared.getToken() else {
            delegate?.fetcherFailedGettingItems(fetcher: self, error: .unableToGetToken)
            fetching = false
            return
        }
        for album in albums {
            tracksFetcher.fetchTracks(token: token, album: album, completion: { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .tracks(let tracks):
                    strongSelf.mainCache.append(contentsOf: tracks)
                    strongSelf.generateOrderedCache(order: strongSelf.currentOrder)
                    strongSelf.delegate?.fetcherDownloadedNewItems(fetcher: strongSelf)
                case .error(let error):
                    strongSelf.delegate?.fetcherFailedGettingItems(fetcher: strongSelf, error: .other(error))
                }
                strongSelf.fetching = false
            })
        }
    }

}
