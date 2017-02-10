//
//  EnJaGroupIndexTests.swift
//  GroupSortData
//
//  Created by Jin Sasaki on 2017/02/11.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import XCTest
@testable import GroupSortData

class EnJaGroupIndexTests: XCTestCase {
    
    func testName() {
        XCTAssertEqual(EnJaGroupIndex.a.name, "A")
        XCTAssertEqual(EnJaGroupIndex.b.name, "B")
        XCTAssertEqual(EnJaGroupIndex.c.name, "C")
        XCTAssertEqual(EnJaGroupIndex.d.name, "D")
        XCTAssertEqual(EnJaGroupIndex.e.name, "E")
        XCTAssertEqual(EnJaGroupIndex.f.name, "F")
        XCTAssertEqual(EnJaGroupIndex.g.name, "G")
        XCTAssertEqual(EnJaGroupIndex.h.name, "H")
        XCTAssertEqual(EnJaGroupIndex.i.name, "I")
        XCTAssertEqual(EnJaGroupIndex.j.name, "J")
        XCTAssertEqual(EnJaGroupIndex.k.name, "K")
        XCTAssertEqual(EnJaGroupIndex.l.name, "L")
        XCTAssertEqual(EnJaGroupIndex.m.name, "M")
        XCTAssertEqual(EnJaGroupIndex.n.name, "N")
        XCTAssertEqual(EnJaGroupIndex.o.name, "O")
        XCTAssertEqual(EnJaGroupIndex.p.name, "P")
        XCTAssertEqual(EnJaGroupIndex.q.name, "Q")
        XCTAssertEqual(EnJaGroupIndex.r.name, "R")
        XCTAssertEqual(EnJaGroupIndex.s.name, "S")
        XCTAssertEqual(EnJaGroupIndex.t.name, "T")
        XCTAssertEqual(EnJaGroupIndex.u.name, "U")
        XCTAssertEqual(EnJaGroupIndex.v.name, "V")
        XCTAssertEqual(EnJaGroupIndex.w.name, "W")
        XCTAssertEqual(EnJaGroupIndex.x.name, "X")
        XCTAssertEqual(EnJaGroupIndex.y.name, "Y")
        XCTAssertEqual(EnJaGroupIndex.z.name, "Z")
        XCTAssertEqual(EnJaGroupIndex.aa.name, "あ")
        XCTAssertEqual(EnJaGroupIndex.ka.name, "か")
        XCTAssertEqual(EnJaGroupIndex.sa.name, "さ")
        XCTAssertEqual(EnJaGroupIndex.ta.name, "た")
        XCTAssertEqual(EnJaGroupIndex.na.name, "な")
        XCTAssertEqual(EnJaGroupIndex.ha.name, "は")
        XCTAssertEqual(EnJaGroupIndex.ma.name, "ま")
        XCTAssertEqual(EnJaGroupIndex.ya.name, "や")
        XCTAssertEqual(EnJaGroupIndex.ra.name, "ら")
        XCTAssertEqual(EnJaGroupIndex.wa.name, "わ")
        XCTAssertEqual(EnJaGroupIndex.other.name, "#")
    }

    func testInit() {
        XCTAssertEqual(EnJaGroupIndex(value: "a"), .a)
        XCTAssertEqual(EnJaGroupIndex(value: "A"), .a)
        XCTAssertEqual(EnJaGroupIndex(value: "あ"), .aa)
        XCTAssertEqual(EnJaGroupIndex(value: "か"), .ka)
        XCTAssertEqual(EnJaGroupIndex(value: "さ"), .sa)
        XCTAssertEqual(EnJaGroupIndex(value: "た"), .ta)
        XCTAssertEqual(EnJaGroupIndex(value: "な"), .na)
        XCTAssertEqual(EnJaGroupIndex(value: "は"), .ha)
        XCTAssertEqual(EnJaGroupIndex(value: "ま"), .ma)
        XCTAssertEqual(EnJaGroupIndex(value: "や"), .ya)
        XCTAssertEqual(EnJaGroupIndex(value: "ら"), .ra)
        XCTAssertEqual(EnJaGroupIndex(value: "わ"), .wa)
        XCTAssertEqual(EnJaGroupIndex(value: "漢字"), .other)
        XCTAssertEqual(EnJaGroupIndex(value: "1"), .other)
        XCTAssertEqual(EnJaGroupIndex(value: ""), .other)
    }
}
