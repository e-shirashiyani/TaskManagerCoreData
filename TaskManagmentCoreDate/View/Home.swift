//
//  Home.swift
//  TaskManagment
//
//  Created by e.shirashiyani on 1/21/22.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel : TaskViewModel = TaskViewModel()
    @Namespace var animation
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editButton

    var body: some View {
        

        ScrollView(.vertical,showsIndicators: false){
            //lazy stack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]){
                
                Section{
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:10){
                            ForEach(taskModel.currentWeek,id: \.self){day in
                                
                                VStack(spacing:10){
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Text(taskModel.extractDate(date: day, format: "EEE "))
                                        .font(.system(size: 14))
                                    
                                    Capsule()
                                        .fill(.white)
                                        .frame(width: 8, height: 8 )
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                .frame(width:45,height: 90)
                                .background(
                                    ZStack{
                                        if taskModel.isToday(date: day){
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation )
                                        }
                                    })
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation{
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                    TaskView()
                }header: {
                    HeaderView()
                }
                
            }
        }
        .ignoresSafeArea(.container,edges: .top)
        //add button
        .overlay(
            Button(action: {
                taskModel.addNewTask.toggle()
            }, label:{
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black,in:Circle())
            })
                .padding()
            
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask){
            taskModel.editTask=nil
        } content : {
            NewTask()
                .environmentObject(taskModel)
        }
            
    }
    
    func TaskView()-> some View{
        
        LazyVStack(spacing:20){
            DynamicFilteredView(dataToFilter: taskModel.currentDay) { (object : Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
        //updating tasks
       
    }
    
    func TaskCardView(task:Task)->some View{
        
        HStack(alignment : editButton?.wrappedValue == .active ? .center : .top, spacing: 30){
            
            //if edit mode enabled then showing delete button
            if editButton?.wrappedValue == .active{
                
                VStack(spacing:10){
                    
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        
                        Button{
                            taskModel.editTask = task
                            taskModel.addNewTask.toggle()
                        }label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                Button{
                    
                    //deleting task
                    context.delete(task)
                    
                    try? context.save()
                }label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                
            }
            }
            else{
                
                VStack(spacing : 10){
                    Circle()
                        .fill(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ?(task.isCompleted ? .green : .black) : .clear)
                        .frame(width: 15, height: 15)
                        .background(
                        
                        Circle()
                            .stroke(.black,lineWidth: 1)
                            .padding(-3)
                        )
                        .scaleEffect(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width:3)
                }
            }
            
            VStack{
                HStack(alignment: .top, spacing:10){
                    VStack(alignment: .leading, spacing: 12){
                        
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        
                        Text(task.taskDescription ?? "" )
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                }
                
                if taskModel.isCurrentHour(date: task.taskDate ?? Date() ){
                    //Team members
                    HStack(spacing:12){
                       
                        //check button
                        if !task.isCompleted{
                            Button{
                                //updating status
                                task.isCompleted=true
                                
                                // saving
                                try? context.save()
                            }label:{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    .background(Color.white,in: RoundedRectangle(cornerRadius: 10 ))
                                
                            }
                        }
                        
                        Text(task.isCompleted ? " Marked as a completed " : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16,weight: .light))
                            .foregroundColor(task.isCompleted ? .gray : .white)
                            .hLeading()
                    }
                    .padding(.top)
                }
                
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0 )
            .padding(.bottom,taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background(
            Color("Black")
                .cornerRadius(25)
                .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0))
        
        }
        .hLeading()
    }
     
    func HeaderView()->some View{
        
        
        HStack(spacing:10){
            VStack(alignment: .leading, spacing: 10){
                
            
            Text(Date().formatted(date:.abbreviated,time:.omitted))
                .foregroundColor(.gray)
            
            Text("Today")
                .font(.largeTitle.bold())
        }
            .hLeading()
            
           
        }
        .padding()
        .padding(.top,getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View{
    
    func hLeading()-> some View{
        self
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    
    func hTrailing()-> some View{
        self
            .frame(maxWidth:.infinity,alignment: .trailing)
    }
    
    func hCenter()-> some View{
        self
            .frame(maxWidth:.infinity,alignment: .center)
    }
    
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea=screen.windows.first?.safeAreaInsets else{
            return .zero

        }
        return safeArea
    }
}
