//
//  iOS_Spotify_TestTests.swift
//  iOS Spotify TestTests
//
//  Created by Ilya Velilyaev on 19.07.17.
//  Copyright © 2017 1. All rights reserved.
//

import XCTest
@testable import iOS_Spotify_Test

class iOS_Spotify_TestTests: XCTestCase {

    var bundle: Bundle!
    let parser = JSONTrackParser()
    
    override func setUp() {
        super.setUp()
        bundle = Bundle(for: type(of: self))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONParsing1() {
        let tracktest1path = bundle.url(forResource: "tracktest1", withExtension: "json")!
        let data = try! Data(contentsOf: tracktest1path)
        let json = String(data: data, encoding: .utf8)!

        let ids = parser.getTracks(json: json)

        XCTAssert(ids == [1])
    }

    func testJSONParsing2() {
        let tracktest1path = bundle.url(forResource: "tracktest2", withExtension: "json")!
        let data = try! Data(contentsOf: tracktest1path)
        let json = String(data: data, encoding: .utf8)!

        var ids = parser.getTracks(json: json)
        print(ids)

        for i in (1...5) {
            let idx = ids.index(of: i)
            XCTAssert(idx != nil)
            ids.remove(at: idx!)
        }
        XCTAssert(ids.count == 0)
    }

    func testFetchingNewReleases() {
        let fetcher = SpotifyAlbumFetcher()
        let token = "BQD9qDZVZ81CCmsJDkZwabcLDHemnzYV1xOqBKJ9AdtmZzKNCNDfs-8gE1uQxZZgAHYBYHc8iKw6MaPdiohHV72M_3YByqmGzHiDMHr88Dm8fl1WmfJQOOFrlxKltMkVeFlUDOo04ekByg"
        let expectation = self.expectation(description: "Albums fetching")
        fetcher.fetchAlbums(token: token, offset: 0, limit: 20) { (result) in
            switch result {
            case .albums(let albums):
                print(albums)
                expectation.fulfill()
            case .error(let error):
                print(error)
                XCTFail()
            }
        }
        self.wait(for: [expectation], timeout: 10.0)
    }

    func testFetchingTracks() {
        let fetcher = SpotifyTracksFetcher()
        let token = "BQD9qDZVZ81CCmsJDkZwabcLDHemnzYV1xOqBKJ9AdtmZzKNCNDfs-8gE1uQxZZgAHYBYHc8iKw6MaPdiohHV72M_3YByqmGzHiDMHr88Dm8fl1WmfJQOOFrlxKltMkVeFlUDOo04ekByg"
        let album = Album(id: "2Ivz1Ch7qB9yR3uLr8T1pj", name: "Spotify Singles", artists: "Lauv")
        let expectation = self.expectation(description: "Tracks fetching")
        fetcher.fetchTracks(token: token, album: album){ (result) in
            switch result {
            case .tracks(let tracks):
                print(tracks)
                expectation.fulfill()
            case .error(let error):
                print(error)
                XCTFail()
            }
        }
        self.wait(for: [expectation], timeout: 10.0)
    }

}
