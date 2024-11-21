//
// NewTodoViewDateView.swift
// ToDoApp


import SwiftUI

struct NewTodoViewDateView: View {
    
    @Binding var todoDate: String
    
    var body: some View {
        Text("\(todoDate)")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(.customWhite.opacity(0.5))
            .padding(.top, 8)
    }
}
