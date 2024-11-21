//
// CoreDataManager.swift
// ToDoApp


import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext 

    
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
    
    func toggleCompleted(for id: Int) {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let todo = try manager.context.fetch(request).first {
                todo.completed.toggle()
                save()
                print("Toggled completed for todo with id: \(id)")
            } else {
                print("Todo with id \(id) not found")
            }
        } catch let error {
            print("Error toggling completed: \(error.localizedDescription)")
        }
    }
    
    func editTodo(for id: Int, title: String, text: String) {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let todo = try manager.context.fetch(request).first {
                todo.title = title
                todo.todo = text
                save()
                print("Editing completed for todo with id: \(id)")
            } else {
                print("Todo with id \(id) not found")
            }
        } catch let error {
            print("Error editing completed: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(for id: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try manager.context.fetch(request)
            if let todoToDelete = results.first {
                manager.context.delete(todoToDelete as! NSManagedObject)
                save()
                print("Объект с ID \(id) удален")
            } else {
                print("Объект с ID \(id) не найден.")
            }
        } catch let error {
            print("Ошибка при удалении: \(error.localizedDescription)")
        }
    }

    
    func save() {
        todos.removeAll()
        
        DispatchQueue.main.async { [weak self] in
            self?.manager.saveData()
            self?.getTodos()
        }
    }
}
