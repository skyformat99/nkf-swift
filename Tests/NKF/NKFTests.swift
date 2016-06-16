//
//  NKFTests.swift
//  NKFTests
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import XCTest
@testable import NKF
import Foundation

extension NKFBasicTests {
    static var allTests : [(String, (NKFBasicTests) -> () throws -> Void)] {
        return [
                   ("testUTF8ToUTF8", testUTF8ToUTF8),
                   ("testShiftJISToUTF8", testShiftJISToUTF8),
                   ("testEUCJPToUTF8", testEUCJPToUTF8),
                   ("testGuessUTF8", testGuessUTF8),
                   ("testGuessSJIS", testGuessSJIS),
                   ("testGuessEUCJP", testGuessEUCJP)
        ]
    }
}

#if !os(OSX)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase( NKFBasicTests.allTests ),
        ]
    }
#endif

#if SWIFT3_DEV
    extension String {
        enum Encoding {
            case utf8
            case shiftJIS
            case japaneseEUC
        }
        func data(using enc: Encoding) -> NSData? {
            switch enc {
            case .utf8: return self.data(using: NSUTF8StringEncoding)
            case .shiftJIS: return self.data(using: NSShiftJISStringEncoding)
            case .japaneseEUC: return self.data(using: NSJapaneseEUCStringEncoding)
            }
        }
    }
    
#endif

class NKFBasicTests: XCTestCase {
    
    func testUTF8ToUTF8() {
        let src = "日本語🍣あいうえお123"
        // let src = "日本語あいうえお123🍣" // TODO: will failure
        
        let srcData = src.data(using: String.Encoding.utf8)!
        let out = NKF.convert(data: srcData) as String?
        
        XCTAssertEqual(out!, src)
    }
    
    func testShiftJISToUTF8() {
        let src = "日本語あいう123"
        //print("src",src)
        let sjis = src.data(using: String.Encoding.shiftJIS)!
        //print("data",eucjp)
        
        let out = NKF.convert(data: sjis) as String?
        XCTAssertEqual(out!, src)
    }
    
    func testEUCJPToUTF8() {
        let src = "日本語あいう123"
        //print("src",src)
        let eucjp = src.data(using: String.Encoding.japaneseEUC)!
        //print("data",eucjp)
        
        let out = NKF.convert(data: eucjp) as String?
        XCTAssertEqual(out!, src)
    }
    
    func testGuessUTF8() {
        let src = "日本語🍣あいうえお123"
        let out = NKF.guess(data: src.data(using: String.Encoding.utf8)!)
        XCTAssertEqual(out!, Encoding.UTF8)
    }
    
    func testGuessSJIS() {
        let src = "日本語あいうえお123"
        let out = NKF.guess(data: src.data(using: String.Encoding.shiftJIS)!)
        XCTAssertEqual(out!, Encoding.ShiftJIS)
    }
    
    func testGuessEUCJP() {
        let src = "日本語あいうえお123"
        let out = NKF.guess(data: src.data(using: String.Encoding.japaneseEUC)!)
        XCTAssertEqual(out!, Encoding.EUCJP)
    }

    
}
