//
// FooterView.swift
// ToDoApp


import SwiftUI

struct FooterView: View {
    
    @ObservedObject var vm: CoreDataTodoViewModel
    @Binding var isNewTodoViewPresented: Bool
    
    var body: some View {
        ZStack {
            
            Color.customGray.ignoresSafeArea()
            
            
            
            HStack {
                Rectangle()
                    .frame(width: 25, height: 25)
                    .hidden()
                
                Spacer()
                
                Text(String(format: NSLocalizedString("_some-tasks", comment: ""), "\(vm.todos.count)", "\(Customizations.customManager.russianTaskTale(with: vm.todos.count))"))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.customWhite)
                
                Spacer()
                
                Image(systemName: "square.and.pencil")
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.customYellow)
                    .onTapGesture {
                        isNewTodoViewPresented.toggle()
                    }
            }
            .padding(.horizontal, 20)
            
            
        }
        .frame(height: 50)
    }
}

