//
//  CardWebSDKExample.swift
//  TapCardCheckoutExample
//
//

import UIKit
import Tap_Card_SDK
import Toast

class TapCardSDKExample: UIViewController {
    @IBOutlet weak var tapCardView: TapCardView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var eventsTextView: UITextView!
    
    var dictConfig:[String:Any] = ["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
                                   "scope":"Authenticate",
                                   "purpose":"PAYMENT_TRANSACTION",
                                   "transaction":["amount":1,
                                                  "currency":"SAR",
                                                  "description": "Authentication description",
                                                  "metadata":["example":"value"],
                                                  "reference":generateRandomTransactionId()],
                                   "order":["id":generateRandomOrderId()],
                                   "invoice":["id":""],
                                   "merchant":["id":""],
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
                                   "interface":["locale": "en", "theme": UIView().traitCollection.userInterfaceStyle == .dark ? "dark": "light", "edges": "curved", "direction": "dynamic"],
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
        tapCardView.initTapCardSDK(configDict: self.dictConfig, delegate: self, presentScannerIn: self)
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
        self.dictConfig["order"] = ["id":TapCardSDKExample.generateRandomOrderId()]
        guard var transactionData:[String:Any] = self.dictConfig["transaction"] as? [String:Any] else {
            return
        }
        transactionData["reference"] = TapCardSDKExample.generateRandomTransactionId()
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
