//
//  SortViewModel.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 21.02.2022.
//

import Foundation
import UIKit

class SortViewModel {
    var unsortedArray: [Int] = []
    var sortAscending = false
    
    var dificultyLevel = ExerciseDificulty.class0
    
    static func generate(for dificultyLevel: ExerciseDificulty = .class0) -> SortViewModel {
        let vm = SortViewModel()
        vm.dificultyLevel = dificultyLevel
        
        let ind = ExerciseDificulty.allCases.firstIndex { $0 == dificultyLevel } ?? 0
        vm.unsortedArray = SortArrayDataProvider(level: ind).unsortedArray()
        vm.sortAscending = Bool.random()
        
        return vm
    }
    
    var title: String {
        "Ordoneaza \(self.sortAscending ? "CRESCATOR" : "DESCRESCATOR") sirul de numere"
    }
    
    var sortedArray: [Int] {
        self.sortAscending ? self.unsortedArray.sorted() : self.unsortedArray.sorted().reversed()
    }
    
    func isSorted(output: [Int]) -> Bool {
        self.sortedArray == output
    }
}
