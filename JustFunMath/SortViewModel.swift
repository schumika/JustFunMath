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
    
    var dificultyLevel = 0
    
    static func generate(for dificultyLevel: Int = 0) -> SortViewModel {
        let vm = SortViewModel()
        vm.dificultyLevel = dificultyLevel
        
        vm.unsortedArray = SortArrayDataProvider(level: vm.dificultyLevel).unsortedArray()
        vm.sortAscending = Bool.random()
        
        return vm
    }
    
    var title: String {
        "Ordoneaza \(self.sortAscending ? "CRESCATOR" : "DESCRESCATOR") sirul de numere"
    }
    
    func rightWrongTextLabel(isCorrect: Bool) -> String {
        isCorrect ? "CORECT" : "GRESIT"
    }
    func rightWrongTextLabelColor (isCorrect: Bool) -> UIColor {
        isCorrect ? .green : .red
    }
    
    var sortedArray: [Int] {
        self.sortAscending ? self.unsortedArray.sorted() : self.unsortedArray.sorted().reversed()
    }
    
    func isSorted(output: [Int]) -> Bool {
        self.sortedArray == output
    }
}
