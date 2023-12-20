//
//  CardSettingsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 07/09/2023.
//

import UIKit
import Eureka
import Card_iOS

protocol CardSettingsViewControllerDelegate {
    func updateConfig(config: [String:Any], cardNumber:String, cardExpiry:String)
}

class CardSettingsViewController: FormViewController {

    var config: [String:Any]?
    var delegate: CardSettingsViewControllerDelegate?
    var cardNumber:String = ""
    var cardExpiry:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section("operator")
        <<< TextRow("operator.publicKey"){ row in
            row.title = "Tap public key"
            row.placeholder = "Enter your public key here"
            row.value = (config! as NSDictionary).value(forKeyPath: "operator.publicKey") as? String ?? "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["operator","publicKey"], with: row.value ?? "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7")
            }
        }
        
        form +++ Section("scope")
        <<< AlertRow<String>("scope"){ row in
            row.title = "Card scope"
            row.options = ["Token","AuthenticatedToken"]
            row.value = config?["scope"] as? String ?? "Token"
            row.onChange { row in
                self.config?["scope"] = row.value ?? "Token"
            }
        }
        
        
        form +++ Section("purpose")
        <<< AlertRow<String>("purpose"){ row in
            row.title = "Token purpose"
            row.options = ["Transaction","Save Token"]
            row.value = config?["purpose"] as? String ?? "Transaction"
            row.onChange { row in
                self.config?["purpose"] = row.value ?? "Transaction"
            }
        }
        
        form +++ Section("transaction.paymentagreement")
        <<< TextRow("paymentagreement.id"){ row in
            row.title = "id"
            row.placeholder = "Enter paymentAgreement's id"
            
            row.value = (config! as NSDictionary).value(forKeyPath: "transaction.paymentAgreement.id") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["transaction","paymentAgreement","id"], with: row.value ?? "")
            }
        }
        
        <<< TextRow("paymentagreement.contract"){ row in
            row.title = "contract.id"
            row.placeholder = "Enter contracts's id"
            
            row.value = (config! as NSDictionary).value(forKeyPath: "transaction.paymentAgreement.contract.id") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["transaction","paymentAgreement","contract","id"], with: row.value ?? "")
            }
        }
        
        
        form +++ Section("order")
        <<< TextRow("order.id"){ row in
            row.title = "Tap order id"
            row.placeholder = "Enter your tap order id"
            row.value = (config! as NSDictionary).value(forKeyPath: "order.id") as? String ?? TapCardSDKExample.generateRandomOrderId()
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["order","id"], with: row.value ?? TapCardSDKExample.generateRandomOrderId())
            }
        }
        <<< IntRow("order.amount"){ row in
            row.title = "order amount"
            row.placeholder = "Enter order's amount"
            row.value = (config?["order"] as? [String:Any])?["amount"] as? Int ?? 1
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["order","amount"], with: row.value ?? 1)
            }
        }
        <<< TextRow("order.currency"){ row in
            row.title = "order currency"
            row.placeholder = "Enter order's currency"
            
            row.value = (config! as NSDictionary).value(forKeyPath: "order.currency") as? String ?? "SAR"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["order","currency"], with: row.value ?? "SAR")
            }
        }
        
        <<< TextRow("order.description"){ row in
            row.title = "order description"
            row.placeholder = "Enter order's description"
            
            row.value = (config! as NSDictionary).value(forKeyPath: "order.description") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["order","description"], with: row.value ?? "")
            }
        }
        
        <<< TextRow("order.reference"){ row in
            row.title = "order reference"
            row.placeholder = "Enter order's reference"
            
            row.value = (config! as NSDictionary).value(forKeyPath: "order.reference") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["order","reference"], with: row.value ?? "")
            }
        }
        
        form +++ Section("invoice")
        <<< TextRow("invoice.id"){ row in
            row.title = "Link to an invoice"
            row.placeholder = "Enter your invoice id"
            row.value = (config! as NSDictionary).value(forKeyPath: "invoice.id") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["invoice","id"], with: row.value ?? "")
            }
        }
        
        form +++ Section("merchant")
        <<< TextRow("merchant.id"){ row in
            row.title = "Tap merchant id"
            row.placeholder = "Enter your tap merchnt id"
            row.value = (config! as NSDictionary).value(forKeyPath: "merchant.id") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["merchant","id"], with: row.value ?? "")
            }
        }
        form +++ Section("customer")
       
       <<< TextRow("customer.id"){ row in
           row.title = "Customer id"
           row.placeholder = "Enter customer's id"
           row.value = (config! as NSDictionary).value(forKeyPath: "customer.id") as? String ?? ""
           row.onChange { row in
               self.update(dictionary: &self.config!, at: ["customer","id"], with: row.value ?? "")
           }
       }
        
        /*<<< TextRow("customer.first"){ row in
            row.title = "First name"
            row.placeholder = "Enter customer's first name"
            row.value = (config! as NSDictionary).value(forKeyPath: "customer.name.first") as? String ?? "Tap"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["customer","name", "first"], with: row.value ?? "Tap")
            }
        }
        
        <<< TextRow("customer.middle"){ row in
            row.title = "Middle name"
            row.placeholder = "Enter customer's middle name"
            row.value = (config! as NSDictionary).value(forKeyPath: "customer.name.middle") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["customer","name", "middle"], with: row.value ?? "")
            }
        }
        
        
        <<< TextRow("customer.last"){ row in
            row.title = "Last name"
            row.placeholder = "Enter customer's last name"
            row.value = (config! as NSDictionary).value(forKeyPath: "customer.name.last") as? String ?? ""
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["customer","name", "last"], with: row.value ?? "Payments")
            }
        }*/
        
        <<< TextRow("customer.nameOnCard"){ row in
            row.title = "Name on card"
            row.placeholder = "Enter card's name"
            row.value = (config! as NSDictionary).value(forKeyPath: "customer.name.last") as? String ?? "TAP PAYMENTS"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["customer","nameOnCard"], with: row.value ?? "TAP PAYMENTS")
            }
        }
        
        <<< SwitchRow("customer.editable"){ row in
            row.title = "Editable"
            row.value = (config! as NSDictionary).value(forKeyPath: "customer.editable") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["customer","editable"], with: row.value ?? true)
            }
        }
        
        
        form +++ Section("features")
        <<< SwitchRow("features.acceptanceBadge"){ row in
            row.title = "acceptanceBadge"
            row.value = (config! as NSDictionary).value(forKeyPath: "features.acceptanceBadge") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["features","acceptanceBadge"], with: row.value ?? true)
            }
        }
        <<< SwitchRow("features.alternativeCardInputs.scanner"){ row in
            row.title = "cardScanner"
            row.value = (config! as NSDictionary).value(forKeyPath: "features.alternativeCardInputs.cardScanner") as? Bool ?? false
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["features","alternativeCardInputs","cardScanner"], with: row.value ?? true)
            }
        }
        
        
        form +++ Section("features.customerCards")
        <<< SwitchRow("features.customerCards.saveCard"){ row in
            row.title = "customerCards.saveCard"
            row.value = (config! as NSDictionary).value(forKeyPath: "features.customerCards.saveCard") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["features","customerCards","saveCard"], with: row.value ?? true)
            }
        }
        <<< SwitchRow("features.customerCards.autoSaveCard"){ row in
            row.title = "customerCards.autoSaveCard"
            row.value = (config! as NSDictionary).value(forKeyPath: "features.customerCards.autoSaveCard") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["features","customerCards","autoSaveCard"], with: row.value ?? true)
            }
        }
        
        
        
        form +++ Section("acceptance")
        <<< MultipleSelectorRow<String>("acceptance.supportedSchemes"){ row in
            row.title = "supportedSchemes"
            row.options = ["AMERICAN_EXPRESS","MADA","MASTERCARD","VISA","OMANNET","MEEZA"]
            row.value = Set((config! as NSDictionary).value(forKeyPath: "acceptance.supportedSchemes") as? [String] ?? ["AMERICAN_EXPRESS","MADA","MASTERCARD","VISA","OMANNET","MEEZA"])
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["acceptance","supportedSchemes"], with: Array(row.value ?? ["AMERICAN_EXPRESS","MADA","MASTERCARD","VISA","OMANNET","MEEZA"]))
            }
        }
        
        <<< MultipleSelectorRow<String>("acceptance.supportedFundSource"){ row in
            row.title = "supportedFundSource"
            row.options = ["CREDIT","DEBIT"]
            row.value = Set((config! as NSDictionary).value(forKeyPath: "acceptance.supportedFundSource") as? [String] ?? ["DEBIT","CREDIT"])
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["acceptance","supportedFundSource"], with: Array(row.value ?? ["DEBIT","CREDIT"]))
            }
        }
        
        <<< MultipleSelectorRow<String>("acceptance.supportedPaymentAuthentications"){ row in
            row.title = "supportedPaymentAuthentications"
            row.options = ["3DS"]
            row.value = Set((config! as NSDictionary).value(forKeyPath: "acceptance.supportedPaymentAuthentications") as? [String] ?? ["3DS"])
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["acceptance","supportedPaymentAuthentications"], with: Array(row.value ?? ["3DS"]))
            }
        }
        
        
        form +++ Section("fieldVisibility.card")
        <<< SwitchRow("fieldVisibility.card.cardHolder"){ row in
            row.title = "Card holder"
            row.value = (config! as NSDictionary).value(forKeyPath: "fieldVisibility.card.cardHolder") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["fieldVisibility","card","cardHolder"], with: row.value ?? true)
            }
        }
        <<< SwitchRow("fieldVisibility.card.cvv"){ row in
            row.title = "cvv"
            row.value = (config! as NSDictionary).value(forKeyPath: "fieldVisibility.card.cvv") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["fieldVisibility","card","cvv"], with: row.value ?? true)
            }
        }
        
        
        form +++ Section("interface")
        <<< AlertRow<String>("interface.locale"){ row in
            row.title = "locale"
            row.options = ["en","ar","dynamic"]
            row.value = (config! as NSDictionary).value(forKeyPath: "interface.locale") as? String ?? "en"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["interface","locale"], with: row.value ?? "en")
            }
        }
        <<< AlertRow<String>("interface.theme"){ row in
            row.title = "theme"
            row.options = ["light","dark","dynamic"]
            row.value = (config! as NSDictionary).value(forKeyPath: "interface.theme") as? String ?? "light"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["interface","theme"], with: row.value ?? "light")
            }
        }
        
        <<< AlertRow<String>("interface.edges"){ row in
            row.title = "edges"
            row.options = ["curved","flat","circular"]
            row.value = (config! as NSDictionary).value(forKeyPath: "interface.edges") as? String ?? "curved"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["interface","edges"], with: row.value ?? "curved")
            }
        }
        
        <<< AlertRow<String>("interface.cardDirection"){ row in
            row.title = "cardDirection"
            row.options = ["ltr","rtl","dynamic"]
            row.value = (config! as NSDictionary).value(forKeyPath: "interface.cardDirection") as? String ?? "dynamic"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["interface","cardDirection"], with: row.value ?? "dynamic")
            }
        }
        
        <<< SwitchRow("interface.powered"){ row in
            row.title = "powered"
            row.value = (config! as NSDictionary).value(forKeyPath: "interface.powered") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["interface","powered"], with: row.value ?? true)
            }
        }
        
        
        <<< SwitchRow("interface.loader"){ row in
            row.title = "loader"
            row.value = (config! as NSDictionary).value(forKeyPath: "interface.loader") as? Bool ?? true
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["interface","loader"], with: row.value ?? true)
            }
        }
        
        <<< AlertRow<String>("interface.colorStyle"){ row in
            row.title = "colorStyle"
            row.options = ["colored","monochrome"]
            row.value = (config! as NSDictionary).value(forKeyPath: "interface.colorStyle") as? String ?? "colored"
            row.onChange { row in
                self.update(dictionary: &self.config!, at: ["interface","colorStyle"], with: row.value ?? "colored")
            }
        }
        
        form +++ Section("Prefill Card")
        <<< AlertRow<String>("card.number"){ row in
            row.title = "Card number"
            row.options = ["","4242424242424242","5123450000000008","4111 1111 1111 1111","4242424","4242"]
            row.value = ""
            row.onChange { row in
                self.cardNumber = row.value ?? ""
            }
        }
        
        <<< AlertRow<String>("card.expiry"){ row in
            row.title = "Card expiry YEAR 2025"
            row.options = ["","01","02","03","04","05","06","07","08"]
            row.value = ""
            row.onChange { row in
                self.cardExpiry = row.value ?? ""
                if !self.cardExpiry.isEmpty {
                    self.cardExpiry = "\(self.cardExpiry)/25"
                }
            }
        }
        
        
        
        /*
       
        <<< EmailRow("customer.email"){ row in
            row.title = "Contact email"
            row.placeholder = "Enter customer's email"
            row.value = config?.customer?.contact?.email ?? "tap@tap.company"
            row.onChange { row in
                self.config?.customer?.contact?.email = row.value ?? "tap@tap.company"
            }
        }
        <<< PhoneRow("customer.countryCode"){ row in
            row.title = "Contact country code"
            row.value = config?.customer?.contact?.phone?.countryCode ?? "+965"
            row.onChange { row in
                self.config?.customer?.contact?.phone?.countryCode = row.value ?? "+965"
            }
        }
        <<< PhoneRow("customer.number"){ row in
            row.title = "Contact number"
            row.value = config?.customer?.contact?.phone?.number ?? "88888888"
            row.onChange { row in
                self.config?.customer?.contact?.phone?.number = row.value ?? "88888888"
            }
        }
        
        
        
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateConfig(config: config!, cardNumber: cardNumber, cardExpiry: cardExpiry)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func update(dictionary dict: inout [String: Any], at keys: [String], with value: Any) {

        if keys.count < 2 {
            for key in keys { dict[key] = value }
            return
        }

        var levels: [[AnyHashable: Any]] = []

        for key in keys.dropLast() {
            if let lastLevel = levels.last {
                if let currentLevel = lastLevel[key] as? [AnyHashable: Any] {
                    levels.append(currentLevel)
                }
                else if lastLevel[key] != nil, levels.count + 1 != keys.count {
                    break
                } else { return }
            } else {
                if let firstLevel = dict[keys[0]] as? [AnyHashable : Any] {
                    levels.append(firstLevel )
                }
                else { return }
            }
        }

        if levels[levels.indices.last!][keys.last!] != nil {
            levels[levels.indices.last!][keys.last!] = value
        } else { return }

        for index in levels.indices.dropLast().reversed() {
            levels[index][keys[index + 1]] = levels[index + 1]
        }

        dict[keys[0]] = levels[0]
    }

}

