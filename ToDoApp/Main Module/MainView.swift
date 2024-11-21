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


struct TodoListView: View {
    
    @Binding var currentModel: TodoModel?
    @Binding var todoModel: TodoModel
    @ObservedObject var vm: TodoViewModel
    
    @Binding var isTodoSelected: Bool
    @Binding var isEditingViewOpen: Bool
    
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: todoModel.completed ? "checkmark.circle" : "circle")
                    .foregroundStyle(todoModel.completed ? .customYellow : .customStroke)
                    .opacity(isTodoCurrent() ? 0 : 1)
                
                VStack(alignment: .leading, spacing: 6.0) {
                    if let title = todoModel.title {
                        Text(title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(todoModel.completed ? .customWhite.opacity(0.5) : .customWhite)
                            .overlay(alignment: .leading) {
                                Rectangle()
                                    .fill(.customWhite.opacity(0.5))
                                    .frame(height: 1)
                                    .frame(maxWidth: todoModel.completed ? .infinity : 0)
                                    .animation(.easeOut, value: todoModel.completed)
                            }
                    } else {
                        Text("Default title")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(todoModel.completed ? .customWhite.opacity(0.5) : .customWhite)
                            .overlay(alignment: .leading) {
                                Rectangle()
                                    .fill(.customWhite.opacity(0.5))
                                    .frame(height: 1)
                                    .frame(maxWidth: todoModel.completed ? .infinity : 0)
                                    .animation(.easeOut, value: todoModel.completed)
                            }
                    }
                    
                    Text(todoModel.todo)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(todoModel.completed ? .customWhite.opacity(0.5) : .customWhite)
                    
                    if let date = todoModel.date {
                        Text(date.formateDateToString())
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.customWhite.opacity(0.5))
                    } else {
                        Text(Date().formateDateToString())
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.customWhite.opacity(0.5))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            .onTapGesture {
                todoModel.changeTodoStatus()
                vm.coreDataVM.toggleCompleted(for: todoModel.id)
            }
            
            Rectangle()
                .fill(.customWhite.opacity(0.5))
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .opacity(isTodoCurrent() ? 0 : 1)
        }
        .background(isTodoCurrent() ? .customGray : .clear)
        .clipShape(RoundedRectangle(cornerRadius: isTodoCurrent() ? 10 : 0))
        .padding(.horizontal, isTodoCurrent() ? 20 : 0)
        .contextMenu(ContextMenu(menuItems: {
            Button {
                isEditingViewOpen = true
            } label: {
                ContextMenuItemView(text: "_edit", image: "square.and.pencil")
            }
            
            Button {
                
            } label: {
                ContextMenuItemView(text: "_share", image: "square.and.arrow.up")
            }
            
            Divider()
            
            Button(role: .destructive) {
                vm.deleteTodo(for: todoModel.id)
            } label: {
                ContextMenuItemView(text: "_delete", image: "trash")
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    currentModel = todoModel
                    isTodoSelected = true
                }
            })
        }))
        .fullScreenCover(isPresented: $isEditingViewOpen, content: {
            NewTodoView(todoModel: currentModel!, vm: vm)
        })
    }
    
    func isTodoCurrent() -> Bool {
        return isTodoSelected && (currentModel == todoModel)
    }
}

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
                
//                Text("\(vm.todos.count) _some-tasks\(Customizations.customManager.russianTaskTale(with: vm.todos.count))")
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
