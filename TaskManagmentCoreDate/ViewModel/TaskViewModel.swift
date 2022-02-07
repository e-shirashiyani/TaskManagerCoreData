//
//  TaskViewModel.swift
//  TaskManagment
//
//  Created by e.shirashiyani on 1/21/22.
//

import SwiftUI

class TaskViewModel : ObservableObject{

    
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var filteredTasks: [Task]?
    @Published var addNewTask:Bool = false
    @Published var editTask:Task? 

    init(){
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek(){
        
        let today=Date()
        let calender=Calendar.current
        
        let week=calender.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay=week?.start else{  
            return
        }
        (1...7).forEach {day in
                        
            if let weekday=calender.date(byAdding: .day, value: day,to: firstWeekDay){
            currentWeek.append(weekday)
            }
            
        }
    }
    // extract date
    func extractDate(date:Date,format:String) -> String{
    
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
        
    }
    
    func isToday(date : Date)->Bool{
        let calender=Calendar.current
        return calender.isDate(currentDay, inSameDayAs: date)
    }
    
    
    func isCurrentHour(date: Date)->Bool{
        let calender = Calendar.current
        let hour = calender.component(.hour, from: date)
        let currentHour = calender.component(.hour, from: Date())
        let isToday = calender.isDateInToday(date)
        return (hour == currentHour && isToday)

    }
}


