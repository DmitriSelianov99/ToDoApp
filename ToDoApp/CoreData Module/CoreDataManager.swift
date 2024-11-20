//
// CoreDataManager.swift
// ToDoApp


import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "TodosContainer")
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING DATA...\(error.localizedDescription)")
            } else {
                print("SUCCESSFULLY DATA LOADING...\(description)")
            }
        }
        
        context = container.viewContext
        
        print(container)
        print(context)
    }
    
    
    func saveData() {
        do {
            try context.save()
        } catch let error {
            print("ERROR SAVING...\(error.localizedDescription)")
        }
    }
    
}

class CoreDataTodoViewModel: ObservableObject {
    
    let manager = CoreDataManager.shared
    
    @Published var todos: [TodoEntity] = []
    
    init() {
        getTodos()
    }
    
    
    func getTodos() {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        
        do {
            todos = try manager.context.fetch(request)
        } catch let error {
            print("ERROR TODOS CATCHING...\(error.localizedDescription)")
        }
    }
    
    func addTodo(_ todo: TodoModel) {
        print("Adding todo: \(todo)")
        let newTodo = TodoEntity(context: manager.context)
        newTodo.id = Int16(todo.id)
        newTodo.title = todo.title ?? "Default title"
        newTodo.todo = todo.todo
        newTodo.completed = todo.completed
        newTodo.userId = Int16(todo.userId)
        newTodo.date = Date()
        
        save()
    }
    
    func save() {
        todos.removeAll()
        
        DispatchQueue.main.async { [weak self] in
            self?.manager.saveData()
            self?.getTodos()
        }
    }
}
