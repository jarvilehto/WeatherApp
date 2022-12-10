//
//  CalendarRow.swift
//  Weather
//
//  Created by iosdev on 9.12.2022.
//

import SwiftUI

struct CalendarRowView: View {
    let calendarEvent: CalendarEvent
    let weather: [WeatherStatus]
    private var w: WeatherStatus
    
    init(calendarEvent: CalendarEvent, weather: [WeatherStatus]) {
        self.calendarEvent = calendarEvent
        self.weather = weather
        
        var closestIdx: Int = 0
        var prevDiff: Double = 999999999.0
        for (idx, w) in weather.enumerated() {
            let diff = w.date?.distance(to: calendarEvent.startDate)
            if abs(diff!) < prevDiff {
                prevDiff = diff!
                closestIdx = idx
            }
        }
        self.w = weather[closestIdx]
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(calendarEvent.title)
                Text(calendarEvent.place)
                Text(calendarEvent.startDate.formatted())
            }
            Spacer()
            VStack(alignment: .trailing) {
                Image(systemName: w.symbol!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40)
                Text(String(format: "%.1f°C", w.temperature!))
            }
        }
        .padding(10)
        .background(.teal)
        .frame(maxWidth: .infinity)
        .shadow(radius: 10)
        .cornerRadius(10)
    }
}
