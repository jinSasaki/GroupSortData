//
//  GroupSortable.swift
//  GroupSortArray
//
//  Created by Jin Sasaki on 2017/01/29.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

/**
 A protocol for group sort
 - seealso: GroupSortData
 */
public protocol GroupSortable {
    associatedtype Index: GroupIndex
    var sortIndex: String { get }
    var groupIndex: Index { get }
}

public extension GroupSortable {
    var groupIndex: Index {
        return Index(value: sortIndex)
    }
}

