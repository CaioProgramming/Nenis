//
//  VaccineHelper.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import Foundation

class VaccineHelper {
    
    
    func getVaccineItem(with child: Child, vaccine: Vaccine) -> VaccineItem {
        
        let calendar = NSCalendar.current
        let birth = child.birthDate
        let currentDate = Date.now
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birth, to: currentDate)
       
        let year = components.year ?? 0
        let weeks = components.weekOfYear ?? 0
        let days = components.day ?? 0
        let months = components.month ?? 0
        
        let childVaccine = child.vaccines.first(where: { vaccination in
             vaccination.vaccine.caseInsensitiveCompare(vaccine.description) == .orderedSame
         })
        
        let currentDose = (childVaccine?.dose ?? 0)
        let nextPeriod = currentDose + 1
        var periodIndex = nextPeriod - 1
        
        if(currentDose == vaccine.periods.count) {
            periodIndex = vaccine.periods.count - 1
        }
        let vaccinePeriod = vaccine.periods[periodIndex]
        let doseProgress = Float(currentDose / vaccine.periods.count)
        let vaccineNextDate = birth.addMonth(month: vaccinePeriod)
        var vaccineStatus: Status = .soon
        
        if(currentDose == vaccine.periods.count) {
           vaccineStatus = .done
        } else if(vaccinePeriod < months) {
            vaccineStatus = .late
        } else if(vaccinePeriod == months) {
            vaccineStatus = .soon
        }
        
        
        return VaccineItem(vaccine: vaccine, nextDate: vaccineNextDate?.formatted(date: .abbreviated, time: .omitted) ?? "-", doseProgress: doseProgress, status: vaccineStatus, nextDose: nextPeriod)
    }
    
}
