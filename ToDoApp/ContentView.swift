//
// ContentView.swift
// ToDoApp


import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            Color.customBlack.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10.0) {
                TitleView()
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
}

struct TitleView: View {
    var body: some View {
         Text("_tasks")
            .foregroundStyle(.customWhite)
            .font(.system(size: 34, weight: .bold))
    }
}
