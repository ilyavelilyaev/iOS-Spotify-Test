//
//  SpotifyManager.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import SafariServices

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

    /// Call if canHandle succeeded
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


    /// Logging in
    func login(from viewController: UIViewController) {
        let auth = SPTAuth.defaultInstance()!

        if SPTAuth.supportsApplicationAuthentication() {
            let url = auth.spotifyAppAuthenticationURL()!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }

        let url = auth.spotifyWebAuthenticationURL()!
        let safariViewController = SFSafariViewController(url: url)
        viewController.present(safariViewController, animated: true, completion: nil)
    }

    func sessionIsValid() -> Bool {
        let auth = SPTAuth.defaultInstance()!
        guard let session = auth.session else { return false }
        return session.isValid()
    }

    func getToken() -> String? {
        guard sessionIsValid() else { return nil }
        let auth = SPTAuth.defaultInstance()!
        return auth.session.accessToken
    }

}
