//
//  StoreDetailsView.swift
//  storeApp
//
//  Created by Kyle Smith on 1/8/17.
//  Copyright © 2017 Codesmiths. All rights reserved.
//

import UIKit
import MapKit

class StoreDetailsView: BaseView {
    
    var store: Store? {
        didSet {
            guard let store = store else {
                return
            }
            gasButton.setTitle(store.price, for: .normal)
            storePhoneButton.setTitle(store.phone, for: .normal)
            storeNameLabel.text = store.name
            storeAddressLabel.text = store.address
            storeLocationLabel.text = store.city! + ", "
                + store.state! + ", " + store.zipcode!
            distanceLabel.text = String(format: "%.1f", (store.distance)!/1609.344) + " mi"
        }
    }
    
    let mapView:MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Configuration.convertBase64Image(image: UserDefaults.standard.string(forKey: "icon")!)
        iv.contentMode = .scaleAspectFit
        //iv.layer.borderWidth = 1
        //iv.layer.borderColor = UIColor.black.cgColor
        //iv.layer.cornerRadius = 75 / 2
        //iv.backgroundColor = .green
        return iv
    }()
    
    let gasButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4)
        let color = UIColor(red: 0/255, green: 122/255, blue: 1, alpha: 1)
        button.setTitle("Log in to see gas price", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
        return button
    }()
    
    let amenitiesView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    let distanceImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "locator-blue")
        return iv
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.text = "miles"
        return label
    }()
    
    let storeInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    let storeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.text = "Store Information"
        return label
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        label.text = "Name"
        return label
    }()
    
    let storeAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.text = "123 That Ave"
        return label
    }()
    
    let storeLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.text = "That City, State, 88888"
        return label
    }()
    
    let storePhoneButton: UIButton = {
        let button = UIButton()
        let color = UIColor(red: 0/255, green: 122/255, blue: 1, alpha: 1)
        button.setTitle("555-555-5555", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(mapView)
        addSubview(logoImageView)
        addSubview(gasButton)
        addSubview(distanceImage)
        addSubview(distanceLabel)
        
        addSubview(storeInfoView)
        storeInfoView.addSubview(storeInfoLabel)
        storeInfoView.addSubview(storeNameLabel)
        storeInfoView.addSubview(storeAddressLabel)
        storeInfoView.addSubview(storeLocationLabel)
        storeInfoView.addSubview(storePhoneButton)
        
        addSubview(amenitiesView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: mapView)
        addConstraintsWithFormat(format: "H:|-16-[v0(75)]", views: logoImageView)
        addConstraintsWithFormat(format: "H:[v0(20)]-4-[v1]-32-|", views: distanceImage, distanceLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: storeInfoView)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: amenitiesView)
        
        addConstraintsWithFormat(format: "V:|-64-[v0(100)]-16-[v1(20)]", views: mapView, gasButton)
        addConstraintsWithFormat(format: "V:|-64-[v0(100)]-[v1(20)]", views: mapView, distanceImage)
        addConstraintsWithFormat(format: "V:|-64-[v0(100)]-[v1(20)]", views: mapView, distanceLabel)
        addConstraintsWithFormat(format: "V:|-120-[v0(75)]-16-[v1(175)]-[v2(90)]", views: logoImageView, storeInfoView, amenitiesView)
        
        
        addConstraint(NSLayoutConstraint(item: gasButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //storeInfoView constraints
        storeInfoView.addConstraintsWithFormat(format: "H:|-[v0]", views: storeInfoLabel)
        storeInfoView.addConstraintsWithFormat(format: "H:|-16-[v0]", views: storeNameLabel)
        storeInfoView.addConstraintsWithFormat(format: "H:|-16-[v0]", views: storeAddressLabel)
        storeInfoView.addConstraintsWithFormat(format: "H:|-16-[v0]", views: storeLocationLabel)
        storeInfoView.addConstraintsWithFormat(format: "H:|-16-[v0]", views: storePhoneButton)

        storeInfoView.addConstraintsWithFormat(format: "V:|-[v0(20)]-[v1(20)]-[v2(20)]-[v3(20)]-[v4(20)]", views: storeInfoLabel, storeNameLabel, storeAddressLabel, storeLocationLabel, storePhoneButton)
        
    }
    
}

