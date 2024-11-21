//
// NewTodoView.swift
// ToDoApp


import SwiftUI

struct NewTodoView: View {
    
    var todoModel: TodoModel? = nil
    
    @State var titleText: String = ""
    @State var todoDate: String = Date().formateDateToString()
    @State var todoText: String = "Введите задачу..."

    @ObservedObject var vm: TodoViewModel
    
    
    var body: some View {
        ZStack {
            Color.customBlack.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                BackButtonView(vm: vm, titleText: $titleText, todoText: $todoText, todoModel: todoModel)
                
                NewTodoViewTitleView(titleText: $titleText)
                
                NewTodoViewDateView(todoDate: $todoDate)
                
                NewTodoViewTextEditorView(todoText: $todoText, todoModel: todoModel)
            }
        }
        .onAppear {
            if let model = todoModel {
                titleText = model.title ?? ""
                todoDate = model.date?.formateDateToString() ?? Date().formateDateToString()
                todoText = model.todo
            }
        }
    }
}

//#Preview {
//    NewTodoView()
//}



