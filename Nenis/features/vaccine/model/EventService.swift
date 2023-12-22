//
//  EventService.swift
//  Nenis
//
//  Created by Caio Ferreira on 21/12/23.
//

import Foundation
import EventKit
import os

class EventService {
    
    private let eventStore = EKEventStore()
    
    
    @available(iOS 17.0, *)
    func addEvent(
        identifier: String,
        title: String,
                  note: String,
                  date: Date,
                  onSuccess: @escaping () -> Void,
                  onFailure: @escaping () -> Void) {
        
        eventStore.requestWriteOnlyAccessToEvents(completion: { (granted, error) in
            
            guard granted == true && error == nil else {
                onFailure()
                Logger().error("event error => \(String(describing: error))")
                return
            }
            let event = EKEvent(eventStore: self.eventStore)
            
            let calendar = NSCalendar.current
            let startDate = calendar.date(bySettingHour: 09, minute: 00, second: 00, of: date)
            let endDate = calendar.date(bySettingHour: 12, minute: 30, second: 00, of: date)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.availability = EKEventAvailability.busy
        
            event.notes = note
            
            // STEP 3
            let alarmDate = calendar.date(bySettingHour: 08, minute: 30, second: 0, of: date)
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            let alarm = EKAlarm(relativeOffset: -600 * 3)
            event.addAlarm(alarm)
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
                // STEP 5
                onSuccess()
            } catch {
                print("Error saving event: \(error.localizedDescription)")
                onFailure()
            }
            
        })
    }
}
