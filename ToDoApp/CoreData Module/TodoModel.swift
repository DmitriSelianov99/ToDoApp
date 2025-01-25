//
// TodoModel.swift
// ToDoApp


import Foundation

struct TodoModel: Codable, Identifiable, Equatable {
    let id: Int
    let title: String?
    let todo: String
    var completed: Bool
    let userId: Int
    let date: Date?
    
    mutating func changeTodoStatus() {
        self.completed.toggle()
    }
}
