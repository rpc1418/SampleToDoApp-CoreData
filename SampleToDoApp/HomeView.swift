//
//  HomeView.swift
//  SampleToDoApp
//
//  Created by rentamac on 27/01/2026.
//

import SwiftUI

struct HomeView: View {

    @StateObject var vm = TodoHomeScreenVM()
    @State var title: String = ""
    @State var desc: String = ""
    @State var openAddTask: Bool = false
    @State var forEdit: Bool = false
    @State var editTaskEntity: ToDoTaskEntity? = nil
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                if vm.tasks.isEmpty {
                    Text("No Tasks Found")
                } else {
                    List {
                        ForEach(vm.tasks) { task in
                            HStack {
                                Text(task.title ?? "No Title")
                                Spacer()
                                if(task.isDone){
                                    Text("Completed")
                                        .foregroundStyle(.green)
                                }else{
                                    Text("Pending")
                                        .foregroundStyle(.red)
                                }
                            }
                                .contextMenu {
                                    Button {
                                        editTaskEntity=task
                                        title=task.title ?? "from edit default"
                                        desc=task.desc ?? "from edit default"
                                        forEdit=true
                                        openAddTask=true
                                    } label: {
                                        Label(
                                            "Edit Task",
                                            systemImage: "pencil"
                                        )
                                    }

                                    Button {
                                        task.isDone.toggle()
                                        vm.saveContext()
                                    } label: {
                                        if task.isDone {
                                            Label("Mark as Pending", systemImage: "arrow.uturn.left.circle.fill")
                                        } else {
                                            Label("Complete Task", systemImage: "checkmark.circle.fill")
                                        }
                                    }
                                    .tint(task.isDone ? .orange : .green)
                                    Button(role: .destructive) {
                                        vm.deleteTask(task)  // single-item delete
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }.onDelete(perform: vm.deleteTask)
                    }.listStyle(PlainListStyle())
                }
                if openAddTask {
                    VStack {
                        TextField("Give Title to your task", text: $title)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        TextField("Give desc to your task", text: $desc)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .cornerRadius(10)
                            .background(.gray.opacity(0.2))
                            .padding(.horizontal)
                        Button(
                            action: {
                                print("for edit \(forEdit)")
                                guard !title.isEmpty, !desc.isEmpty else {
                                    return
                                }
                                if(forEdit){
                                    editTaskEntity?.title=title
                                    editTaskEntity?.desc=desc
                                    vm.saveContext()
                                }else{
                                    vm.addTodoTask(title: title, description: desc)
                                }
                                
                                forEdit=false
                                title = ""
                                desc = ""
                            }
                        ) {
                            Text(forEdit ? "Update the Task" :"Add the Task")
                                .font(Font.headline.bold())
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .padding(.horizontal)

                        }
                    }
                    .padding(.top)
                    .background(.white)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .transition(.move(edge: openAddTask ? .bottom : .top))
                    .zIndex(1)

                }
            }
            .navigationTitle("ToDoList")
            .navigationBarItems(
                leading: Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        title = ""
                        desc = ""
                        forEdit=false
                        openAddTask.toggle()
                    }

                } label: {
                    Image(systemName: "plus")
                        .rotationEffect(.degrees(openAddTask ? 45 : 0))
                }
            )

            .navigationBarItems(
                trailing:
                    Button {
                        vm.fetchTodos()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
            )
        }
    }
}
