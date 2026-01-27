//
//  TodoHomeScreenVM.swift
//  SampleToDoApp
//
//  Created by rentamac on 27/01/2026.
//
import Combine
import CoreData

class TodoHomeScreenVM: ObservableObject {
      let container: NSPersistentContainer
    @Published var tasks: [ToDoTaskEntity] = []
    
    init(){
        container=NSPersistentContainer(name: "ToDoContainer")
        container.loadPersistentStores { Description, error in
            if let error=error {
                print("error loading the core data....!\(error)")
            }else{
                print("connected to the core data")
            }
        }
        fetchTodos()
    }
    
    
    func fetchTodos(){
        let request = NSFetchRequest<ToDoTaskEntity>(entityName: "ToDoTaskEntity")
        
        do{
            tasks=try container.viewContext.fetch(request)
        }catch let error{
            print("print the error \(error)")
        }
    }
    
    func addTodoTask(title: String, description: String){
        let newTodo=ToDoTaskEntity(context: container.viewContext)
        newTodo.title=title
        newTodo.isDone=false
        newTodo.desc=description
        saveContext()
    }
    
    func deleteTask(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        let entity = tasks[index]
        container.viewContext.delete(entity)
        saveContext()
    }
    
    func deleteTask(_ task: ToDoTaskEntity) {
        container.viewContext.delete(task)
        saveContext()
    }
    
   

    
    func saveContext(){
        do{
            try container.viewContext.save()
            fetchTodos()
        }catch let error{
            print("error saving the context \(error)")
        }
    }
    
}
