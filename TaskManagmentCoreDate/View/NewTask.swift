//
//  NewTask.swift
//  TaskManagmentCoreDate
//
//  Created by e.shirashiyani on 2/4/22.
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    @State var taskTitle:String=""
    @State var taskDescription:String=""
    @State var taskDate:Date=Date()
    @EnvironmentObject var taskModel : TaskViewModel
    @Environment(\.managedObjectContext) var context
    var body: some View {
        
        NavigationView{
            List{
                
                Section{
                    TextField("Go to Work", text: $taskTitle)
                }header: {
                    Text("Task Title ")
                }
                
                Section{
                    TextField("Nothing", text: $taskDescription)
                }header: {
                    Text("Task Description ")
                }
                
                if taskModel.editTask == nil{
                    
                    Section{
                        DatePicker("",selection: $taskDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                        
                    }header: {
                        Text("Task Date ")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            //disable to dismiss
            .interactiveDismissDisabled()
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                       
                        if let task = taskModel.editTask{
                            
                            task.taskTitle=taskTitle
                            task.taskDescription=taskDescription
 
                        }else{
                            
                            let task=Task(context: context)
                            task.taskTitle=taskTitle
                            task.taskDescription=taskDescription
                            taskDate=taskDate
                        }
                        
                        try? context.save()
                        dismiss()
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
            //loading task data if from task edit
            .onAppear{
                if let task = taskModel.editTask{
                    taskTitle = task.taskTitle ?? ""
                    taskDescription = task.taskDescription ?? ""
                    
                }
            }
        }
    }
}

