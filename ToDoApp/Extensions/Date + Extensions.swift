//
// Date + Extensions.swift
// ToDoApp


import Foundation


extension Date {
    func formateDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
