//
//  Comparison.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 14.04.2022.
//

import Foundation

enum ComparisonResult {
    case greaterThan, lessThan, equalTo
}

class Comparison: ExerciseProtocol {
    let term1: Int
    let term2: Int
    
    init(t1: Int, t2: Int) {
        self.term1 = t1
        self.term2 = t2
    }
    
    var correctResult: ComparisonResult {
        if term1 > term2 { return .greaterThan }
        if term1 < term2 { return .lessThan }
        return .equalTo
    }
    
    func isCorrect(result: String) -> Bool {
        switch (self.correctResult, result) {
        case (.greaterThan, ">"): return true
        case (.lessThan, "<"): return true
        case (.equalTo, "="): return true
        default:
            return false
        }
    }
}
