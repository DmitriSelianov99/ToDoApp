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
                
                NewTodoViewTextEditorView(todoText: $todoText)
            }
        }
        .onAppear {
            if let model = todoModel { // Проверяем, передана ли модель
                titleText = model.title ?? "" // Если есть title, задаем его, иначе пустая строка
                todoDate = model.date?.formateDateToString() ?? Date().formateDateToString() // Форматируем дату
                todoText = model.todo // Задаем текст задачи
            }
        }
    }
}

//#Preview {
//    NewTodoView()
//}

struct NewTodoViewTextEditorView: View {
    
    @Binding var todoText: String
    @FocusState var isTextTyping: Bool
    
    var body: some View {
        TextEditor(text: $todoText)
            .focused($isTextTyping)
            .font(.system(size: 16, weight: .regular))
            .frame(maxHeight: .infinity)
            .foregroundStyle(isTextTyping ? .customWhite : .customWhite.opacity(0.5))
            .scrollContentBackground(.hidden)
            .background(Color.customBlack)
            .padding(.top, 16)
            .onChange(of: isTextTyping) { oldValue, newValue in
                if isTextTyping {
                    todoText = ""
                }
            }
    }
}

struct NewTodoViewDateView: View {
    
    @Binding var todoDate: String
    
    var body: some View {
        Text("\(todoDate)")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(.customWhite.opacity(0.5))
            .padding(.top, 8)
    }
}


struct NewTodoViewTitleView: View {
    
    @Binding var titleText: String
    @State var placeholder: String = ""
    
    var body: some View {
        TextField(text: $titleText) {
            Text("_add-title")
                .foregroundStyle(.customWhite.opacity(0.7))
                .font(.largeTitle)
        }
        .padding(.top, 20)
        .foregroundStyle(.customWhite)
        .font(.system(size: 34, weight: .bold))
        .onChange(of: titleText) { oldValue, newValue in
            placeholder = titleText
        }
            
    }
}

struct BackButtonView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var vm: TodoViewModel
    @Binding var titleText: String
    @Binding var todoText: String
    var todoModel: TodoModel?
    
    @State var showAlert = false
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .renderingMode(.template)
                .bold()
            
            Text("_back")
            
            Spacer()
        }
        .font(.system(size: 16, weight: .regular))
        .foregroundStyle(.customYellow)
        .onTapGesture {
            
            let arrayCount = Int(vm.coreDataVM.todos.last!.id)
            
            if (titleText.isEmpty || todoText.isEmpty) {
                showAlert.toggle()
            } else {
                if let model = todoModel {
                    vm.coreDataVM.editTodo(for: model.id, title: titleText, text: todoText)
                } else {
                    vm.coreDataVM.addTodo(TodoModel(id: vm.getLastTodoId() + 1, title: titleText, todo: todoText, completed: false, userId: 69, date: Date()))
                }
                
                vm.getTodosFromDB()
                
                dismiss()
            }
        }
        .alert(isPresented: $showAlert) {
            getAlert()
        }

    }
}

extension BackButtonView {
    func getAlert() -> Alert {
        return Alert(
            title: Text("_attention"),
            message: Text("_empty-fileds"),
            primaryButton: .destructive(Text("_delete"), action: {
                dismiss()
            }),
            secondaryButton: .cancel()
        )
    }
}
