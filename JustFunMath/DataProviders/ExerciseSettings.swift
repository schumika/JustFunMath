//
//  ExerciseSettings.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import Foundation

enum ExerciseDificulty: String, CaseIterable {
    case class0 = "Clasa 0"
    case class1 = "Clasa 1"
    
    static var allOptions: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

enum ExerciseType: String, CaseIterable {
    case sorting = "Sortare"
    case computing = "Operatii"
    
    static var allOptions: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

class ExerciseSettings {
    var dificulty: ExerciseDificulty = .class0
    var type: ExerciseType = .sorting
}
