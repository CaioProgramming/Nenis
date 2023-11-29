//
//  UpdateDiaperViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 22/11/23.
//

import UIKit

protocol UpdateDiaperDelegate {
    func retrieveNewDiaper(diaper: Diaper)
    func retrieveUpdatedDiaper(diaper: Diaper)
    func deleteDiaper(diaper: Diaper)
}

class UpdateDiaperViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var diaperSizeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var diaperPickerView: UIPickerView!
    
    private var selectedDiaper: Diaper? = nil
   private var diaperSize: SizeType = .RN
   private var quantity = 1
   private var multiplier = 1
    var delegate: UpdateDiaperDelegate? = nil
    @IBOutlet var containerView: UIView!
  
    override func updateViewConstraints() {
                // they're now "cards"
                let TOP_CARD_DISTANCE: CGFloat = 50
                
        let height: CGFloat = containerView.wrapHeight()
           
                view.frame.size.height = height
                // reposition the view (if not it will be near the top)
                view.frame.origin.y = UIScreen.main.bounds.height - height - TOP_CARD_DISTANCE
                view.backgroundColor = UIColor.secondarySystemBackground
                view.roundedCorner(radius: 15)
                super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        diaperPickerView.delegate = self
        diaperPickerView.dataSource = self
        diaperPickerView.reloadAllComponents()
        if let diaper = selectedDiaper {
            quantity = diaper.quantity - diaper.discarded
            diaperSize = diaper.type.getDiaperSizeByDescription() ?? SizeType.RN
            
            let sizeIndex = SizeType.allCases.firstIndex(where: {size in
                size.description == diaper.type
            })
           
            if(quantity > 100) {
                quantity = 100
            }
            
            diaperPickerView.selectRow(quantity - 1, inComponent: DiaperComponents.count.getComponentIndex() ?? 0, animated: true)
            diaperPickerView.selectRow(sizeIndex ?? 0, inComponent: DiaperComponents.size.getComponentIndex() ?? 0, animated: true)
            
        }
        updateSelection()
    
    }
    
    func updateSelection() {
        amountLabel.text = "\(quantity * multiplier)"
        diaperSizeLabel.text = diaperSize.description
        diaperSizeLabel.textColor = diaperSize.color
      
    }
    
    func loadSelectedDiaper(diaper: Diaper) {
        selectedDiaper = diaper
    
    }

    @IBAction func deleteDiaper(_ sender: UIButton) {
        guard selectedDiaper == nil else { return }
        delegate?.deleteDiaper(diaper: selectedDiaper!)
    }
    
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveDiaper(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: { [self] in
            delegate?.retrieveNewDiaper(diaper: Diaper(type: diaperSize.description, quantity: (quantity * multiplier)))
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UpdateDiaperViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let customComponent = DiaperComponents.allCases[component]
        return customComponent.width
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return DiaperComponents.allCases.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let components = DiaperComponents.allCases
        if(component < components.count) {
            let component = DiaperComponents.allCases[component]
            return component.rows
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let component = DiaperComponents.allCases[component]
        return component.title
    }
    

    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let component = DiaperComponents.allCases[component]
        return NSAttributedString(string: component.title, attributes: [NSAttributedString.Key.foregroundColor:UIColor.label])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let components = DiaperComponents.allCases
        if(component < components.count) {
            let component = components[component]
            let pickerLabel = UILabel()
            pickerLabel.text = component.getLabelTitle(with: row)
            pickerLabel.font = component.getLabelFont()
            pickerLabel.textAlignment = component.getTextAlign()
            return pickerLabel
        }
        return UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let components = DiaperComponents.allCases
        let customComponent = components[component]
        
        if(customComponent == .count) {
            quantity = row + 1
        }
        
        if(customComponent == .size) {
            diaperSize = SizeType.allCases[row]
        }
        
        if(customComponent  == .type) {
            multiplier = row + 1
        }
        
        updateSelection()
    }
    
}



enum DiaperComponents : CaseIterable {
    case  type, typeDescription, count, quantityDescription,  size
    
    var title: String {
        get {
            return switch self {
            case .typeDescription: "pacotes"
            case .quantityDescription:
                "x"
            case .type:
                ""
            case .count:
                ""
            case .size:
                ""
            }
            
        }
    }
    
    var description: String {
        get {
            return switch self {
            case .type:
                "pacotes"
            case .count:
                "x"
            default:
                ""
            }
        }
    }
    
    var rows: Int {
        get {
           return switch self {
             
            case .type:
                10
            case .count:
                100
            case .size:
               SizeType.allCases.count
           default: 1

            }
        }
    }
    
    var width: CGFloat {
        get {
            return switch self {
            case .count, .quantityDescription:
                32
            case .type:
                24
            case .typeDescription:
                75
            case .size:
                50
            }
        }
    }
}


extension DiaperComponents {
    func getLabelTitle(with index: Int) -> String {
        return switch self {
        case .type:
            "\(index + 1)"
        case .count:
            "\(index + 1)"
        case .size:
            SizeType.allCases[index].description
            
        default: title
        }
    }
    
    func getLabelFont() -> UIFont {
        return switch self {
            
        case .count, .type, .size:
            UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: UIFont.Weight.medium)
        case .quantityDescription, .typeDescription:
            UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)

        }
    }
    
    func getTextAlign() -> NSTextAlignment {
        return switch self {
        case .count, .size, .type:
            NSTextAlignment.center
        case .quantityDescription, .typeDescription:
            NSTextAlignment.left
        }
    }
    
    func getComponentIndex() -> Int? {
        return DiaperComponents.allCases.firstIndex(where: { component in
                component == self
        })
    }
}
