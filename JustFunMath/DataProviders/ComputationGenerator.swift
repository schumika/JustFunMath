//
//  ComputationGenerator.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import Foundation

class Computation {
    var digit1: Int = 0
    var digit2: Int = 0
    var op: (Int, Int)->(Int) = {_, _ in 0}
    var operatorDescription: String = "+"
    
    static func addition(t1: Int, t2: Int) -> Computation {
        let comp = Computation()
        comp.digit1 = t1
        comp.digit2 = t2
        comp.op = { t1, t2 in return t1 + t2}
        comp.operatorDescription = "+"
        return comp
    }
    
    static func substraction(t1: Int, t2: Int) -> Computation {
        let comp = Computation()
        comp.digit1 = t1
        comp.digit2 = t2
        comp.op = { t1, t2 in return t1 - t2}
        comp.operatorDescription = "-"
        return comp
    }
    
    var correctResult: Int {
        return self.op(self.digit1, self.digit2)
    }
}


// TODO: remove static functions!!!!
class ComputationGenerator {
    
    static func generateComputations(settings: ExerciseSettings, count: Int = 3) -> [Computation] {
        return (0..<count).map { _ in Self.generateComputation(settings: settings) }
    }
    
    static func generateComputation(settings: ExerciseSettings) -> Computation {
        let opType = Int.random(in: 0...1)
        
        if settings.dificulty == .class0 {
            return opType == 0 ? Self.simpleAddition() : Self.simpleSubstraction()
        } else {
            return opType == 0 ? Self.addition() : Self.substraction()
        }
    }
    
    static func generateComputations(count: Int) -> [Computation] {
        var comps: [Computation] = []
        for _ in 0 ..< count {
            let opType = Int.random(in: 0...1)
//            comps.append(opType == 0 ? Self.simpleAddition() : Self.simpleSubstraction())
            comps.append(opType == 0 ? Self.addition() : Self.substraction())
        }
        return comps
    }
    
    static func simpleAddition() -> Computation {
        let (t1, t2) = ComputationGenerator.getSimpleAddition()
        return Computation.addition(t1: t1, t2: t2)
    }
    
    static func simpleSubstraction() -> Computation {
        let (t1, t2) = ComputationGenerator.getSimpleSubstraction()
        return Computation.substraction(t1: t1, t2: t2)
    }
    
    static func addition() -> Computation {
        let (t1, t2) = ComputationGenerator.getAddition()
        return Computation.addition(t1: t1, t2: t2)
    }
    
    static func substraction() -> Computation {
        let (t1, t2) = ComputationGenerator.getSubstraction()
        return Computation.substraction(t1: t1, t2: t2)
    }
    
    static func getSimpleAddition() -> (Int, Int) {
        while (true) {
            let t1 = Int.random(in: 0...9)
            let t2 = Int.random(in: 0...9)
            
            if t1 + t2 < 10 {
                return (t1, t2)
            }
        }
    }
    
    static func getSimpleSubstraction() -> (Int, Int){
        while (true) {
            let t1 = Int.random(in: 0...9)
            let t2 = Int.random(in: 0...9)
            
            if t2 <= t1 {
                return (t1, t2)
            }
        }
    }
    
    static func getAddition() -> (Int, Int){
        while (true) {
//            let t1 = Int.random(in: 0...9)
//            let t2 = Int.random(in: 0...9)
//
//            let t3 = Int.random(in: 0...9)
//            let t4 = Int.random(in: 0...9)
//
//            if /*t2 + t4 < 10 &&*/ t1 + t3 < 10 {
//
//                let x1 = t1 * 10 + t2
//                let x2 = t3 * 10 + t4
//                if x1 + x2 < 100 {
//                    found = true
//                    return (x1, x2)
//                }
//            }
            let t1 = Int.random(in: 0...99)
            let t2 = Int.random(in: 0...99)
            if t1 + t2 < 100 {
                return (t1, t2)
            }
        }
    }

    static func getSubstraction() -> (Int, Int) {
        var found = false
        while (!found) {
            let t1 = Int.random(in: 0...9)
            let t2 = Int.random(in: 0...9)
            
            let t3 = Int.random(in: 0...9)
            let t4 = Int.random(in: 0...9)
            
            if /*t2 >= t4 &&*/ t1 >= t3 {
                
                let x1 = t1 * 10 + t2
                let x2 = t3 * 10 + t4
                if x1 - x2 > 0 {
                    found = true
                    return (x1, x2)
                }
            }
        }
    }
}
