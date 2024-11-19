//
// ContentView.swift
// ToDoApp


import SwiftUI




struct ContentView: View {
    
    @State var textfieldText: String = ""
    
    @StateObject var vm = TodoViewModel()
    
    var body: some View {
        ZStack {
            
            Color.customBlack.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10.0) {
                TitleView()
                    .onTapGesture {
                        vm.getTodos()
                    }
                
                SearchView(textfieldText: $textfieldText)
                
                ScrollView {
                    ForEach(vm.todos.indices, id: \.self) { index in
                        TodoListView(todoModel: $vm.todos[index])
                    }
                }
                
                FooterView(totalTasks: $vm.total)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
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


struct TodoListView: View {
    
    @Binding var todoModel: TodoModel
    
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
                    } else {
                        Text("_no-title")
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
                DispatchQueue.global().async {
                    todoModel.changeTodoStatus()

                }
            }
            
            Rectangle()
                .fill(.customWhite.opacity(0.5))
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
        }
    }
}

struct FooterView: View {
    
    @Binding var totalTasks: Int
    
    var body: some View {
        ZStack {
            
            Color.customGray.ignoresSafeArea()
            
            
            
            HStack {
                Rectangle()
                    .frame(width: 25, height: 25)
                    .hidden()
                
                Spacer()
                
                Text("\(totalTasks) _some-tasks")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.customWhite)
                
                Spacer()
                
                Image(systemName: "square.and.pencil")
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.customYellow)
            }
            .padding(.horizontal, 20)
            
            
        }
        .frame(height: 50)
    }
}
