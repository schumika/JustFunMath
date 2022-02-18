//
//  SortArrayDataProvider.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 17.02.2022.
//

import Foundation

class SortArrayDataProvider {
    
    init(level: Int = 0) {
        self.level = level
    }
    
    let level: Int
    var numbersRange: ClosedRange<Int> {
        if level == 0 {
            return 1...9
        } else {
            return 1...99
        }
    }
    
    func unsortedArray(_ count: Int = 5) -> [Int] {
        var res: [Int] = []
        var valid = false
        
        while !valid {
            let val = Int.random(in: self.numbersRange)
            if !res.contains(val) {
                res.append(contentsOf: [val])
            }
            valid = res.count == count
        }
        
        return res
    }
}
