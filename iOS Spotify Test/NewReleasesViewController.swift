//
//  NewReleasesViewController.swift
//  iOS Spotify Test
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class NewReleasesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!


    fileprivate let fetcher = SpotifyNewReleasesFetcher()
    fileprivate var selectedOrder: NewReleasesOrder = .newest {
        didSet {
            guard selectedOrder != oldValue else { return }
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetcher.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetcher.loadTracks()
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedOrder = .newest
        case 1: selectedOrder = .albumName
        case 2: selectedOrder = .artistName
        default: break
        }
    }

}

extension NewReleasesViewController: SpotifyNewReleasesFetcherDelegate {

    func fetcherDownloadedNewItems(fetcher: SpotifyNewReleasesFetcher) {
        tableView.reloadData()
    }

    func fetcherFailedGettingItems(fetcher: SpotifyNewReleasesFetcher, error: SpotifyNewReleasesFetcherError) {
        //TODO: handle errors
    }

}

extension NewReleasesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetcher.getTracksCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell",
                                                 for: indexPath) as! TrackTableViewCell

        guard let track = fetcher.getTrack(idx: indexPath.row, ordering: selectedOrder) else {
            cell.albumLabel.text = nil
            cell.artistLabel.text = nil
            cell.trackLabel.text = "Error getting data."
            return cell
        }

        cell.albumLabel.text = "Album: " + track.album.name
        cell.artistLabel.text = "Artist: " + track.album.artists
        cell.trackLabel.text = track.name

        return cell
    }

}
