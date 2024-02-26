//
//  DateHelper.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import Foundation

enum Weekday: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

class DateHelper {
    // 현재 날짜 가져오기
    static func getNowDate() -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: nowDate)
    }
    
    // 날짜 원하는 포맷으로 가져오기
    static func getDate(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    // 해당 포맷으로 변환해서 가져오기
    static func convertDateStringFormat(dateString: String, dateFormat: String, convertDateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = convertDateFormat
            let formattedDateString = dateFormatter.string(from: date)
            return formattedDateString
        } else {
            return dateString
        }
    }
    
    // 지난 주말 날짜 가져오기
    static func getLastWeekDate() -> Date {
        let currentDate = Date()
        let calendar = Calendar.autoupdatingCurrent
        
        var pastWeekDate: Date?
        
        var iterator = 1
        while pastWeekDate == nil {
            let pastDate = calendar.date(byAdding: .day, value: -(iterator), to: currentDate)!
            let weekday = calendar.component(.weekday, from: pastDate)

            if weekday == Weekday.sunday.rawValue || weekday == Weekday.saturday.rawValue {
                pastWeekDate = pastDate
            }
            
            iterator += 1
        }
        
        return pastWeekDate != nil ? pastWeekDate! : currentDate
    }
}
