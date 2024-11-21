//
// TitleView.swift
// ToDoApp


import SwiftUI

struct TitleView: View {
    var body: some View {
         Text("_tasks")
            .foregroundStyle(.customWhite)
            .font(.system(size: 34, weight: .bold))
    }
}

#Preview {
    TitleView()
}
