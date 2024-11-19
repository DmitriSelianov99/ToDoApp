//
// TodoMVM.swift
// ToDoApp


import Foundation
import SwiftUI

struct TodoResponse: Codable {
    let todos: [TodoModel]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoModel: Codable, Identifiable {
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

class TodoViewModel: ObservableObject {
    
    @Published var todos: [TodoModel] = []
    @Published var total: Int = 0
    
    @AppStorage("isFirstRun") var isFirstRun = true
    
    init() {
        print("Initial isFirstRun value: \(isFirstRun)")
        if isFirstRun {
            print("First run detected. Fetching todos...")
            getTodos()
            isFirstRun = false
            print("isFirstRun updated to: \(isFirstRun)")
        } else {
            print("Not the first run. isFirstRun: \(isFirstRun)")
        }
    }

    
    func getTodos() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        fetchTodos(from: url) { data in
            if let data = data {
                
                guard let response = try? JSONDecoder().decode(TodoResponse.self, from: data) else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.todos = response.todos
                    self?.total = response.total
                }
                
                
                
            } else {
                print("NO DATA")
            }
        }
    }
    
    func fetchTodos(from url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else {
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
            
        }.resume()
        
    }
    
}
