//
//  GroupSortDataTests.swift
//  GroupSortDataTests
//
//  Created by Jin Sasaki on 2017/01/29.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import XCTest
@testable import GroupSortData

struct Item: GroupSortable, TextFilterable {
    typealias Index = EnJaGroupIndex
    let name: String
    var sortIndex: String { return name }
    var filterText: String { return name }
}

class GroupSortDataTests: XCTestCase {
    
    func testInit() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        let data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        XCTAssertEqual(data.count, items.count)
    }

    func testIsEmpty() {
        XCTAssertEqual(GroupSortData<EnJaGroupIndex, Item>(items: []).isEmpty, true)
        XCTAssertEqual(GroupSortData<EnJaGroupIndex, Item>(items: [Item(name: "a")]).isEmpty, false)
    }

    func testGroups() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        let data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        XCTAssertEqual(data.groups.count, EnJaGroupIndex.count)
        XCTAssertEqual(data.groups[EnJaGroupIndex.a.rawValue].items.count, 1)
        XCTAssertEqual(data.groups[EnJaGroupIndex.b.rawValue].items.count, 1)
        XCTAssertEqual(data.groups[EnJaGroupIndex.c.rawValue].items.count, 1)
    }

    func testGroupsWhereFiltered() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        data.filter(text: "a")
        XCTAssertEqual(data.groups.count, EnJaGroupIndex.count)
        XCTAssertEqual(data.groups[EnJaGroupIndex.a.rawValue].items.count, 1)
        XCTAssertEqual(data.groups[EnJaGroupIndex.b.rawValue].items.count, 0)
        XCTAssertEqual(data.groups[EnJaGroupIndex.c.rawValue].items.count, 0)
    }

    func testCount() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        let data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        XCTAssertEqual(data.count, 3)
    }

    func testCountWhereFiltered() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        data.filter(text: "a")
        XCTAssertEqual(data.count, 1)
    }

    func testSubscript() {
        let items = [
            Item(name: "a1"),
            Item(name: "c"),
            Item(name: "a2"),
            Item(name: "b")
        ]
        let data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        XCTAssertEqual(data[IndexPath(row: 0, section: 0)]?.name, "a1")
        XCTAssertEqual(data[IndexPath(row: 1, section: 0)]?.name, "a2")
        XCTAssertEqual(data[IndexPath(row: 0, section: 1)]?.name, "b")
        XCTAssertEqual(data[IndexPath(row: 0, section: 2)]?.name, "c")
        XCTAssertNil(data[IndexPath(row: 0, section: 3)]?.name)
    }

    func testFind() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        let data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        let indexPath = data.find({ $0.name == "c" })
        XCTAssertEqual(indexPath!.row, 0)
        XCTAssertEqual(indexPath!.section, 2)
        XCTAssertNil(data.find({ $0.name == "d" }))
    }

    func testRemoveItem() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        data.removeItem(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(data.count, 2)
        XCTAssertNil(data[IndexPath(row: 0, section: 0)])
    }

    func testRemoveItemWhereFiltered() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        data.filter(text: "b")
        data.removeItem(at: IndexPath(row: 0, section: 1))
        XCTAssertEqual(data.count, 0)
        XCTAssertNil(data[IndexPath(row: 0, section: 1)])
    }

    func testRemoveItemsAsc() {
        let items = [
            Item(name: "a2"),
            Item(name: "c2"),
            Item(name: "b2"),
            Item(name: "a1"),
            Item(name: "c1"),
            Item(name: "b1")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        data.removeItems(at: [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 0, section: 1),
            IndexPath(row: 1, section: 1),
            ]
        )
        XCTAssertEqual(data.count, 3)
        XCTAssertEqual(data.groups[EnJaGroupIndex.a.rawValue].items.count, 1)
        XCTAssertEqual(data.groups[EnJaGroupIndex.b.rawValue].items.count, 0)
        XCTAssertEqual(data.groups[EnJaGroupIndex.c.rawValue].items.count, 2)
    }

    func testRemoveItemsDesc() {
        let items = [
            Item(name: "a2"),
            Item(name: "c2"),
            Item(name: "b2"),
            Item(name: "a1"),
            Item(name: "c1"),
            Item(name: "b1")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        data.removeItems(at: [
            IndexPath(row: 1, section: 1),
            IndexPath(row: 0, section: 0),
            IndexPath(row: 0, section: 1),
            ]
        )
        XCTAssertEqual(data.count, 3)
        XCTAssertEqual(data.groups[EnJaGroupIndex.a.rawValue].items.count, 1)
        XCTAssertEqual(data.groups[EnJaGroupIndex.b.rawValue].items.count, 0)
        XCTAssertEqual(data.groups[EnJaGroupIndex.c.rawValue].items.count, 2)
    }

    func testIsFiltering() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        XCTAssertFalse(data.isFiltering)

        data.filter(text: "a")
        XCTAssertTrue(data.isFiltering)

        data.resetFilter()
        XCTAssertFalse(data.isFiltering)
    }

    func testFilterByEmptyText() {
        let items = [
            Item(name: "a"),
            Item(name: "c"),
            Item(name: "b")
        ]
        var data = GroupSortData<EnJaGroupIndex, Item>(items: items)
        data.filter(text: "")
        XCTAssertFalse(data.isFiltering)
    }
}
