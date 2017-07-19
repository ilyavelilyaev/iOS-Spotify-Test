//
//  LoginViewController.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(sessionUpdated),
                                               name: SpotifyManager.sessionUpdatedNotification,
                                               object: nil)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        SpotifyManager.shared.login(from: self)
    }

    func sessionUpdated() {
        presentedViewController?.dismiss(animated: true, completion: nil)
        guard SpotifyManager.shared.sessionIsValid() else {
            print("Invalid session")
            return
        }

        performSegue(withIdentifier: "toMainController", sender: self)
    }

}
