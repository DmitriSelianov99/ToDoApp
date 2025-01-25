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
                    mainTitleView
                    
                    mainSearchView
                    
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
                
                mainFooterView
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

extension MainView {
    private var mainTitleView: some View {
        Text("_tasks")
           .foregroundStyle(.customWhite)
           .font(.system(size: 34, weight: .bold))
    }
    
    private var mainSearchView: some View {
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
    
    private var mainFooterView: some View {
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





