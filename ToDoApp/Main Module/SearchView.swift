//
// SearchView.swift
// ToDoApp


import SwiftUI

struct SearchView: View {
    
    @Binding var textfieldText: String
    @ObservedObject var vm: TodoViewModel
    
    var body: some View {
        ZStack {
            Color.customGray
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template)
                    .foregroundStyle(.customWhite.opacity(0.5))
                    .font(.system(size: 17, weight: .regular))
                
                TextField(text: $textfieldText) {
                    Text("_search")
                        .foregroundStyle(.customWhite.opacity(0.5))
                        .font(.system(size: 17, weight: .regular))
                }
                .foregroundStyle(.customWhite)
                
                Image(systemName: "mic.fill")
                    .renderingMode(.template)
                    .foregroundStyle(.customWhite.opacity(0.5))
                    .font(.system(size: 17, weight: .regular))
            }
            .padding()
        }
        .frame(height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: textfieldText) { oldValue, newValue in
            vm.findTodo(by: newValue)
        }
    }
}
