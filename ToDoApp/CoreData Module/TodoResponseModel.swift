//
// TodoResponse.swift
// ToDoApp


import Foundation

struct TodoResponseModel: Codable {
    let todos: [TodoModel]
    let total: Int
    let skip: Int
    let limit: Int
}
