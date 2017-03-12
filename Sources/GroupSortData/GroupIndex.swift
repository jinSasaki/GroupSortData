//
//  GroupIndex.swift
//  GroupSortArray
//
//  Created by Jin Sasaki on 2017/01/29.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

public protocol GroupIndex {
    static var count: Int { get }
    init?(index: Int)
    var name: String { get }
    var index: Int { get }
}
