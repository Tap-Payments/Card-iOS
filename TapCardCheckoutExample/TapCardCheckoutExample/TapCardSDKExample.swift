//
//  CardWebSDKExample.swift
//  TapCardCheckoutExample
//
//

import UIKit
import Card_iOS
import Toast

class TapCardSDKExample: UIViewController {
    @IBOutlet weak var tapCardView: TapCardView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var eventsTextView: UITextView!
    
    
    
    var dictConfig:[String:Any] = ["operator":["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
                                   "scope":"AuthenticatedToken",
                                   "purpose":"Transaction",
                                   "transaction":["paymentAgreement":["id":"",
                                                                      "contract":["id":""]]],
                                   "order":["id":"",
                                            "amount":1,
                                            "currency":"SAR",
                                            "description": "Authentication description",
                                            "reference":"",
                                            "metadata":["key":"value"]],
                                   "invoice":["id":""],
                                   "merchant":["id":""],
                                   "customer":["id":"",
                                               "name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]],
                                               "nameOnCard":"TAP PAYMENTS",
                                               "editable":true,
                                               "contact":["email":"tap@tap.company",
                                                          "phone":["countryCode":"+965","number":"88888888"]]],
                                   "features":["alternativeCardInputs":["cardScanner":true,
                                                                        "cardNFC":false],
                                               "acceptanceBadge":true,
                                               "customerCards":["saveCard":false,
                                                                "autoSaveCard":false]
                                               
                                   ],
                                   "acceptance":["supportedSchemes":["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"],
                                                 "supportedFundSource":["CREDIT","DEBIT"],
                                                 "supportedPaymentAuthentications":["3DS"]],
                                   "fieldVisibility":["card":["cvv":true,
                                                     "cardHolder":true]],
                                   "interface":["locale": "en",
                                                "theme": UIView().traitCollection.userInterfaceStyle == .dark ? "dark": "light",
                                                "edges": "curved",
                                                "cardDirection": "dynamic",
                                                "powered":true,
                                                "loader": true,
                                                "colorStyle":UIView().traitCollection.userInterfaceStyle == .dark ? "monochrome": "colored"],
                                   "post":["url":""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapCardSDK()
        button.isEnabled = false
        /*do {
                    let jsonData = try JSONSerialization.data(withJSONObject: self.dictConfig, options: [.prettyPrinted])
                            print(String(data: jsonData, encoding: .utf8) ?? "")
                        } catch {
                            print("json serialization error: \(error)")
                        }*/
    }

    func setupTapCardSDK() {
        tapCardView.initTapCardSDK(configDict: self.dictConfig, delegate: self)
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
            self.updateConfig(config: self.dictConfig)
        }))
        
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func configClicked() {
        let configCtrl:CardSettingsViewController = storyboard?.instantiateViewController(withIdentifier: "CardSettingsViewController") as! CardSettingsViewController
        configCtrl.config = dictConfig
        configCtrl.delegate = self
        //present(configCtrl, animated: true)
        self.navigationController?.pushViewController(configCtrl, animated: true)
        
    }
    
    /*func setConfig(config: CardWebSDKConfig) {
        self.config = config
    }*/
}


extension TapCardSDKExample: CardSettingsViewControllerDelegate {
    
    func updateConfig(config: [String:Any]) {
        self.dictConfig = config
        
        guard var transactionData:[String:Any] = self.dictConfig["transaction"] as? [String:Any] else {
            return
        }
        transactionData["reference"] = TapCardSDKExample.generateRandomTransactionId()
        
        guard var orderData:[String:Any] = self.dictConfig["order"] as? [String:Any] else {
            return
        }
        orderData["id"] = ""//TapCardSDKExample.generateRandomOrderId()
        
        self.dictConfig["order"] = orderData
        self.dictConfig["transaction"] = transactionData
        
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
    
    
    func onChangeSaveCard(enabled: Bool) {
        //print("CardWebSDKExample onInvalidInput \(invalid)")
        eventsTextView.text = "\n\n========\n\nonChangeSaveCard \(enabled)\(eventsTextView.text ?? "")"
    }
    
    func onSuccess(data: String) {
        //print("CardWebSDKExample onSuccess \(data)")
        eventsTextView.text = "\n\n========\n\nonSuccess \(data)\(eventsTextView.text ?? "")"
        
        let config = ToastConfiguration(direction: .top, dismissBy: [.tap,.swipe(direction: .toTop),.time(time: 4.0)])
        
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



extension TapCardSDKExample {
    
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
