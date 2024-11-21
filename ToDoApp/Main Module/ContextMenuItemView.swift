//
// ContextMenuItemView.swift
// ToDoApp


import SwiftUI

struct ContextMenuItemView: View {
    
    let text: LocalizedStringResource
    let image: String
    
    var body: some View {
        HStack {
            Text(text)
            Image(systemName: image)
                .renderingMode(.template)
        }
        .font(.system(size: 17, weight: .regular))
    }
}
