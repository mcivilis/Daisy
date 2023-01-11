//
//  Date+Helpers.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-07.
//

import Foundation

extension Date {
    static func preview(_ date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return formatter.date(from: date) ?? .now
    }
    
    func daisy() -> String {
        let relativeDateFormatter = RelativeDateTimeFormatter()
        relativeDateFormatter.dateTimeStyle = .named
        relativeDateFormatter.formattingContext = .standalone
        return relativeDateFormatter.localizedString(for: self, relativeTo: .now)
    }
    
    func display() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
