//
//  GroupSortData.swift
//  GroupSortData
//
//  Created by Jin Sasaki on 2017/01/29.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

public struct GroupSortData<Index: GroupIndex, Item: GroupSortable> {

    /**
     Initilize with sortable objects
     - parameter items: sortable item array
     - returns: group sorted data
     */
    public init(items: [Item]) {
        self.sortedItems = sort(items)
        self._groups = group(sortedItems)
    }

    // MARK: Property
    public var isEmpty: Bool {
        get {
            return sortedItems.isEmpty
        }
    }

    /**
     Groups by the first letter.
     Return the filtered groups if filtering.
     */
    public var groups: [(groupIndex: Index, items: [Item])] {
        if let filteredGroups = _filteredGroups {
            return filteredGroups
        } else {
            return _groups
        }
    }
    public var count: Int {
        if _filteredGroups != nil {
            return _filteredCount
        } else {
            return sortedItems.count
        }
    }
    fileprivate var _groups: [(groupIndex: Index, items: [Item])] = []
    fileprivate var _filteredGroups: [(groupIndex: Index, items: [Item])]?
    fileprivate var _filteredCount: Int = 0

    /// Map to convert from indexPath of filteredGroups
    fileprivate var filterMap: [IndexPath: IndexPath]?

    /// Sorted all items
    fileprivate(set) var sortedItems: [Item] = []

    /**
     Sort by sortIndex
     - parameter sortableItems: sortable items
     - returns: sorted items
     */
    private func sort(_ sortableItems: [Item]) -> [Item] {
        return sortableItems.sorted(by: { $0.sortIndex < $1.sortIndex })
    }

    /**
     Group sorted items by the first letter
     - important: You must pass sorted items! If unsorted items, you will receive unexpected results.
     - parameter sortedItems: sorted items by function  `sort(_:)`
     - returns: Tupples which have items sorted and grouped by the first letter and that letter
     */
    private func group(_ sortedItems: [Item]) -> [(groupIndex: Index, items: [Item])] {
        var groups: [(groupIndex: Index, items: [Item])] = []
        var itemIndex: Int = 0
        for i in 0 ..< Index.count - 1 {
            var itemsInGroup: [Item] = []
            while itemIndex < sortedItems.count && i == sortedItems[itemIndex].groupIndex.index {
                itemsInGroup.append(sortedItems[itemIndex])
                itemIndex += 1
            }
            guard let groupIndex = Index(index: i) else {
                continue
            }
            groups.append((groupIndex: groupIndex, items: itemsInGroup))
        }
        // Append the rest together
        if itemIndex < sortedItems.count {
            groups.append((groupIndex: Index(index: Index.count - 1)!, items: Array(sortedItems[itemIndex..<sortedItems.endIndex])))
        } else {
            groups.append((groupIndex: Index(index: Index.count - 1)!, items: []))
        }
        return groups
    }

    public mutating func removeItemAtIndexPath(_ indexPath: IndexPath) {
        var removeIndexPath = indexPath
        if let filterMap = filterMap, let mappedIndexPath = filterMap[indexPath] {
            // Remove from filteredGroups
            _filteredGroups?[indexPath.section].items.remove(at: indexPath.row)

            // Convert indexPath from filteredGroups
            removeIndexPath = mappedIndexPath
            self.filterMap?[indexPath] = nil
        }
        var removeIndex = 0
        for section in 0..<removeIndexPath.section {
            removeIndex += groups[section].items.count
        }
        removeIndex += removeIndexPath.row

        _groups[removeIndexPath.section].items.remove(at: removeIndexPath.row)
        sortedItems.remove(at: removeIndex)
    }

    public mutating func removeItemsAtIndexPaths(_ indexPaths: [IndexPath]) {

        // Sort index paths
        let sortedIndexPaths = indexPaths.sorted {
            if $0.section == $1.section {
                return $0.row > $1.row
            } else {
                return $0.section > $1.section
            }
        }
        // Remove items
        for indexPath in sortedIndexPaths {
            removeItemAtIndexPath(indexPath)
        }
    }
    public subscript(indexPath: IndexPath) -> Item? {
        return itemAtIndexPath(IndexPath)
    }

    public func itemAtIndexPath(_ indexPath: IndexPath) -> Item? {
        if groups.isEmpty
            || groups.count <= indexPath.section
            || groups[indexPath.section].items.count == 0
            || groups[indexPath.section].items.count <= indexPath.row {
            return nil
        }
        return groups[indexPath.section].items[indexPath.row]
    }

    public func find(_ condition: (Item) -> Bool) -> IndexPath? {
        for (i, group) in groups.enumerated() {
            for (j, item) in group.items.enumerated() where condition(item) {
                return IndexPath(row: j, section: i)
            }
        }
        return nil
    }
}

extension GroupSortData where Item: TextFilterable {
    var isFiltering: Bool {
        return self._filteredGroups != nil
    }

    public mutating func textFilter(_ text: String?) {
        guard let text = text, text.characters.count > 0 else {
            resetFilter()
            return
        }
        var filteredGroups: [(groupIndex: Index, items: [Item])] = []
        var filterMap: [IndexPath: IndexPath] = [:]

        _filteredCount = 0
        for (i, group) in _groups.enumerated() {
            var itemsInGroup: [Item] = []
            for (j, item) in group.items.enumerated() {
                if item.filterText.localizedCaseInsensitiveContains(text) {
                    let indexPathOfFiltered = IndexPath(row: itemsInGroup.count, section: i)
                    let indexPathOfGroup = IndexPath(row: j, section: i)
                    filterMap[indexPathOfFiltered] = indexPathOfGroup
                    itemsInGroup.append(item)
                }
            }
            filteredGroups.append((groupIndex: group.groupIndex, items: itemsInGroup))
            _filteredCount += itemsInGroup.count
        }

        _filteredGroups = filteredGroups
        self.filterMap = filterMap
    }

    public mutating func resetFilter() {
        _filteredGroups = nil
        filterMap = nil
        _filteredCount = 0
    }
}
