//
//  MainViewController.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit
import CountryPickerView

class MainViewController: UIViewController {
    
    private let countryPickerView = CountryPickerView()
    private lazy var viewModel: WeatherViewModel = WeatherViewModel()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.register(MainCollectionViewCell.self)
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerView.delegate = self
        registerForNotifications()
        checkCurrentCityIsSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCities()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - Cities
    private func checkCurrentCityIsSet() {
        if !UserDefaults.standard.bool(forKey: UserDefaultsConstants.kIsCurrentCityWasSet) {
             _ = viewModel.getStatusLocation()
        }
    }
    
    private func getCities(){
        if checkIsInternetEnabled() {
            view.loadingIndicator(true)
            viewModel.loadCitiesFromWeb {[weak self] (error) in
                self?.view.loadingIndicator(!UserDefaults.standard.bool(forKey: UserDefaultsConstants.kCitiesDbIsInitialized))
                if let error = error {
                    self?.handleError(error, completion: nil)
                    self?.offlineMode()
                } else {
                    self?.collectionView.reloadData()
                }
            }
        } else {
            offlineMode()
        }
    }
    
    private func offlineMode() {
        viewModel.loadCitiesFromDb()
        collectionView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func addNewCityPressed(_ sender: UIBarButtonItem) {
        countryPickerView.showCountriesList(from: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailWeatherViewController = segue.destination(withType: DetailWeatherViewController.self) {
            detailWeatherViewController.viewModel = self.viewModel
        } else if let searchCityTableViewController = segue.destination(withType: SearchCityTableViewController.self) {
            searchCityTableViewController.countryCode = sender as? String
                        searchCityTableViewController.cityViewModel = self.viewModel
                    }
    }
    
    //MARK: - Notifications
    func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getCurrentCity),
            name: NSNotification.Name(NotificationsConstants.kReceivedPermissionForLocationsNotification),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationPermissionFailed),
            name: NSNotification.Name(NotificationsConstants.kFailedPermissionForLocationsNotification),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(internetAvailable),
            name: NSNotification.Name(NotificationsConstants.kInternetAvailableNotification),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(internetDisabled),
            name: NSNotification.Name(NotificationsConstants.kInternetDisabledNotification),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(internetAvailable),
            name: NSNotification.Name(NotificationsConstants.kCitiesDbInitializedNotification),
            object: nil)
        
    }
    
    @objc func internetAvailable() {
        setupAddButton()
        getCurrentCity()
    }
    
    @objc func internetDisabled() {
        setupAddButton()
    }
    
    //MARK: - UI
    @objc func setupAddButton() {
        if UserDefaults.standard.bool(forKey: UserDefaultsConstants.kCitiesDbIsInitialized) && checkIsInternetEnabled() {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
    
    //MARK: - Locations
    @objc func getCurrentCity() {
        guard checkIsInternetEnabled() else {
            return
        }
        guard !UserDefaults.standard.bool(forKey: UserDefaultsConstants.kIsCurrentCityWasSet) else {
            getCities()
            return
        }
        
        view.loadingIndicator(true)
        viewModel.getLocation {[weak self] (error) in
            self?.view.loadingIndicator(!UserDefaults.standard.bool(forKey: UserDefaultsConstants.kCitiesDbIsInitialized))
            if let error = error {
                self?.handleError(error, completion: nil)
            } else {
                UserDefaults.standard.set(true, forKey: UserDefaultsConstants.kIsCurrentCityWasSet)
                UserDefaults.standard.synchronize()
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func locationPermissionFailed() {
        presentLocationAlert(title: "", message: "Application can't get current location without permission, please turn it ON.") { (status) in
            if status {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        
                    })
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.weather?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width/3 - 2,
            height: collectionView.bounds.width/3 - 2
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withType: MainCollectionViewCell.self, for: indexPath).configured(withModel: viewModel.weather?.list[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.setCurrentWeatherCity(withIndex: indexPath.row)
        performSegue(withIdentifier: "ShowDetailedWeatherSegue", sender: nil)
    }
}

extension MainViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let selectedCountryCode = country.code
        performSegue(withIdentifier: "SearchCityTableViewControllerSegue", sender: selectedCountryCode)
    }
}
