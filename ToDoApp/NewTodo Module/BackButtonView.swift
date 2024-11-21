//
// BackButtonView.swift
// ToDoApp


import SwiftUI

struct BackButtonView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var vm: TodoViewModel
    @Binding var titleText: String
    @Binding var todoText: String
    var todoModel: TodoModel?
    
    @State var showAlert = false
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .renderingMode(.template)
                .bold()
            
            Text("_back")
            
            Spacer()
        }
        .font(.system(size: 16, weight: .regular))
        .foregroundStyle(.customYellow)
        .onTapGesture {
            
            if (titleText.isEmpty || todoText.isEmpty) {
                showAlert.toggle()
            } else {
                if let model = todoModel {
                    vm.coreDataVM.editTodo(for: model.id, title: titleText, text: todoText)
                } else {
                    vm.coreDataVM.addTodo(TodoModel(id: vm.getLastTodoId() + 1, title: titleText, todo: todoText, completed: false, userId: 69, date: Date()))
                }
                
                vm.getTodosFromDB()
                
                dismiss()
            }
        }
        .alert(isPresented: $showAlert) {
            getAlert()
        }

    }
}

extension BackButtonView {
    func getAlert() -> Alert {
        return Alert(
            title: Text("_attention"),
            message: Text("_empty-fileds"),
            primaryButton: .destructive(Text("_delete"), action: {
                dismiss()
            }),
            secondaryButton: .cancel()
        )
    }
}
