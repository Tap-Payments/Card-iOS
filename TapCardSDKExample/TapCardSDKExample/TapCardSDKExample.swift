//
//  CardWebSDKExample.swift
//  TapCardCheckoutExample
//
//

import UIKit
import Tap_Card_SDK
import Toast
import SharedDataModels_iOS

class TapCardSDKExample: UIViewController {
    @IBOutlet weak var tapCardView: TapCardView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var eventsTextView: UITextView!
    // minimum
    /*var config: TapCardConfiguration = .init(publicKey: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
                                             scope: .Authenticate,
                                             transaction: Transaction(amount: 1, currency: "SAR"),
                                             authentication: .init(reference: Reference(transaction: TapCardSDKExample.generateRandomTransactionId(), order: TapCardSDKExample.generateRandomOrderId())),
                                             customer: Customer(id: nil, name: [.init(lang: "en", first: "Tap", last: "Payments", middle: "")], nameOnCard: "Tap Payments", editable: true, contact: .init(email: "tappayments@tap.company", phone: .init(countryCode: "+965", number: "88888888"))))*/
    // full
    var config: TapCardConfiguration = .init(publicKey: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
                                             scope: .Authenticate,
                                             merchant: Merchant(id: ""),
                                             transaction: Transaction(amount: 1, currency: "SAR"),
                                             authentication: Authentication(description: "Authentication description", metadata: ["utf1":"data"], reference: Reference(transaction: TapCardSDKExample.generateRandomTransactionId(), order: TapCardSDKExample.generateRandomOrderId()), invoice: .init(id: "If have an invoice id to attach"), authentication: AuthenticationClass(), post: .init(url: "Your server webhook if needed")),
                                             customer: Customer(id: nil, name: [.init(lang: "en", first: "Tap", last: "Payments", middle: "")], nameOnCard: "Tap Payments", editable: true, contact: .init(email: "tappayments@tap.company", phone: .init(countryCode: "+965", number: "88888888"))),
                                             acceptance: Acceptance(supportedBrands: ["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"], supportedCards: ["CREDIT","DEBIT"]),
                                             fields: Fields(cardHolder: true),
                                             addons: Addons(displayPaymentBrands: true, loader: true, saveCard: false, scanner: false),
                                             interface: Interface(locale: "en", theme: UIView().traitCollection.userInterfaceStyle == .dark ? "dark" : "light", edges: "curved", direction: "dynamic"))
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapCardSDK()
        button.isEnabled = false
        do {
                    let jsonData = try JSONSerialization.data(withJSONObject: self.dictConfig, options: [.prettyPrinted])
                            print(String(data: jsonData, encoding: .utf8) ?? "")
                        } catch {
                            print("json serialization error: \(error)")
                        }
        /*tapCardView?.initWebCardSDK(configString: """
{
    "publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
    "merchant": {
        "id": ""
    },
    "transaction": {
        "amount": 1,
        "currency": "SAR"
    },
    "customer": {
        "id": "",
        "name": [
            {
                "lang": "en",
                "first": "Ahmed",
                "last": "Sharkawy",
                "middle": "Mohamed"
            }
        ],
        "nameOnCard": "Ahmed Sharkawy",
        "editable": true,
        "contact": {
            "email": "ahmed@gmail.com",
            "phone": {
                "countryCode": "20",
                "number": "1000000000"
            }
        }
    },
    "acceptance": {
        "supportedBrands": [
            "AMERICAN_EXPRESS",
            "VISA",
            "MASTERCARD",
            "MADA"
        ],
        "supportedCards": [
            "CREDIT",
            "DEBIT"
        ]
    },
    "fields": {
        "cardHolder": true
    },
    "addons": {
        "displayPaymentBrands": true,
        "loader": true,
        "saveCard": true
    },
    "interface": {
        "locale": "en",
        "theme": "light",
        "edges": "curved",
        "direction": "ltr"
    }
}
""")
        */
    }

    func setupTapCardSDK() {
        tapCardView.initTapCardSDK(config: self.config, delegate: self, presentScannerIn: self)
        //tapCardView.initTapCardSDK(configDict: self.dictConfig, delegate: self, presentScannerIn: self)
    }
    
    @IBAction func generateToken(_ sender: Any) {
        button.isEnabled = false
        tapCardView?.generateTapToken()
    }
    
    @IBAction func optionsClicked(_ sender: Any) {
        let alertController:UIAlertController = .init(title: "Options", message: "Select one please", preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Copy logs", style: .default, handler: { _ in
            UIPasteboard.general.string = self.eventsTextView.text
        }))
        
        alertController.addAction(.init(title: "Clear logs", style: .default, handler: { _ in
            self.eventsTextView.text = ""
        }))
        
        alertController.addAction(.init(title: "Card config", style: .default, handler: { _ in
            self.configClicked()
        }))
        
        
        alertController.addAction(.init(title: "Random Trx", style: .default, handler: { _ in
            self.config.authentication = Authentication(description: "Authentication description", metadata: ["utf1":"data"], reference: Reference(transaction: TapCardSDKExample.generateRandomTransactionId(), order: TapCardSDKExample.generateRandomOrderId()), invoice: nil, authentication: AuthenticationClass(), post: nil)
            self.updateConfig(config: self.config)
        }))
        
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func configClicked() {
        let configCtrl:CardSettingsViewController = storyboard?.instantiateViewController(withIdentifier: "CardSettingsViewController") as! CardSettingsViewController
        configCtrl.config = config
        configCtrl.delegate = self
        //present(configCtrl, animated: true)
        self.navigationController?.pushViewController(configCtrl, animated: true)
        
    }
    
    /*func setConfig(config: CardWebSDKConfig) {
        self.config = config
    }*/
}


