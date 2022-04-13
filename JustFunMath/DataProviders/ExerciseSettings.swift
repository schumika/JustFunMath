//
//  ExerciseSettings.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import Foundation

enum ExerciseLevel: String, CaseIterable {
    case class0 = "Clasa 0"
    case class1 = "Clasa 1"
    
    var value: Int {
        switch self {
        case .class0 : return 0
        case .class1: return 1
        }
    }
    
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

struct ExerciseSettings {
    var level: ExerciseLevel = .class0
    var type: ExerciseType = .sorting
    
    var allLevels: [ExerciseLevel] {
        ExerciseLevel.allCases
    }
    
    var allTypes: [ExerciseType] {
        ExerciseType.allCases
    }
    
    mutating func update(with level: ExerciseLevel, type: ExerciseType) {
        self.level = level
        self.type = type
    }
}
