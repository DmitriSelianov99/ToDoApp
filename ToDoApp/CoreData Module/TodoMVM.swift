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

class TodoViewModel: ObservableObject {
    
    @Published var todos: [TodoModel] = []
    private var allTodos: [TodoModel] = []
    @Published var total: Int = 0
    
    var coreDataVM = CoreDataTodoViewModel()
    
    @AppStorage("isFirstRun") var isFirstRun = true
    
    init() {
        print("Initial isFirstRun value: \(isFirstRun)")
        if isFirstRun {
            print("First run detected. Fetching todos...")
            getTodosFromURL()
            isFirstRun = false
            print("isFirstRun updated to: \(isFirstRun)")
        } else {
            print("Not the first run. isFirstRun: \(isFirstRun)")
            getTodosFromDB()
        }
    }
    
    func getLastTodoId() -> Int {
        var lastTodoId = 0
        var idArray: [Int] = []
        
        for todo in todos {
            idArray.append(todo.id)
        }
        
        lastTodoId = idArray.max() ?? 0
        
        return lastTodoId
    }
    
    func deleteTodo(for id: Int) {
        coreDataVM.deleteTodo(for: id)
        getTodosFromDB()
    }
    
    func findTodo(by word: String) {
        if word.isEmpty {
            // Если строка поиска пуста, возвращаем полный список
            todos = allTodos
        } else {
            // Фильтруем только подходящие записи
            todos = allTodos.filter { $0.title?.localizedCaseInsensitiveContains(word) == true }
        }
    }
    
    func getTodosFromDB() {
        todos.removeAll()
        
        DispatchQueue.main.async {
            for todo in self.coreDataVM.todos {
                self.todos.append(
                    TodoModel(
                        id: Int(todo.id),
                        title: todo.title ?? "Default title",
                        todo: todo.todo ?? "TODO",
                        completed: todo.completed,
                        userId: Int(todo.userId),
                        date: todo.date ?? Date())
                )
            }
            
            self.todos.sort { first, second in
                first.id > second.id
            }
            
            self.allTodos = self.todos
        }
        
    }

    
    func getTodosFromURL() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        fetchTodos(from: url) { data in
            if let data = data {
                
                guard let response = try? JSONDecoder().decode(TodoResponse.self, from: data) else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.todos = response.todos
                    self?.total = response.total
                    
                    for todo in response.todos {
                        self?.coreDataVM.addTodo(todo)
                    }
                    
                    self?.coreDataVM.todos.sort(by: { first, second in
                        first.id < second.id
                    })
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
