//
//  GroupSortData.swift
//  GroupSortData
//
//  Created by Jin Sasaki on 2017/01/29.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

public struct Group<Index: GroupIndex, Item: GroupSortable> {
    let groupIndex: Index
    var items: [Item]
}

public struct GroupSortData<Index: GroupIndex, Item: GroupSortable> {

    /**
     Initilize with sortable objects
     - parameter items: sortable item array
     - returns: group sorted data
     */
    public init(items: [Item]) {
        self.sortedItems = sort(sortableItems: items)
        self._groups = group(sortedItems: sortedItems)
    }

    // MARK: - Public

    /**
     Groups by the first letter.
     Return the filtered groups if filtering.
     */
    public var groups: [Group<Index, Item>] {
        if let filteredGroups = _filteredGroups {
            return filteredGroups
        }
        return _groups
    }

    public var isEmpty: Bool {
        get {
            return sortedItems.isEmpty
        }
    }

    public var count: Int {
        if _filteredGroups != nil {
            return _filteredCount
        }
        return sortedItems.count
    }


    public subscript(indexPath: IndexPath) -> Item? {
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

    public mutating func removeItem(at indexPath: IndexPath) {
        var removeIndexPath = indexPath
        if let filterMap = self.filterMap, let mappedIndexPath = filterMap[indexPath] {
            // Remove from filteredGroups
            _filteredGroups?[indexPath.section].items.remove(at: indexPath.row)

            // Convert indexPath from filteredGroups
            removeIndexPath = mappedIndexPath
            self.filterMap?[indexPath] = nil
            _filteredCount -= 1
        }
        var removeIndex = 0
        for section in 0..<removeIndexPath.section {
            removeIndex += groups[section].items.count
        }
        removeIndex += removeIndexPath.row

        _groups[removeIndexPath.section].items.remove(at: removeIndexPath.row)
        sortedItems.remove(at: removeIndex)
    }
    
    public mutating func removeItems(at indexPaths: [IndexPath]) {

        // Sort index paths
        let sortedIndexPaths = indexPaths.sorted {
            if $0.section == $1.section {
                return $0.row > $1.row
            }
            return $0.section > $1.section
        }
        // Remove items
        for indexPath in sortedIndexPaths {
            removeItem(at: indexPath)
        }
    }
    
    // MARK: - fileprivate

    fileprivate var _groups: [Group<Index, Item>] = []
    fileprivate var _filteredGroups: [Group<Index, Item>]?
    fileprivate var _filteredCount: Int = 0

    /// Map to convert from indexPath of filteredGroups
    fileprivate var filterMap: [IndexPath: IndexPath]?

    /// Sorted all items
    fileprivate(set) var sortedItems: [Item] = []

    // MARK: - private

    /// Sort by sortIndex
    ///
    /// - Parameter sortableItems: sortable items
    /// - Returns: sorted items
    private func sort(sortableItems: [Item]) -> [Item] {
        return sortableItems.sorted(by: { $0.sortIndex < $1.sortIndex })
    }

    /// Group sorted items by the first letter
    /// important: You must pass sorted items! If unsorted items, you will receive unexpected results.
    ///
    /// - Parameter sortedItems: sorted items by function `sort(_:)`
    /// - Returns: Tupples which have items sorted and grouped by the first letter and that letter
    private func group(sortedItems: [Item]) -> [Group<Index, Item>] {
        var groups: [Group<Index, Item>] = []
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
            groups.append(Group(groupIndex: groupIndex, items: itemsInGroup))
        }
        // Append the rest together
        guard let groupIndex = Index(index: Index.count - 1) else {
            return groups
        }
        if itemIndex < sortedItems.count {
            groups.append(Group(groupIndex: groupIndex, items: Array(sortedItems[itemIndex..<sortedItems.endIndex])))
        } else {
            groups.append(Group(groupIndex: groupIndex, items: []))
        }
        return groups
    }
}

extension GroupSortData where Item: TextFilterable {
    var isFiltering: Bool {
        return self._filteredGroups != nil
    }

    public mutating func filter(text: String?) {
        guard let text = text, text.characters.count > 0 else {
            resetFilter()
            return
        }
        var filteredGroups: [Group<Index, Item>] = []
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
            filteredGroups.append(Group(groupIndex: group.groupIndex, items: itemsInGroup))
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
