//
// ContentView.swift
// ToDoApp


import SwiftUI
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct MainView: View {
    
    @State var currentModel: TodoModel? = nil
    @State var textfieldText: String = ""
    @State var isNewTodoViewPresented: Bool = false
    @State var isTodoSelected: Bool = false
    @State var isEditingViewOpen: Bool = false
    
    @StateObject var vm = TodoViewModel()
    
    var body: some View {
        ZStack {
            
            Color.customBlack.ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    TitleView()
                    
                    SearchView(textfieldText: $textfieldText, vm: vm)
                    
                    ScrollView {
                        ForEach(vm.todos.indices, id: \.self) { index in
                            TodoListView(
                                currentModel: $currentModel,
                                todoModel: $vm.todos[index],
                                vm: vm,
                                isTodoSelected: $isTodoSelected, isEditingViewOpen: $isEditingViewOpen
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .fullScreenCover(isPresented: $isNewTodoViewPresented, content: {
                    NewTodoView(vm: vm)
                })
                
                FooterView(
                    vm: vm.coreDataVM,
                    isNewTodoViewPresented: $isNewTodoViewPresented
                )
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainView()
}





