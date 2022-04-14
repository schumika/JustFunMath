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
    case comparison = "Comparatii"
    
    static var allOptions: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

struct ExerciseSettings {
    
    enum Key: String {
        case dificulty = "DificultyLevel"
        case type = "ExerciseType"
    }
    
    private let userDefaults = UserDefaults()
    
    init() {
        self.level = ExerciseLevel(rawValue: self.userDefaults.value(forKey: Key.dificulty.rawValue) as? String ?? "") ?? .class0
        self.type = ExerciseType(rawValue: self.userDefaults.value(forKey: Key.type.rawValue) as? String ?? "") ?? .sorting
    }
    
    var level: ExerciseLevel
    var type: ExerciseType
    
    var allLevels: [ExerciseLevel] {
        ExerciseLevel.allCases
    }
    
    var allTypes: [ExerciseType] {
        ExerciseType.allCases
    }
    
    mutating func update(with level: ExerciseLevel, type: ExerciseType) {
        self.level = level
        self.type = type
        
        self.saveValues()
    }
    
    func saveValues() {
        self.userDefaults.set(self.level.rawValue, forKey: Key.dificulty.rawValue)
        self.userDefaults.set(self.type.rawValue, forKey: Key.type.rawValue)
        
        self.userDefaults.synchronize()
    }
}
