//
//  GroupIndex.swift
//  GroupSortArray
//
//  Created by Jin Sasaki on 2017/01/29.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

public protocol GroupIndex {
    init?(index: Int)
    init(value: String)
    var name: String { get }
    var index: Int { get }
    static var count: Int { get }
}
