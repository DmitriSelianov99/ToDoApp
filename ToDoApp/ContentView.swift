//
// ContentView.swift
// ToDoApp


import SwiftUI

struct ContentView: View {
    
    @State var textfieldText: String = ""
    
    var body: some View {
        ZStack {
            
            Color.customBlack.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10.0) {
                TitleView()
                
                SearchView(textfieldText: $textfieldText)
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

struct SearchView: View {
    
    @Binding var textfieldText: String
    
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
    }
}
