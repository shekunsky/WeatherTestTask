//
//  SearchCityTableViewController.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

class SearchCityTableViewController: BaseSearchTableViewController {
    
    var countryCode: String?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select City"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCities()
    }
    
    private func getCities() {
        if let code = countryCode {
            view.loadingIndicator(true)
            currentArray = getCitiesForCountry(code: code)
            createTableData(wordList: (currentArray)!)
            view.loadingIndicator(false)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = tableViewSource[tableViewHeaders[indexPath.section]]![indexPath.row]
        if isWasAddedCityWith(id: String(city.cityId)) {
            presentAlert(title: "Warning", message: "This city already added to list.")
        } else {
            cityViewModel.addSelectedCity(id: String(city.cityId))
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
}


