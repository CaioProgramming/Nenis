//
//  VaccineHelper.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import Foundation

class VaccineHelper {
    
    func groupVaccines(with child: Child) -> [Status : [VaccineItem]] {
        
        let vaccines = Vaccine.allCases.map({ vaccine in
            return self.getVaccineItem(with: child, vaccine: vaccine)
        }).sorted(by: { firstItem, secondItem in
            firstItem.nextDate.compare(secondItem.nextDate) == .orderedAscending
        })
        
        let vaccineDictionary =  Dictionary(grouping: vaccines, by: { $0.status })
        
        return vaccineDictionary.filter({ dictionary in
                
           return !dictionary.value.isEmpty
            
        })
    }
    
    func filterVaccineStatus(with child: Child, status: Status) -> [VaccineItem] {
        return Vaccine.allCases.map({ vaccine in
            return self.getVaccineItem(with: child, vaccine: vaccine)
        }).filter({ vac in
            vac.status == status
        })
        
        
    }
    
    func getVaccineItem(with child: Child, vaccine: Vaccine) -> VaccineItem {
        
        let calendar = NSCalendar.current
        let birth = child.birthDate
        let currentDate = Date.now
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birth, to: currentDate)
        let months = components.month ?? 0
        
        let childVaccine = child.vaccines.first(where: { vaccination in
             vaccination.vaccine.caseInsensitiveCompare(vaccine.description) == .orderedSame
         })
        
        let currentDose = (childVaccine?.dose ?? 0)
        var periodIndex = currentDose
        
        if(currentDose == vaccine.periods.count) {
            periodIndex = vaccine.periods.count - 1
        }
        
        
        let vaccineMonth = vaccine.periods[periodIndex]
        let totalDoses = vaccine.periods.count

        
        
        let remainingDoses =  totalDoses - (currentDose + 1)
        var doseProgress = Double(remainingDoses)  / Double(totalDoses)
        
        let vaccineNextDate = birth.addMonth(month: vaccineMonth) ?? Date()
        var vaccineStatus: Status = .soon
        
        if(currentDose == 0) {
            doseProgress = 0
        }
        
        if(currentDose >= totalDoses) {
           vaccineStatus = .done
            doseProgress = 1
        } else if(vaccineMonth < months) {
            vaccineStatus = .late
        } else {
            vaccineStatus = .soon
        }
        
        print("Vaccine -> \(vaccine.description) progress -> \(doseProgress)")
        
        return VaccineItem(vaccine: vaccine, nextDate: vaccineNextDate, doseProgress: Float(doseProgress), status: vaccineStatus, nextDose: currentDose)
    }
    
}
extension Date {
    func addMonth(month: Int) -> Date? {

        let calendar = NSCalendar.current
        return calendar.date(byAdding: .month, value: month, to: self)
    }
}
