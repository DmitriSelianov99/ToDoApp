//
// TodoListView.swift
// ToDoApp


import SwiftUI

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
        }
        .contextMenu(menuItems: {
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
        }, preview: {
            PreviewContextMenu(todoModel: $todoModel)
                .onAppear {
                    currentModel = todoModel
                    isTodoSelected = true
                }
//                .onDisappear {
//                    currentModel = nil
//                    isTodoSelected = false
//                }
        })
        .fullScreenCover(isPresented: $isEditingViewOpen, content: {
            NewTodoView(todoModel: currentModel!, vm: vm)
        })
    }
}

struct PreviewContextMenu: View {
    
    @Binding var todoModel: TodoModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(todoModel.title ?? "")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.customWhite)
            
            Text(todoModel.todo)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.customWhite)
            
            Text(todoModel.date?.formateDateToString() ?? "")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.customWhite.opacity(0.5))
                .lineLimit(2)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(.customGray)
    }
}
