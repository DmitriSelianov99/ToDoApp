//
// Customizations.swift
// ToDoApp


import Foundation

class Customizations {
    static let customManager = Customizations()
    
    private init() {}
    
    func russianTaskTale(with num: Int) -> String {
        var tale = ""
        
        if num > 10 && num < 20 {
            return tale
        }
        
        switch num % 10 {
        case 1:
            tale = "а"
            return tale
        case 2, 3, 4:
            tale = "и"
            return tale
        default:
            return tale
        }
        
        
    }
}
