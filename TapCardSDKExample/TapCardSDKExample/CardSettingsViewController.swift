//
//  CardSettingsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 07/09/2023.
//

import UIKit
import Eureka
import Tap_Card_SDK
protocol CardSettingsViewControllerDelegate {
    func updateConfig(config: TapCardConfiguration)
}

class CardSettingsViewController: FormViewController {

    var config: TapCardConfiguration?
    var delegate: CardSettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section("publicKey")
        <<< TextRow("publicKey.publicKey"){ row in
            row.title = "Tap public key"
            row.placeholder = "Enter your public key here"
            row.value = config?.publicKey
            row.onChange { row in
                self.config?.publicKey = row.value ?? "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"
            }
        }
        
        form +++ Section("scope")
        <<< AlertRow<String>("scope"){ row in
            row.title = "Card scope"
            row.options = ["Token","Authenticate"]
            row.value = config?.scope.rawValue ?? "Token"
            row.onChange { row in
                self.config?.scope = .init(rawValue: row.value ?? "Token") ?? .Token
            }
        }
        
        form +++ Section("merchant")
        <<< TextRow("merchant.id"){ row in
            row.title = "Tap merchant id"
            row.placeholder = "Enter your tap merchnt id"
            row.value = config?.merchant?.id
            row.onChange { row in
                self.config?.merchant?.id = row.value ?? ""
            }
        }
        
        form +++ Section("transaction")
        <<< IntRow("transaction.amount"){ row in
            row.title = "Order amount"
            row.placeholder = "Enter order's amount"
            row.value = config?.transaction?.amount ?? 1
            row.onChange { row in
                self.config?.transaction?.amount = row.value ?? 1
            }
        }
        <<< TextRow("transaction.currency"){ row in
            row.title = "Order currency"
            row.placeholder = "Enter order's currency"
            row.value = config?.transaction?.currency
            row.onChange { row in
                self.config?.transaction?.currency = row.value ?? "SAR"
            }
        }
        
        form +++ Section("customer")
        
        <<< TextRow("customer.id"){ row in
            row.title = "Customer id"
            row.placeholder = "Enter customer's id"
            row.value = config?.customer?.id ?? ""
            row.onChange { row in
                self.config?.customer?.id = row.value ?? ""
            }
        }
        <<< TextRow("customer.first"){ row in
            row.title = "First name"
            row.placeholder = "Enter customer's first name"
            row.value = config?.customer?.name?.first?.first ?? "Tap"
            row.onChange { row in
                self.config?.customer?.name?.first?.first = row.value ?? "Tap"
            }
        }
        
        <<< TextRow("customer.middle"){ row in
            row.title = "Middle name"
            row.placeholder = "Enter customer's middle name"
            row.value = config?.customer?.name?.first?.middle ?? ""
            row.onChange { row in
                self.config?.customer?.name?.first?.middle = row.value ?? ""
            }
        }
        <<< TextRow("customer.last"){ row in
            row.title = "Last name"
            row.placeholder = "Enter customer's last name"
            row.value = config?.customer?.name?.first?.last ?? "Payments"
            row.onChange { row in
                self.config?.customer?.name?.first?.last = row.value ?? "Payments"
            }
        }
        <<< TextRow("customer.nameOnCard"){ row in
            row.title = "Name on card"
            row.placeholder = "Enter card's name"
            row.value = config?.customer?.nameOnCard ?? "Tap Payments"
            row.onChange { row in
                self.config?.customer?.nameOnCard = row.value ?? "Tap Payments"
            }
        }
        <<< SwitchRow("customer.editble"){ row in
            row.title = "Editble"
            row.value = config?.customer?.editable ?? true
            row.onChange { row in
                self.config?.customer?.editable = row.value ?? true
            }
        }
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
        
        form +++ Section("acceptance")
        <<< MultipleSelectorRow<String>("acceptance.supportedBrands"){ row in
            row.title = "supportedBrands"
            row.options = ["AMERICAN_EXPRESS","MADA","MASTERCARD","VISA","OMANNET","MEEZA"]
            row.value = Set(config?.acceptance?.supportedBrands ?? ["AMERICAN_EXPRESS","MADA","MASTERCARD","VISA","OMANNET","MEEZA"])
            row.onChange { row in
                self.config?.acceptance?.supportedBrands = Array(row.value ?? ["AMERICAN_EXPRESS","MADA","MASTERCARD","VISA","OMANNET","MEEZA"])
            }
        }
        <<< MultipleSelectorRow<String>("acceptance.supportedCards"){ row in
            row.title = "supportedCards"
            row.options = ["CREDIT","DEBIT"]
            row.value = Set(config?.acceptance?.supportedCards ?? ["CREDIT","DEBIT"])
            row.onChange { row in
                self.config?.acceptance?.supportedCards = Array(row.value ?? ["CREDIT","DEBIT"])
            }
        }
        
        form +++ Section("fields")
        <<< SwitchRow("fields.cardHolder"){ row in
            row.title = "Card holder"
            row.value = config?.fields?.cardHolder ?? true
            row.onChange { row in
                self.config?.fields?.cardHolder = row.value ?? true
            }
        }
        
        form +++ Section("addons")
        <<< SwitchRow("addons.displayPaymentBrands"){ row in
            row.title = "displayPaymentBrands"
            row.value = config?.addons?.displayPaymentBrands ?? true
            row.onChange { row in
                self.config?.addons?.displayPaymentBrands = row.value ?? true
            }
        }
        <<< SwitchRow("addons.loader"){ row in
            row.title = "loader"
            row.value = config?.addons?.loader ?? true
            row.onChange { row in
                self.config?.addons?.loader = row.value ?? true
            }
        }
        <<< SwitchRow("addons.saveCard"){ row in
            row.title = "saveCard"
            row.value = config?.addons?.saveCard ?? false
            row.onChange { row in
                self.config?.addons?.saveCard = row.value ?? false
            }
        }
        
        <<< SwitchRow("addons.scanner"){ row in
            row.title = "scanner"
            row.value = config?.addons?.scanner ?? false
            row.onChange { row in
                self.config?.addons?.scanner = row.value ?? false
            }
        }
        
        form +++ Section("interface")
        <<< AlertRow<String>("interface.locale"){ row in
            row.title = "locale"
            row.options = ["en","ar"]
            row.value = config?.interface?.locale ?? "en"
            row.onChange { row in
                self.config?.interface?.locale = row.value ?? "en"
            }
        }
        <<< AlertRow<String>("interface.theme"){ row in
            row.title = "theme"
            row.options = ["light","dark"]
            row.value = config?.interface?.theme ?? "light"
            row.onChange { row in
                self.config?.interface?.theme = row.value ?? "light"
            }
        }
        <<< AlertRow<String>("interface.edges"){ row in
            row.title = "edges"
            row.options = ["curved","flat"]
            row.value = config?.interface?.edges ?? "curved"
            row.onChange { row in
                self.config?.interface?.edges = row.value ?? "curved"
            }
        }
        <<< AlertRow<String>("interface.direction"){ row in
            row.title = "direction"
            row.options = ["ltr","rtl","dynamic"]
            row.value = config?.interface?.direction ?? "ltr"
            row.onChange { row in
                self.config?.interface?.direction = row.value ?? "ltr"
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateConfig(config: config!)
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
