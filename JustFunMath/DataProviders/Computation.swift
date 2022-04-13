//
//  Computation.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 13.04.2022.
//

import Foundation

enum Operator {
    case addition
    case substraction
}

extension Operator {
    var description: String {
        switch self {
        case .addition: return "+"
        case .substraction: return "-"
        }
    }
    
    var operation: (Int, Int)->(Int) {
        switch self {
        case .addition: return { $0 + $1 }
        case .substraction: return { $0 - $1 }
        }
    }
}

class Computation {
    var term1: Int = 0
    var term2: Int = 0
    var op: Operator = .addition
    var operatorDescription: String = "+"
    
    static func addition(t1: Int, t2: Int) -> Computation {
        Self.operation(t1: t1, t2: t2, operator: .addition)
    }
    
    static func substraction(t1: Int, t2: Int) -> Computation {
        Self.operation(t1: t1, t2: t2, operator: .substraction)
    }
    
    static func operation(t1: Int, t2: Int, operator: Operator) -> Computation {
        let comp = Computation()
        comp.term1 = t1
        comp.term2 = t2
        comp.op = `operator`
        comp.operatorDescription = comp.op.description
        return comp
    }
    
    var correctResult: Int {
        return self.op.operation(self.term1, self.term2)
    }
}
