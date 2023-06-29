//
//  Date.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/29/23.
//

import Foundation

struct DateUtil {
    static var startOfToday: Date {
        return Calendar.current.startOfDay(for: Date())
    }

    static var startOfYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: startOfToday) ?? Date()
    }
    
    static func startOfDate(_ date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    static func endOfDate(_ date: Date) -> Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? Date()
    }
}
