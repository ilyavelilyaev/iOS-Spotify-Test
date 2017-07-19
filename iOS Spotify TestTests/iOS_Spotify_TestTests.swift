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

}
