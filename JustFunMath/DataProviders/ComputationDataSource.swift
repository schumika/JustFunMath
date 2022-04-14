//
//  ComputationGenerator.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import Foundation

class ComputationDataSource {
    
    var level: ExerciseLevel = .class0
    var maximumNumber: Int {
        self.level == .class0 ? 9 : 99
    }
    
    func getAddition(maxValue: Int) -> (Int, Int) {
        while (true) {
            let t1 = Int.random(in: 0...maxValue)
            let t2 = Int.random(in: 0...maxValue)
            if t1 + t2 <= maxValue {
                return (t1, t2)
            }
        }
    }

    func getSubstraction(maxValue: Int) -> (Int, Int) {
        while (true) {
            let t1 = Int.random(in: 0...maxValue)
            let t2 = Int.random(in: 0...maxValue)
            if t2 <= t1 {
                return (t1, t2)
            }
        }
    }
    
    func addition() -> Computation {
        return Computation.addition(self.getAddition(maxValue: self.maximumNumber))
    }
    
    func substraction() -> Computation {
        return Computation.addition(self.getAddition(maxValue: self.maximumNumber))
    }
    
    func generateComputations(level: ExerciseLevel, count: Int = 3) -> [Computation] {
        return (0..<count).map { _ in self.generateComputation(level: level) }
    }
    
    func generateComputation(level: ExerciseLevel) -> Computation {
        self.level = level
        return Int.random(in: 0...1) == 0 ? self.addition() : self.substraction()
    }
}
