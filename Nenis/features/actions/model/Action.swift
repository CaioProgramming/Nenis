//
//  Activity.swift
//  Nenis
//
//  Created by Caio Ferreira on 07/09/23.
//

import Foundation
import UIKit

struct Action : Codable {
    let description: String
    let type: String
    let time: Date
}

enum ActionType: Codable, CaseIterable {

  case sleep, bath, exercise, feed
  var description: String { get { return "\(self)".uppercased() } }
  var emoji: String {
        get {
            switch self {
            case .bath: return "🚾"
            case .sleep: return "💤"
            case .exercise: return "🚼"
            case .feed: return "🥕"
            }
        }
    }
    var title: String {
        get {
           switch self {
            case .sleep: return "Dormir"
            case .bath: return "Banheiro"
            case .exercise: return "Exercício"
            case .feed: return "Alimentaçao"
            }
        }
    }
    
    var cellImage: UIImage?  {
        get {
            switch self {
            case .sleep: return UIImage(systemName: "powersleep")
            case .bath: return UIImage(systemName:  "bathtub.fill")
            case .exercise: return UIImage(systemName: "figure.run")
            case .feed: return UIImage(systemName: "carrot.fill")
            }
        }
    }
    
    var imageTint: UIColor {
        
        get {
            switch self {
                
            case .sleep: return #colorLiteral(red: 0.6598719587, green: 0.5069644535, blue: 0.9686274529, alpha: 1) 
            case .bath: return #colorLiteral(red: 0.4140695331, green: 0.5963088957, blue: 0.9172512755, alpha: 1)
            case .exercise: return  #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            case .feed: return #colorLiteral(red: 0.8749734269, green: 0.524994685, blue: 0.3914501651, alpha: 1)
            }
        }
    }
}

extension String {
    func getAction() -> ActionType? {
        let cases = ActionType.allCases
        print("Querying action \(self)")
        return cases.first(where: { element in
            return element.description.caseInsensitiveCompare(self) == .orderedSame
      })
    }
}
extension Action {
    func formatDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self.time)
    }
}

