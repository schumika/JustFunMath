//
//  SortViewModel.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 21.02.2022.
//

import Foundation
import UIKit

class SortViewModel {
    var unsortedArray: [Int] {
        get {
            self.sortAscending = Bool.random()
        
            let unsortedArray = SortArrayDataProvider(level: self.level.value).unsortedArray()
            self.generatedArray = unsortedArray
            return unsortedArray
        }
    }
    var sortAscending = false
    
    private var level: ExerciseLevel
    private var generatedArray: [Int] = []

    init(level: ExerciseLevel) {
        self.level = level
    }
    
    var title: String {
        "Ordoneaza \(self.sortAscending ? "CRESCATOR" : "DESCRESCATOR") sirul de numere"
    }
    
    var sortedArray: [Int] {
        self.sortAscending ? self.generatedArray.sorted() : self.generatedArray.sorted().reversed()
    }
    
    func isSorted(output: [Int]) -> Bool {
        self.sortedArray == output
    }
}
