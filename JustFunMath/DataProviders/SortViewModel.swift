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
            
            let ind = self.settings.allDificulties.firstIndex { $0 == self.settings.dificulty } ?? 0
            let unsortedArray = SortArrayDataProvider(level: ind).unsortedArray()
            self.generatedArray = unsortedArray
            return unsortedArray
        }
    }
    var sortAscending = false
    
    private var settings: ExerciseSettings
    private var generatedArray: [Int] = []

    init(settings: ExerciseSettings) {
        self.settings = settings
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
