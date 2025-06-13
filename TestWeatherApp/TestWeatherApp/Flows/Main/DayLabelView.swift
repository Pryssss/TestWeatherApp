//
//  DayLabelView.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 14.06.2025.
//
import SwiftUI

struct DayLabelView: View {
    let rawDate: String

    var body: some View {
        Text(Self.displayDay(from: rawDate))
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    private static func displayDay(from rawDate: String) -> String {
        guard let date = dateFormatter.date(from: rawDate) else { return rawDate }
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else {
            return weekdayFormatter.string(from: date)
        }
    }
}
