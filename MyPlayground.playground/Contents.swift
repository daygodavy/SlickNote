//
//  DateUtil.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/27/23.
//

import Foundation

extension Date {
//    var beginningOfDay: Date {
////        Calendar.current.date(bySetting: 0, value: 0, of: self) ?? Date()
//        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? Date()
//    }
    
    func getStartOfDay() -> Date {
        let calendar = Calendar.current
        let timeZone = TimeZone.current
        print(timeZone)
        var dateComponents = calendar.dateComponents(in: timeZone, from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        print(dateComponents)
        print(calendar.date(from: dateComponents))
        print("!!!!!!!!")
        
//        let year = dateComponents.year
//        let month = dateComponents.month
//        let day = dateComponents.day
//        let hour = dateComponents.hour
//        let minute = dateComponents.minute
//        let second = dateComponents.second
        
        
        guard let newDate = calendar.date(from: dateComponents) else { return Date() }
        return newDate
    }
    
//    func getEndOfDay(_ currentDate: Date) -> Date {
//        let calendar = Calendar.current
//        let timeZone = TimeZone.current
//        let dateComponents = calendar.dateComponents(in: timeZone, from: currentDate)
//
//
//
//        return Date()
//    }
}

let currentDate = Date()
print(currentDate)
print("======")
print(Calendar.current.startOfDay(for: .now))
//print(Calendar.current.startOfDay(for: Date()))
//
print(Calendar.current.date(byAdding: .day, value: 1, to: currentDate))



func compareDates(date1: Date, date2: Date){
    switch date1 {
    case date2:
        print("date1 and date2 represent the same point in time")
    case ...date2:
        print("date1 is earlier in time than date2")
    case date2...:
        print("date1 is later in time than date2")
    default:
        return
    }
}

let date = Date() // 1971-01-01 00:00:00
let timeZone1 = TimeZone(secondsFromGMT: 60 * 60 * -8)! // Berlin
//let start1 = startOfDayIn(date: date, timeZone: timeZone1)
let timeZone2 = TimeZone(secondsFromGMT: 60 * 60 * -5)! // New York City
//let start2 = startOfDayIn(date: date, timeZone: timeZone2)

func adjustedStartOfDayIn(date: Date, timeZone: TimeZone) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = timeZone
    let correctDay = date.addingTimeInterval(TimeInterval(-calendar.timeZone.secondsFromGMT()))
    return calendar.startOfDay(for: correctDay)
}

let correctStart1 = adjustedStartOfDayIn(date: date, timeZone: timeZone1)
let correctStart2 = adjustedStartOfDayIn(date: date, timeZone: timeZone2)

compareDates(date1: correctStart1, date2: correctStart1)

print(date)
var calender = Calendar.current
//let timezone = TimeZone.current
//let thisday = date.addingTimeInterval(TimeInterval(-calender.timeZone.secondsFromGMT()))
//calender.startOfDay(for: thisday)

let thisday1 = date
//calender.timeZone = timezone
let today = calender.startOfDay(for: thisday1)
let nextday = calender.date(byAdding: .day, value: 1, to: today)
let endtoday = calender.date(bySettingHour: 23, minute: 59, second: 59, of: today)

