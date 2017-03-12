//
//  EnJaGroupIndex.swift
//  GroupSortData
//
//  Created by Jin Sasaki on 2017/01/29.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

public enum EnJaGroupIndex: Int, GroupIndex {
    case a = 0, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
    case aa, ka, sa, ta, na, ha, ma, ya, ra, wa
    case other

    public var name: String {
        switch self {
        case .a: return "A"
        case .b: return "B"
        case .c: return "C"
        case .d: return "D"
        case .e: return "E"
        case .f: return "F"
        case .g: return "G"
        case .h: return "H"
        case .i: return "I"
        case .j: return "J"
        case .k: return "K"
        case .l: return "L"
        case .m: return "M"
        case .n: return "N"
        case .o: return "O"
        case .p: return "P"
        case .q: return "Q"
        case .r: return "R"
        case .s: return "S"
        case .t: return "T"
        case .u: return "U"
        case .v: return "V"
        case .w: return "W"
        case .x: return "X"
        case .y: return "Y"
        case .z: return "Z"

        case .aa: return "あ"
        case .ka: return "か"
        case .sa: return "さ"
        case .ta: return "た"
        case .na: return "な"
        case .ha: return "は"
        case .ma: return "ま"
        case .ya: return "や"
        case .ra: return "ら"
        case .wa: return "わ"
        case .other: return "#"
        }
    }
    public var index: Int {
        return self.rawValue
    }

    public init?(index: Int) {
        self.init(rawValue: index)
    }

    public init(value: String) {
        if value.isEmpty {
            self = .other
            return
        }

        var string = String(value[value.startIndex]).uppercased()
        guard let c = string.unicodeScalars.first?.value else {
            self = .other
            return
        }
        if string >= "\u{0041}" && string <= "\u{005A}", let index = EnJaGroupIndex(index: Int(c) - 0x0041) {
            // A-Z
            self = index
        } else if string >= "\u{3041}" && string <= "\u{304A}" {
            self = .aa
        } else if string >= "\u{304B}" && string <= "\u{3054}" {
            self = .ka
        } else if string >= "\u{3055}" && string <= "\u{305E}" {
            self = .sa
        } else if string >= "\u{305F}" && string <= "\u{3069}" {
            self = .ta
        } else if string >= "\u{306A}" && string <= "\u{306E}" {
            self = .na
        } else if string >= "\u{306F}" && string <= "\u{307D}" {
            self = .ha
        } else if string >= "\u{307E}" && string <= "\u{3082}" {
            self = .ma
        } else if string >= "\u{3083}" && string <= "\u{3088}" {
            self = .ya
        } else if string >= "\u{3089}" && string <= "\u{308D}" {
            self = .ra
        } else if string >= "\u{308F}" && string <= "\u{3093}" {
            self = .wa
        } else {
            self = .other
        }
    }

    public static var count: Int {
        return EnJaGroupIndex.other.rawValue + 1
    }
}
