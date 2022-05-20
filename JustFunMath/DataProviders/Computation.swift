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

protocol ExerciseProtocol {
    var term1: Int { get }
    var term2: Int { get }
    var operatorDescription: String { get }
    
    func isCorrect(result: String) -> Bool
}

extension ExerciseProtocol {
    var operatorDescription: String { "" }
}

class Computation: ExerciseProtocol {
    var term1: Int
    var term2: Int
    let op: Operator
    var operatorDescription: String {
        self.op.description
    }
    
    init(t1: Int, t2: Int, operator: Operator) {
        self.term1 = t1
        self.term2 = t2
        self.op = `operator`
    }
    
    var correctResult: Int {
        return self.op.operation(self.term1, self.term2)
    }
    
    func isCorrect(result: String) -> Bool {
        String(self.correctResult) == result
    }
}

extension Computation {
    static func addition(_ t: (Int, Int)) -> Computation {
        return .init(t1: t.0, t2: t.1, operator: .addition)
    }
    
    static func substraction(_ t: (Int, Int)) -> Computation {
        return .init(t1: t.0, t2: t.1, operator: .substraction)
    }
}
