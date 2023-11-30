//
//  SettingDetailViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 30/11/23.
//

import UIKit

class SettingDetailViewController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    var child: Child? = nil
    var option: Option? = nil
    var viewModel = SettingDetailViewModel()
    var sections: [any Section] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.setupDetail(with: child, option: option)
        if let selectedOption = option {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.title = selectedOption.title

        }
        // Do any additional setup after loading the view.
    }

}

extension SettingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.numberOfRows()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sections[indexPath.section].dequeueCell(with: tableView, indexPath: indexPath)
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].dequeueHeader(with: tableView, sectionIndex: section) as? UIView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].dequeueFooter(with: tableView, sectionIndex: section) as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight()
    }
    
}

extension SettingDetailViewController : DetailProtocol {
    
    func retrieveSections(_ sections: [any Section]) {
        self.sections = sections
        sections.registerAllSectionsToTableView(detailsTableView)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.reloadData()
    }
    
    func retrieveNewInfo(extraData: ExtraData) {
        
    }
    
    func requestNewInfo() {
        
    }
    
    
}
