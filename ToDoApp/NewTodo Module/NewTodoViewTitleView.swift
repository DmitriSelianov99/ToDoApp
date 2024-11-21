//
// NewTodoViewTitleView.swift
// ToDoApp


import SwiftUI

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
