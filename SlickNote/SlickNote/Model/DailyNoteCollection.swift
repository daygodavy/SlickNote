//
//  DailyNoteCollection.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/22/23.
//

import Foundation

class DailyNoteCollection {
    var dailyNotes: [DailyNote] = []
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
}
