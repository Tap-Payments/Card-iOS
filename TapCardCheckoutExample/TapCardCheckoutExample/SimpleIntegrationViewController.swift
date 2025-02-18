//
//  SimpleIntegrationViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 08/10/2023.
//

import UIKit
import Card_iOS

class SimpleIntegrationViewController: UIViewController, TapCardViewDelegate {

    /// The reference you need for the card form
    let cardiOS:TapCardView = .init()
    /// The only needed configuration to tokenize/authenticate a card
    let configurations:[String:Any] = ["operator":["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
                                       "scope":"AuthenticatedToken",
                                       "order":["amount":1,
                                                "currency":"SAR"],
                                       "customer":["name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]],
                                                   "contact":["email":"tap@tap.company"]]]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // add the form
        view.addSubview(cardiOS)
        view.bringSubviewToFront(cardiOS)
        cardiOS.translatesAutoresizingMaskIntoConstraints = false
        // adjust the constraints MUST
        NSLayoutConstraint.activate([
            cardiOS.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            cardiOS.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            cardiOS.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        cardiOS.initTapCardSDK(configDict: configurations, delegate: self)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
    }
    

    @IBAction func generateToken(_ sender: Any) {
        cardiOS.generateTapToken()
    }
}
