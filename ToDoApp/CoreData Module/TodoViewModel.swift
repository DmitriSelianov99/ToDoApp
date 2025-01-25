//
// TodoMVM.swift
// ToDoApp


import Foundation
import SwiftUI


class TodoViewModel: ObservableObject {
    
    @Published var todos: [TodoModel] = []
    private var allTodos: [TodoModel] = []
    @Published var total: Int = 0
    
    var coreDataVM = CoreDataTodoViewModel()
    
    @AppStorage("isFirstRun") var isFirstRun = true
    
    private var networkManager = NetworkManager.shared
    
    init() {
        if isFirstRun {
            getTodosFromURL()
            isFirstRun = false
        } else {
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
            todos = allTodos
        } else {
            
            let titleFilter = allTodos.filter { $0.title?.localizedCaseInsensitiveContains(word) == true }
            let todoFilter = allTodos.filter { $0.todo.localizedCaseInsensitiveContains(word) == true }
            
            
            if !titleFilter.isEmpty {
                todos = titleFilter
            } else {
                todos = todoFilter
            }

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
            
            self.todos.sort { $0.id > $1.id }
            
            self.allTodos = self.todos
        }
        
    }

    
    func getTodosFromURL() {
        networkManager.getTodosFromURL { [weak self] result in
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    self?.todos = todos
                    self?.total = todos.count
                    
                    for todo in todos {
                        self?.coreDataVM.addTodo(todo)
                    }
                    
                    self?.coreDataVM.todos.sort { $0.id < $1.id }
                    self?.getTodosFromDB()
                }
            case .failure(let error):
                print("Error fetching todos: \(error)")
            }
        }
    }
}
