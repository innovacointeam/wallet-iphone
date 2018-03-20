//
//  DateFormatter+extension.swift
//  pbios
//
//  Created by Yuri Drigin on 08.06.17.
//  Copyright © 2017 swisstech. All rights reserved.
//

import Foundation


extension DateFormatter {
    
    /// Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
    ///
    /// - Parameters:
    ///   - from: The date to process.
    ///   - numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
    /// - Returns: A string with formatted `date`.
    func timeSince(from: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = now > from ? from : now
        let latest = now > from ? now : from
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute], from: earliest, to: latest)
        
        var result = ""
        
        if let year = components.year, year >= 2 {
            result = "\(year) " + "years ago"
        } else if let year = components.year, year >= 1 {
            if numericDates {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if let month = components.month, month >= 2 {
            result = "\(month) " + "months ago"
        } else if let month = components.month, month >= 1 {
            if numericDates {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if let weekOfYear = components.weekOfYear, weekOfYear >= 2 {
            result = "\(weekOfYear) " + "weeks ago"
        } else if let weekOfYear = components.weekOfYear, weekOfYear >= 1 {
            if numericDates {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if let day = components.day, day >= 2 {
            result = "\(day) " + "days ago"
        } else if let day = components.day, day >= 1 {
            if numericDates {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if let hour = components.hour, hour >= 2 {
            result = "\(hour) " + "hours ago"
        } else if let hour  = components.hour, hour >= 1 {
            if numericDates {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if let minutes = components.minute, minutes > 1 {
            result = "\(minutes)" + " minutes ago"
        } else {
            result = "Recently"
        }
        return result
    }
}
