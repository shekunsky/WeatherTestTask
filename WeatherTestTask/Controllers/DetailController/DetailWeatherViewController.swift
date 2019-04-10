//
//  DetailWeatherViewController.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

class DetailWeatherViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.register(WeatherByHoursCollectionViewCell.self)
        }
    }
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var pressureImageView: UIImageView!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var windImageView: UIImageView!
    
    var viewModel: WeatherViewModel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.isHidden = true
        loadForecast()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.removeForecastWeatherList()
        removeNotificationsObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - UI
    private func setupUI() {
        title = viewModel.getCurrentWeatherCityName()
        configure(weathers: viewModel.getCurrentWeatherCity())
        if let id = viewModel.currentWeatherCity?.id {
            if  String(id) == idOfLocalCity() {
                trashButton.image = nil
                trashButton.isEnabled = false
            }
        }
        pressureImageView.tintColor = .white
        humidityImageView.tintColor = .white
        windImageView.tintColor = .white
    }
    
    //MARK: - Actions
    @IBAction func trashButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.deleteSelectedCity()
        navigationController?.popViewController(animated: true)
    }
    
    private func loadForecast() {
        if checkIsInternetEnabled() {
            //Online mode
            view.loadingIndicator(true)
            viewModel.obtainForecast {[weak self] (error) in
                self?.view.loadingIndicator(false)
                if let error = error {
                    self?.handleError(error, completion: nil)
                } else {
                    self?.collectionView.isHidden = false
                    self?.collectionView.reloadData()
                }
            }
        } else {
            //Offline mode
            viewModel.loadWeatherByHoursFromDBForCity()
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    private func configure(weathers: CommonWeatherProtocol?) {
        if let speed = weathers?.wind?.speed {
            windLabel.text = "\(Int(speed))m/s"
        }
        
        if let pressure = weathers?.mainWeather?.pressure {
            pressureLabel.text = "\(Int(pressure)) hPa"
        }
        
        if let hum = weathers?.mainWeather?.humidity {
            humidityLabel.text = "\(hum)%"
        }
        
        if let temp = weathers?.mainWeather?.temp {
            degreesLabel.text = String(format: "%d %@C", Int(temp), "\u{00B0}")
        }
        
        if let urlString = weathers?.weather?.first?.icon {
            weatherImageView.setImage(urlString: urlString)
        }
    }
    
    //MARK: - Notifications
    func registerForNotifications() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(internetAvailable),
            name: NSNotification.Name(NotificationsConstants.kNotificationInternetAvailable),
            object: nil)
        
    }
    
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationsConstants.kNotificationInternetAvailable), object: nil)
    }
    
    @objc func internetAvailable() {
        loadForecast()
    }
}

extension DetailWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastWeatherList()?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width/5 - 2,
            height: 90.0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView
            .dequeueReusableCell(withType: WeatherByHoursCollectionViewCell.self, for: indexPath).configured(withModel: viewModel.forecastWeatherList()?.list[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        configure(weathers: viewModel.forecastWeatherList()?.list[indexPath.row])
    }
}
