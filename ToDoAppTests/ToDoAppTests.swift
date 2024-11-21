

import CoreData
import XCTest
@testable import ToDoApp

class TestCoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodosContainer")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}

final class TodoAppTests: XCTestCase {
    
    var vm: TodoViewModel!
    
    override func setUp() {
        super.setUp()
        vm = TodoViewModel()
    }
    
    override func tearDown() {
        vm = nil
        super.tearDown()
    }
    

    func testAddTodo() {
            let expectation = XCTestExpectation(description: "Todo should be added to the list")
            let newTodo = TodoModel(id: 1, title: "Test Task", todo: "This is a test task", completed: false, userId: 69, date: Date())
            
            vm.coreDataVM.addTodo(newTodo)
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual(self.vm.coreDataVM.todos.count, 1)
                
                let addedTodo = self.vm.coreDataVM.todos.first
                XCTAssertEqual(addedTodo?.title, "Test Task")
                XCTAssertEqual(addedTodo?.todo, "This is a test task")
                XCTAssertEqual(addedTodo?.completed, false)
                XCTAssertEqual(addedTodo?.userId, 69)
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    
    // 2. Тест редактирования задачи
    func testEditTodo() {
        
        let randomId = Int.random(in: 500..<600)
        
        let initialTodo = TodoModel(id: randomId, title: "Old Title", todo: "Old Task", completed: false, userId: 69, date: Date())
        vm.coreDataVM.addTodo(initialTodo)
        
        vm.coreDataVM.editTodo(for: randomId, title: "Updated Title", text: "Updated Task")
        
        XCTAssertEqual(vm.coreDataVM.todos.first?.title, "Updated Title")
        XCTAssertEqual(vm.coreDataVM.todos.first?.todo, "Updated Task")
    }
    
    // 3. Тест удаления задачи
    func testDeleteTodo() {
        
        let randomId = Int.random(in: 500..<600)
        
        let todoToDelete = TodoModel(id: randomId, title: "Task to Delete", todo: "This task will be deleted", completed: false, userId: 69, date: Date())
        vm.coreDataVM.addTodo(todoToDelete)
        
        let initialCount = vm.coreDataVM.todos.count
        
        vm.deleteTodo(for: todoToDelete.id)
        
        XCTAssertEqual(vm.coreDataVM.todos.count, initialCount)
    }
    
    // 4. Тест поиска задачи
    func testSearchTodo() {
        let todo1 = TodoModel(id: 700, title: "Milk", todo: "Buy milk from store", completed: false, userId: 69, date: Date())
        let todo2 = TodoModel(id: 701, title: "Walk Dog", todo: "Walk the dog in park", completed: false, userId: 69, date: Date())
        
        vm.coreDataVM.addTodo(todo1)
        vm.coreDataVM.addTodo(todo2)
        
        let searchText = "Milk"
        vm.findTodo(by: searchText)
        
        XCTAssertEqual(vm.todos.count, 1)
        XCTAssertEqual(vm.todos.first?.title, "Buy Milk")
    }
    
    // 5. Тест загрузки задач из базы данных
    func testLoadTodosFromDB() {
        let todo1 = TodoModel(id: 1, title: "Grocery Shopping", todo: "Buy groceries", completed: false, userId: 69, date: Date())
        let todo2 = TodoModel(id: 2, title: "Homework", todo: "Finish homework", completed: false, userId: 69, date: Date())
        
        vm.coreDataVM.addTodo(todo1)
        vm.coreDataVM.addTodo(todo2)
        
        vm.getTodosFromDB()
        
        XCTAssertEqual(vm.coreDataVM.todos.count, 2)
        XCTAssertEqual(vm.coreDataVM.todos.first?.title, "Grocery Shopping")
    }
    
    // 6. Тест на пустое поле при добавлении новой задачи
    func testEmptyTitleAndTextForNewTodo() {
        let emptyTodo = TodoModel(id: 3, title: "", todo: "", completed: false, userId: 69, date: Date())
        
        vm.coreDataVM.addTodo(emptyTodo)
        
        XCTAssertEqual(vm.coreDataVM.todos.count, 0)
    }
}
