//
//  ContentView.swift
//  Calendar
//
//  Created by Teemu on 9.12.2022.
//

import SwiftUI
import EventKit

class CalendarEvent: Identifiable, ObservableObject {
    let id = UUID()
    let place: String
    let title: String
    let startDate: Date

    init(place: String, title: String, startDate: Date) {
        self.place = place
        self.title = title
        self.startDate = startDate
    }
}

struct CalendarView: View {
    @EnvironmentObject var fmi: FMI
    let eventStore = EKEventStore()
    @State var calendarEvents: [CalendarEvent] = []
    
    var body: some View {
        List {
            ForEach(calendarEvents) { e in
                if let weather = fmi.data[e.place] {
                    CalendarRowView(calendarEvent: e, weather: weather)
                }
            }
        }
        .onAppear {
            getCalendar()
            for e in calendarEvents {
                if fmi.data[e.place] == nil {
                    fmi.getForecast(place: e.place)
                }
            }
        }
    }
}

extension CalendarView {
    func getEvents() {
        calendarEvents = []
        for calendar in eventStore.calendars(for: .event) {
            let predicate = eventStore.predicateForEvents(
                withStart: Date(),
                end: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                calendars: [calendar]
            )
            let events = eventStore.events(matching: predicate)
            for event in events {
                if let place = event.location?.components(separatedBy: "\n")[0] {
                    calendarEvents.append(CalendarEvent(
                        place: place,
                        title: event.title,
                        startDate: event.startDate
                    ))
                }
            }
        }
    }
    
    func getCalendar() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
        case .authorized:
            getEvents()
        case .denied:
            print("Access denied")
        case .notDetermined:
            requestAccess()
        default:
            break
        }
    }
    
    func requestAccess() {
        eventStore.requestAccess(to: EKEntityType.event) { granted, error in
            if let error = error {
                print(error)
                return
            }
            
            if granted {
                getEvents()
            }
        }
    }
}