extension TapCardSDKExample: CardSettingsViewControllerDelegate {
    
    func updateConfig(config: TapCardConfiguration) {
        self.config = config
        self.config.authentication = Authentication(description: "Authentication description", metadata: ["utf1":"data"], reference: Reference(transaction: TapCardSDKExample.generateRandomTransactionId(), order: TapCardSDKExample.generateRandomOrderId()), invoice: nil, authentication: AuthenticationClass(), post: nil)
        setupTapCardSDK()
    }
    
}

extension TapCardSDKExample: TapCardViewDelegate {
    func onHeightChange(height: Double) {
        //print("CardWebSDKExample onHeightChange \(height)")
    }
    
    func onBinIdentification(data: String) {
        //print("CardWebSDKExample onBinIdentification \(data)")
        eventsTextView.text = "\n\n========\n\nonBinIdentification \(data)\(eventsTextView.text ?? "")"
    }
    
    func onValidInput(valid: Bool) {
        print("CardWebSDKExample onValidInput \(valid)")

    }
    
    func onInvalidInput(invalid: Bool) {
        //print("CardWebSDKExample onInvalidInput \(invalid)")
        eventsTextView.text = "\n\n========\n\nonInvalidInput \(invalid)\(eventsTextView.text ?? "")"
        button.isEnabled = !invalid
    }
    
    func onSuccess(data: String) {
        //print("CardWebSDKExample onSuccess \(data)")
        eventsTextView.text = "\n\n========\n\nonSuccess \(data)\(eventsTextView.text ?? "")"
        
        let config = ToastConfiguration(
            direction: .top,
            autoHide: true,
            enablePanToClose: true,
            displayTime: 5,
            animationTime: 0.2
        )
        
        let toast = Toast.text("For another 3ds create a new Order#", subtitle: "From the options, select Random Trx", config: config)
        toast.enableTapToClose()
        toast.show()

    }
    
    func onError(data: String) {
        //print("CardWebSDKExample onError \(data)")
        eventsTextView.text = "\n\n========\n\nonError \(data)\(eventsTextView.text ?? "")"
    }
    
    func onReady(){
        //print("CardWebSDKExample onReady")
        eventsTextView.text = "\n\n========\n\nonReady\(eventsTextView.text ?? "")"
    }
    
    func onFocus() {
        //print("CardWebSDKExample onFocus")
        eventsTextView.text = "\n\n========\n\nonFocus\(eventsTextView.text ?? "")"
    }
}



fileprivate extension TapCardSDKExample {
    
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
