# Card-SDK-iOS

We at [Tap Payments](https://www.tap.company/) strive to make your payments easier than ever. We as a PCI compliant company, provide you a from the self solution to process card payments in your iOS apps.

![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Card-SDK-iOS.svg?style=flat)


![enter image description here](https://im4.ezgif.com/tmp/ezgif-4-272ebac491.gif)

# Requirements

 1. We support from iOS 13.0+
 2. Swift Version 5.0+
 3. Objective-C

# Get your Tap keys
You can always use the example keys within our example app, but we do recommend you to head to our [onboarding](https://register.tap.company/sell)  page. You will need to register your `bundle id` to get your `Tap Key` that you will need to activate our `Card SDK`.

# Installation

We got you covered, `TapCardSDK` can be installed with all possible technologies.

## Cocoapods

```swift
target 'MyApp' do
  pod 'Card-SDK-iOS'
end
```

Then run in your terminal
```swift
pod install
pod update
```


## Swift Package Manager
In Xcode, add the `TapCardSDK` as a [package dependency](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app) to your Xcode project. Enter [https://github.com/Tap-Payments/Card-SDK-iOS.git](https://github.com/Tap-Payments/Card-SDK-iOS.git) as the package URL. Tick the `Tap-Card-SD` checkbox to add the `TapCardSDK`  library to your app.

![enter image description here](https://i.ibb.co/mbbmRVC/Screenshot-2023-09-24-at-9-53-08-AM.png)


# Prepare input

## Documentation

To make our sdk as dynamic as possible, we do accept many configurations as input. Let us start by declaring them and explaining the structure and the usage of each.

```swift
/**

Creates a configuration model to be passed to the SDK

- Parameters:

	- publicKey: The Tap public key

	- scope: The scope of the card sdk. Default is generating a tap token

	- purpose: The intended purpose of using the generated token afterwards.

	- merchant: The Tap merchant details

	- transaction: The transaction details

	- order: The tap order id

	- invoice: Link this token to an invoice

	- customer: The Tap customer details

	- acceptance: The acceptance details for the transaction

	- fields: Defines the fields visibility

	- addons: Defines some UI/UX addons enablement

	- interface: Defines some UI related configurations

*/
```

|Configuration|Description | Required | Type| Sample
|--|--|--| --|--|
| publicKey| This is the `Tap Key` that you will get after registering you bundle id. | True  | String| `let publicKey:String = "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"` |
| scope| Defines the intention of using the `TapCardSDK`. | True  | String| ` let scope:String = "Token" //This means you will get a Tap token to use afterwards` OR ` let scope:String = "Authenticate" //This means you will get an authenticated Tap token to use in our charge api right away`  |
| purpose| Defines the intention of using the `Token` after generation. | True  | String| ` let purpose:String = "PAYMENT_TRANSACTION" //Using the token for a single charge.` OR ` let purpose:String = "RECURRING_TRANSACTION" //Using the token for multiple recurring charges.` OR ` let purpose:String = "INSTALLMENT_TRANSACTION" //Using the token for a charge that is a part of an installement plan.` OR ` let purpose:String = "ADD_CARD" //Using the token for a save a card for a customer.` OR ` let purpose:String = "CARDHOLDER_VERIFICATION" //Using the token for to verify the ownership of the card.` |
| transaction| Needed to define transaction metadata and reference, if you are generating an authenticated token. | False  | `Dictionry`| ` let transaction:[String:Any] = ["metadata":["example":"value"], "reference":"A reference to this transaciton in your system"]` |
| order| This is the `Tap order id` and needed amount and currency,  that you created before and want to attach this token to it if any. | False  | `Dictionary`| ` let order:[String:String] = ["id":"", "amount":1, "currency":"SAR", "description": "Authentication description"]` |
| invoice| This is the `invoice id` that you want to link this token to if any. | False  | `Dictionary`| ` let invoice:[String:String] = ["id":""]` |
| merchant| This is the `Merchant id` that you will get after registering you bundle id. | True  | `Dictionary`| ` let merchant:[String:String] = ["id":""]` |
| customer| The customer details you want to attach to this tokenization process. | True  | `Dictionary`| ` let customer:[String:Any] = ["id":"", "name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]], "nameOnCard":"TAP PAYMENTS", "editble":true, "contact":["email":"tap@tap.company", "phone":["countryCode":"+965","number":"88888888"]]]` |
| acceptance| The acceptance details for the transaction. Including, which card brands and types you want to allow for the customer to tokenize. | False  | `Dictionary`| ` let acceptance:[String:Any] = ["supportedBrands": ["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"], "supportedCards":["CREDIT","DEBIT"]` |
| fields| Needed to define visibility of the optional fields in the card form. | False  | `Dictionary`| ` let fields:[String:Bool] = ["cardHolder":true]` |
| addons| Needed to define the enabling of some extra features on top of the basic card form. | False  | `Dictionary`| ` let addons:[String:Bool] = ["displayPaymentBrands": true, "loader": true,"scanner": false]` `/**- displayPaymentBrands: Defines to show the supported card brands logos - loader: Defines to show a loader on top of the card when it is in a processing state - scanner: Defines whether to enable card scanning functionality or not*/`|
| interface| Needed to defines look and feel related configurations. | False  | `Dictionary`| ` let interface:[String:String] = ["locale": "en", "theme": "light", "edges": "curved", "direction": "dynamic"] // Allowed values for theme : light/dark. locale: en/ar, edges: curved/flat, direction:ltr/dynaimc` |
| post| This is the `webhook` for your server, if you want us to update you server to server. | False  | `Dictionary`| ` let post:[String:String] = ["url":""]` |

## Initialisation of the input

### Initialise as a dictionary
You can create a dictionary to pass the data to our sdk. The good part about this, is that you can generate the data from one of your apis. Whenever we have an update to the configurations, you can update your api. This will make sure, that you will not have to update your app on the App Store.

```swift
var dictConfig: [String: Any] = [
  "publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
  "scope": "Authenticate",
  "purpose": "PAYMENT_TRANSACTION",
  "transaction": [
    "metadata": ["example": "value"],
    "reference": "",
  ],
  "order": ["id": "",
	"amount": 1,
    	"currency": "SAR",
    	"description": "Authentication description"],
  "invoice": ["id": ""],
  "merchant": ["id": ""],
  "customer": [
    "id": "",
    "name": [["lang": "en", "first": "TAP", "middle": "", "last": "PAYMENTS"]],
    "nameOnCard": "TAP PAYMENTS",
    "editble": true,
    "contact": [
      "email": "tap@tap.company",
      "phone": ["countryCode": "+965", "number": "88888888"],
    ],
  ],
  "acceptance": [
    "supportedBrands": ["AMERICAN_EXPRESS", "VISA", "MASTERCARD", "OMANNET", "MADA"],
    "supportedCards": ["CREDIT", "DEBIT"],
  ],
  "fields": ["cardHolder": true],
  "addons": ["displayPaymentBrands": true, "loader": true, "saveCard": false, "scanner": false],
  "interface": [
    "locale": "en",
    "theme": "light",
    "edges": "curved", "direction": "dynamic",
  ],
  "post": ["url": ""],
]
```

# Initializing the TapCardSDK form

You can initialize `TapCardView` in different ways

 1. Storyboard.
 2. Code.
 3. SwiftUI

 
## Storyboard


## Code
```swift
/// A class level variable
var  tapCardView:TapCardView = .init()
/// The configuration dictionary
var dictConfig:[String:Any] = ["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
                                   "scope":"Authenticate",
                                   "purpose":"PAYMENT_TRANSACTION",
                                   "transaction":["metadata":["example":"value"],
                                                  "reference":""],
                                   "order":["id":"",
						  "amount":1,
                                                  "currency":"SAR",
                                                  "description": "Authentication description"],
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
/// Add the needed constraints to show and put the card view within your layout
func  addCardView() {


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
}

/// Pass the required configuration data to the tap card view sdk
func configureTheSDK() {
	tapCardView.initTapCardSDK(configDict: dictConfig, delegate: self, presentScannerIn: self)
}
```

## SwiftUI



# TapCardViewDelegate
A protocol that allows integrators to get notified from events fired from the `TapCardSDK`. 

```swift
@objc public protocol TapCardViewDelegate {
    /// Will be fired whenever the card is rendered and loaded
    @objc optional func onReady()
    /// Will be fired once the user focuses any of the card fields
    @objc optional func onFocus()
    /// Will be fired once we detect the brand and related issuer data for the entered card data
    /** - Parameter data: will include the data in JSON format. example :
     *{
        "bin": "424242",
        "bank": "",
        "card_brand": "VISA",
        "card_type": "CREDIT",
        "card_category": "",
        "card_scheme": "VISA",
        "country": "GB",
        "address_required": false,
        "api_version": "V2",
        "issuer_id": "bnk_TS02A5720231337s3YN0809429",
        "brand": "VISA"
     }*     */
    @objc optional func onBinIdentification(data: String)
    /// Will be fired whenever the validity of the card data changes.
    /// - Parameter invalid: Will be true if the card data is invalid and false otherwise.
    @objc optional func onInvalidInput(invalid: Bool)
    /**
        Will be fired whenever the card sdk finishes successfully the task assigned to it. Whether `TapToken` or `AuthenticatedToken`
     - Parameter data: will include the data in JSON format. For `TapToken`:
     {
         "id": "tok_MrL97231045SOom8cF8G939",
         "created": 1694169907939,
         "object": "token",
         "live_mode": false,
         "type": "CARD",
         "source": "CARD-ENCRYPTED",
         "used": false,
         "card": {
             "id": "card_d9Vj7231045akVT80B8n944",
             "object": "card",
             "address": {},
             "funding": "CREDIT",
             "fingerprint": "gRkNTnMrJPtVYkFDVU485Gc%2FQtEo%2BsV44sfBLiSPM1w%3D",
             "brand": "VISA",
             "scheme": "VISA",
             "category": "",
             "exp_month": 4,
             "exp_year": 24,
             "last_four": "4242",
             "first_six": "424242",
             "name": "AHMED",
             "issuer": {
                "bank": "",
                "country": "GB",
                "id": "bnk_TS07A0720231345Qx1e0809820"
            }
         },
         "url": ""
     }
     */
    @objc optional func onSuccess(data: String)
    /// Will be fired whenever there is an error related to the card connectivity or apis
    /// - Parameter data: includes a JSON format for the error description and error
    @objc optional func onError(data: String)
    /// Will be fired whenever the card element changes its height for your convience
    /// - Parameter height: The new needed height
    @objc optional func onHeightChange(height: Double)
}
```

# Tokenize the card

Once you get notified that the `TapCardView` now has a valid input from the delegate. You can start the tokenization process by calling the public interface:

```swift
///  Wil start the process of generating a `TapToken` with the current card data
tapCardView.generateTapToken()
```
