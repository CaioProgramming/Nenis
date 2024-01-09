//
//  StatusUpdateViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/01/24.
//

import UIKit

class StatusUpdateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet private weak var contentContainer: UIView!
    @IBOutlet private weak var statsSlider: UISlider!
    @IBOutlet private weak var statsLabel: UILabel!
    @IBOutlet private weak var navBar: UINavigationBar!
    var minDate: Date? = nil
    var metricDescription: String = ""
    var maxValue: Float = 20.0
    var saveClosure: ((Float, Date) -> Void)? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem?.title = self.title
        statsSlider.maximumValue = maxValue
        statsSlider.value = statsSlider.minimumValue
        sliderUpdate(statsSlider)
        datePicker.minimumDate = minDate
        // Do any additional setup after loading the view.
    }
 
    @IBAction func saveStats(_ sender: UIButton) {
        guard let closure = saveClosure else {
            return
        }
        self.dismiss(animated: true, completion: { [self] in
            closure(statsSlider.value, datePicker.date)
        })
        
    }
    
    @IBAction func sliderUpdate(_ sender: UISlider) {
        let formattedValue = String(format: "%.2f", sender.value)
        statsLabel.text = "\(formattedValue) \(metricDescription)"
    }
    
    override func updateViewConstraints() {
                // they're now "cards"
                let TOP_CARD_DISTANCE: CGFloat = 50
                
        let height: CGFloat = contentContainer.wrapHeight() * 2
           
                view.frame.size.height = height
                // reposition the view (if not it will be near the top)
                view.frame.origin.y = UIScreen.main.bounds.height - height - TOP_CARD_DISTANCE
                view.backgroundColor = UIColor.secondarySystemBackground
                view.roundedCorner(radius: 15)
                super.updateViewConstraints()
    }
    
}



