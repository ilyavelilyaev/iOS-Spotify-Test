//
//  SpotifyTracksParser.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation

class SpotifyTracksParser {

    typealias SpotifyTracksFetcherResult = SpotifyTracksFetcher.SpotifyTracksFetcherResult

    func parse(data: Data) -> SpotifyTracksFetcherResult {
        guard let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return .error("Failed to serialize data.")
        }

        guard let items = dict["items"] as? [[String: Any]] else {
            return .error("Unknown response format.")
        }

        return .tracks(items.flatMap { parse(item: $0) })
    }

    private func parse(item: [String: Any]) -> Track? {
        guard let id = item["id"] as? String,
            let name = item["name"] as? String else {
                return nil
        }

        return Track(id: id, name: name)
    }

}
