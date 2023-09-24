//
//  TapCardCodeExampleViewController.swift
//  TapCardSDKExample
//
//  Created by Osama Rabie on 24/09/2023.
//

import UIKit
import Tap_Card_SDK

class TapCardCodeExampleViewController: UIViewController {

    var dictConfig:[String:Any] = ["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
                                   "scope":"Authenticate",
                                   "merchant":["id":""],
                                   "transaction":["amount":1, "currency":"SAR"],
                                   "authentication":["description": "Authentication description",
                                                     "metadata":["example":"value"],
                                                     "reference":["transaction":generateRandomTransactionId(),
                                                                  "order":generateRandomOrderId(),
                                                                  "invoice":["id":""],
                                                                  "authentication":["channel":"PAYER_BROWSER","purpose":"PAYMENT_TRANSACTION"],
                                                                  "post":["url":""]]],
                                   "customer":["id":"",
                                               "name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]],
                                               "nameOnCard":"TAP PAYMENTS",
                                               "editble":true,
                                               "contact":["email":"tap@tap.company",
                                                          "phone":["countryCode":"+965","number":"88888888"]]],
                                   "acceptance":["supportedBrands":["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"],
                                                 "supportedCards":["CREDIT","DEBIT"]],
                                   "fields":["cardHolder":true],
                                   "addons":["displayPaymentBrands": true, "loader": true, "saveCard": false, "scanner": false],
                                   "interface":["locale": "en", "theme": "light", "edges": "curved", "direction": "dynamic"]]
    
    var tapCardView:TapCardView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(tapCardView)
        tapCardView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tapCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tapCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tapCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            view.heightAnchor.constraint(equalToConstant: 95)
        ]
        
        NSLayoutConstraint.activate(constraints)
        tapCardView.setNeedsLayout()
        tapCardView.updateConstraints()
        view.updateConstraints()
        
        tapCardView.initTapCardSDK(configDict: dictConfig, delegate: self, presentScannerIn: self)
    }
    
    
    func addCardView() {
        // Do any additional setup after loading the view.
        view.addSubview(tapCardView)
        tapCardView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tapCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tapCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tapCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            view.heightAnchor.constraint(equalToConstant: 95)
        ]
        
        NSLayoutConstraint.activate(constraints)
        tapCardView.setNeedsLayout()
        tapCardView.updateConstraints()
        view.updateConstraints()
        
        tapCardView.initTapCardSDK(configDict: dictConfig, delegate: self, presentScannerIn: self)
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


extension TapCardCodeExampleViewController: TapCardViewDelegate {
    
}


fileprivate extension TapCardCodeExampleViewController {
    
    static func generateRandomTransactionId() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString = "tck_LV\((0..<23).map{ _ in String(letters.randomElement()!) }.reduce("", +))"
        return randomString
    }
    static func generateRandomOrderId() -> String {
        let letters = "0123456789"
        let randomString = (0..<17).map{ _ in String(letters.randomElement()!) }.reduce("", +)
        return randomString
    }
}
