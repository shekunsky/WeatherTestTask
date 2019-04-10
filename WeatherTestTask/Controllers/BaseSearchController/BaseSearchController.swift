//
//  BaseSearchTableViewController.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

class BaseSearchTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }

    internal var tableViewSource = [Character : [CitiesListStruct]]()
    internal var tableViewHeaders = [Character]()
    internal var currentArray: [CitiesListStruct]!
    internal var cityViewModel: WeatherViewModel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    internal func createTableData(wordList: [CitiesListStruct]){
        var firstSymbols = Set<Character>()
        
        func getFirstSymbol(word: String) -> Character {
            if word != "" {
                return word[word.startIndex]
            } else {
                return " "
            }
        }
        
        wordList.forEach {_ = firstSymbols.insert(getFirstSymbol(word: $0.name)) }
        var tableViewSourse = [Character : [Any]]()
        
        for symbol in firstSymbols {
            
            var words = [CitiesListStruct]()
            
            for word in wordList {
                if symbol == getFirstSymbol(word: word.name) {
                    words.append(word)
                }
            }
            tableViewSourse[symbol] = words.sorted(by: {$0.name < $1.name})
        }
        
        let sortedSymbols = firstSymbols.sorted(by: {$0 < $1})
        tableViewSource = tableViewSourse as! [Character : [CitiesListStruct]]
        tableViewHeaders = sortedSymbols
    }
    
    private func filterContentForSearchText(searchText: String) {
        let searchResults = currentArray.filter{ ($0.name.localizedCaseInsensitiveContains(searchText)) }
        if searchResults.count == currentArray.count || searchText.count == 0 {
            createTableData(wordList: currentArray)
        } else {
            createTableData(wordList: searchResults)
        }
        tableView.reloadData()
    }
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSource[tableViewHeaders[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = tableViewSource[tableViewHeaders[indexPath.section]]![indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  String(tableViewHeaders[section])
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = ColorConstants.kTableFooterBgColor
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .white
    }
}

extension BaseSearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
    }
}
