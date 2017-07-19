//
//  JSONTrackParser.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation

class JSONTrackParser {

    func getTracks(json: String) -> [Int] {
        guard let tracks = serialize(json: json) else { return [] }

        if let tracksDict = tracks as? [String: Any] {
            return getTracks(dict: tracksDict)
        }

        if let tracksArray = tracks as? [[String: Any]] {
            return getTracks(array: tracksArray)
        }

        return []
    }

    private func serialize(json: String) -> Any? {
        guard let data = json.data(using: .utf8) else { return nil }
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: [])
            return dict
        } catch {
            print("Error while parsing json: \(error.localizedDescription)")
            return nil
        }
    }

    private func getTracks(dict: [String: Any]) -> [Int] {

        var trackIDs = [Int]()

        for (key, value) in dict {
            if key == "track" {
                if let track = value as? [String: Any],
                    let id = getId(from: track) {
                    trackIDs.append(id)
                }
                continue
            }
            if let nestedDict = value as? [String: Any] {
                trackIDs.append(contentsOf: getTracks(dict: nestedDict))
                continue
            }
            if let nestedArray = value as? [[String: Any]] {
                trackIDs.append(contentsOf: getTracks(array: nestedArray))
            }
        }

        return trackIDs
    }

    private func getTracks(array: [[String: Any]]) -> [Int] {
        var trackIDs = [Int]()
        for dict in array {
            trackIDs.append(contentsOf: getTracks(dict: dict))
        }
        return trackIDs
    }

    private func getId(from track: [String: Any]) -> Int? {
        return track["id"] as? Int
    }

}
