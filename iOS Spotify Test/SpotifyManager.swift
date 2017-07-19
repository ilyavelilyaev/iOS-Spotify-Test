//
//  SpotifyManager.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation

class SpotifyManager {

    private let clientID = "93c0b4c38b4a491bb7347e022b045587"
    private let clientSecret = "76be9278c1f54847b223d7d93592cae2"

    static let sessionUpdatedNotification = Notification.Name("SpotifySessionUpdated")

    static let shared = SpotifyManager()

    /// Should be called on launch
    func setup() {
        let auth = SPTAuth.defaultInstance()!
        auth.clientID = clientID
        auth.requestedScopes = []
        auth.redirectURL = URL(string: "iosspotifytesttask://")!
        auth.sessionUserDefaultsKey = "SpotifySession"
    }


    /// Check if opening url is spotify
    func canHandle(url: URL) -> Bool {
        return SPTAuth.defaultInstance().canHandle(url)
    }

    func handle(url: URL) {
        let auth = SPTAuth.defaultInstance()!
        auth.handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
            if let error = error {
                print("Failed to auth. Error: \(error.localizedDescription)")
                return
            }
            auth.session = session
            NotificationCenter.default.post(name: SpotifyManager.sessionUpdatedNotification,
                                            object: nil)
        }
    }
    

}
