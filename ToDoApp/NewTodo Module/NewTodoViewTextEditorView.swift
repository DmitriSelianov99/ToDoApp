//
// NewTodoViewTextEditorView.swift
// ToDoApp


import SwiftUI

struct NewTodoViewTextEditorView: View {
    
    @Binding var todoText: String
    @FocusState var isTextTyping: Bool
    
    var todoModel: TodoModel?
    
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
                if isTextTyping && todoModel == nil {
                    todoText = ""
                }
            }
    }
}
