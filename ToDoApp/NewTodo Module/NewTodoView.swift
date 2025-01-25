//
// NewTodoView.swift
// ToDoApp


import SwiftUI

struct NewTodoView: View {
    
    var todoModel: TodoModel? = nil
    
    @State var titleText: String = ""
    @State var todoDate: String = Date().formateDateToString()
    @State var todoText: String = "Введите задачу..."
    @State var placeholder: String = ""
    @FocusState var isTextTyping: Bool

    @ObservedObject var vm: TodoViewModel
    
    
    var body: some View {
        ZStack {
            Color.customBlack.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                BackButtonView(vm: vm, titleText: $titleText, todoText: $todoText, todoModel: todoModel)
                
                todoTitleView
                
                todoDateView
                
                todoTextEditor
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

extension NewTodoView {
    private var todoTitleView: some View {
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
    
    private var todoDateView: some View {
        Text("\(todoDate)")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(.customWhite.opacity(0.5))
            .padding(.top, 8)
    }
    
    private var todoTextEditor: some View {
        TextEditor(text: $todoText)
            .focused($isTextTyping)
            .font(.system(size: 16, weight: .regular))
            .frame(maxHeight: .infinity)
            .foregroundStyle(isTextTyping ? .customWhite : .customWhite.opacity(0.5))
            .scrollContentBackground(.hidden)
            .background(Color.customBlack)
            .padding(.top, 16)
            .onChange(of: isTextTyping) { oldValue, newValue in
                if isTextTyping && todoModel == nil {
                    todoText = ""
                }
            }
    }
}



