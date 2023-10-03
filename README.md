
# Card-iOS

We at [Tap Payments](https://www.tap.company/) strive to make your payments easier than ever. We as a PCI compliant company, provide you a from the self solution to process card payments in your iOS apps.

![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Card-iOS.svg?style=flat)


![enter image description here](https://im4.ezgif.com/tmp/ezgif-4-272ebac491.gif)

# Requirements

 1. We support from iOS 13.0+
 2. Swift Version 5.0+
 3. Objective-C

# Steps overview
```mermaid
sequenceDiagram

participant  A  as  App
participant  T  as  Tap
participant  C  as  Card iOS

A->>T:  Regsiter app.
T-->>A: Public key.
A ->> C : Install SDK
A ->> C : Init TapCardView
C -->> A : tapCardView
A ->> C : tapCardView.initTapCardSDK(configurations,delegate)
C -->> A: onReady()
C -->> C : Enter card data
C -->> A : onBinIdentification(data)
C -->> A : onValidInput
A ->> C : tapCardView.generateTapToken()
C -->> A : onSuccess(data(
```

# Get your keys
You can always use the example keys within our example app, but we do recommend you to head to our [onboarding](https://register.tap.company/sell)  page. You will need to register your `bundle id` to get your `Key` that you will need to activate our `Card-iOS`.

# Installation

We got you covered, `Card-iOS` can be installed with all possible technologies.

## Cocoapods

```swift
target 'MyApp' do
  pod 'Card-iOS'
end
```

Then run in your terminal
```swift
pod install
pod update
```


## Swift Package Manager
In Xcode, add the `TapCardSDK` as a [package dependency](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app) to your Xcode project. Enter [https://github.com/Tap-Payments/Card-iOS.git](https://github.com/Tap-Payments/Card-iOS.git) as the package URL. 


# Prepare input

## Documentation

### Main input documentation
To make our sdk as dynamic as possible, we accept the input in a form of a `dictionary` . We will provide you with a sample full one for reference.
It is always recommended, that you generate this `dictionary` from your server side, so in future if needed you may be able to change the format if we did an update.

|Configuration|Description | Required | Type| Sample
|--|--|--| --|--|
| operator| This is the `Key` that you will get after registering you bundle id. | True  | String| `let operator:[String:Any]: ["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"]` |
| scope| Defines the intention of using the `Card-iOS`. | True  | String| ` let scope:String = "Token"`|
| purpose| Defines the intention of using the `Token` after generation. | True  | String| ` let purpose:String = "asd"` |
| transaction| Needed to define transaction metadata and reference, if you are generating an authenticated token. | False  | `Dictionry`| ` let transaction:[String:Any] = ["metadata":["example":"value"], "reference":"A reference to this transaciton in your system"],"paymentAgreement":["id":"", "contract":["id":"If you created a contract id with the client to save his card, pass its is here. Otherwise, we will create one for you."]]` |
| order| This is the `order id` that you created before or `amount` and `currency` to generate a new order.   It will be linked this token. | True  | `Dictionary`| ` let order:[String:String] = ["id":"", "amount":1, "currency":"SAR", "description": "Authentication description"]` |
| invoice| This is the `invoice id` that you want to link this token to if any. | False  | `Dictionary`| ` let invoice:[String:String] = ["id":""]` |
| merchant| This is the `Merchant id` that you will get after registering you bundle id. | True  | `Dictionary`| ` let merchant:[String:String] = ["id":""]` |
| customer| The customer details you want to attach to this tokenization process. | True  | `Dictionary`| ` let customer:[String:Any] = ["id":"", "name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]], "nameOnCard":"TAP PAYMENTS", "editble":true, "contact":["email":"tap@tap.company", "phone":["countryCode":"+965","number":"88888888"]]]` |
| features| Some extra features that you can enable/disable based on the experience you want to provide.. | False  | `Dictionary`| ` let features:[String:Any] = ["scanner":true, "acceptanceBadge":true, "customerCards":["saveCard":false, "autoSaveCard":false]`|
| acceptance| The acceptance details for the transaction. Including, which card brands and types you want to allow for the customer to tokenize/save. | False  | `Dictionary`| ` let acceptance:[String:Any] = ["supportedSchemes":["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"], "supportedFundSource":["CREDIT","DEBIT"], "supportedPaymentAuthentications":["3DS"]]`|
| fields| Needed to define visibility of the optional fields in the card form. | False  | `Dictionary`| ` let fields:[String:Any] = "card":["cardHolder":true]` |
| addons| Needed to define the enabling of some addons on top of the basic card form. | False  | `Dictionary`| ` let addons:[String:Bool] = ["loader": true]`|
| interface| Needed to defines look and feel related configurations. | False  | `Dictionary`| ` let interface:[String:String] = ["locale": "en", "theme": "light", "edges": "curved", "direction": "dynamic", "powered": true, "colorStyle": "colored"]` |
| post| This is the `webhook` for your server, if you want us to update you server to server. | False  | `Dictionary`| ` let post:[String:String] = ["url":""]` |

### Documentation per variable

 - operator:
	 - Responsible for passing the data that defines you as a merchant within Tap system.
 - operator.publicKey:
	 - A string, which you get after registering the app bundle id within the Tap system. It is required to correctly identify you as a merchant.
	 - You will receive a sandbox and a production key. Use, the one that matches your environment at the moment of usage.
 - scope:
	 - Defines the intention of the token you are generating.
	 - When the token is used afterwards, the usage will be checked against the original purpose to make sure they are a match.
	 - Possible values:
		 -  `Token` : This means you will get a Tap token to use afterwards.
		 - `AuthenticatedToken` This means you will get an authenticated Tap token to use in our charge api right away.
		 - `SaveToken` This means you will get a token to use multiple times with authentication each time.
		 - `SaveAuthenticatedToken` This means you will get an authenticated token to use in multiple times right away.
 - purpose:
	 - Defines the intention of using the `Token` after generation.
	 - Possible values:
		 - `PAYMENT_TRANSACTION` Using the token for a single charge.
		 - `RECURRING_TRANSACTION` Using the token for multiple recurring charges.
		 - `INSTALLMENT_TRANSACTION` Using the token for a charge that is a part of an installement plan.
		 - `ADD_CARD` Using the token for a save a card for a customer.
		 - `CARDHOLDER_VERIFICATION` Using the token for to verify the ownership of the card.
 - transaction:
	 - Provides essential information about this transaction.
 - transaction.reference:
	 - Pass this value if you want to link this transaction to the a one you have within your system.
 - transaction.metadata:
	 - It is a key-value based parameter. You can pass it to attach any miscellaneous data with this transaction for your own convenience.
 - transaction.paymentAgreement.id:
	 - The id the payment agreement you created using our Apis.
	 - This is an agreement between you and your client to allow saving his card for further payments.
	 - If not passed, it will be created on the fly.
 - transaction.paymentAgreement.contract.id:
	 - The id the contract you created using our Apis.
	 - This is a contract between you and your client to allow saving his card for further payments.
	 - If not passed, it will be created on the fly.
 - order:
	 - The details about the order that you will be using the token you are generating within.
 - order.id:
	 - The id of the `order` if you already created it using our apis.
 - order.currency:
	 - The intended currency you will perform the order linked to this token afterwards.
 -  order.amount:
	 - The intended amount you will perform the order linked to this token afterwards.
 - order.description:
	 - Optional string to put some clarifications about the order if needed.
 - invoice.id:
	 - Optional string to pass an invoice id, that you want to link to this token afterwards.
 - merchant.id:
	 - Optional string to pass to define a sub entity registered under your key in Tap. It is the `Merchant id` that you get from our onboarding team.
 - customer.id:
	 - If you have previously have created a customer using our apis and you want to link this token to him. please pass his id.
 - customer.name:
	 - It is a list of localized names. each name will have:
		 - lang : the 2 iso code for the locale of this name for example `en`
		 - first : The first name.
		 - middle: The middle name.
		 - last : The last name.
 - customer.nameOnCard:
	 - If you want to prefill the card holder's name field.
 - customer.editable:
	 - A boolean that controls whether the customer can edit the card holder's name field or not.
 - customer.contact.email:
	 - An email string for  the customer we are creating. At least the email or the phone is required.
 - customer.contact.phone:
	 - The customer's phone:
		 - countryCode
		 - number
 - features:
	 - Some extra features/functionalities that can be configured as per your needs.
 - features.scanner:
	 - A boolean to indicate whether or not you want to display the scan card icon.
	 - Make sure you have access to camera usage, before enabling the scanner function.
 - features.acceptanceBadge:
	 - A boolean to indicate wether or not you want to display the list of supported card brands that appear beneath the card form itself.
 - features.customerCards.saveCard:
	 - A boolean to indicate wether or not you want to display the save card option to the customer.
	 - Must be used with a combination of these scopes:
		 - SaveToken
		 - SaveAuthenticatedToken
 - features.customerCards.autoSave:
	 - A boolean to indicate wether or not you want the save card switch to be on by default.
- acceptance:
	- List of configurations that control the payment itself.
- acceptance.supportedSchemes:
	- A list to control which card schemes the customer can pay with. For example:
		- AMERICAN_EXPRESS
		- VISA
		- MASTERCARD
		- MADA
		- OMANNET
- acceptance.supportedFundSource:
	- A list to control which card types are allowed by your customer. For example:
		- DEBIT
		- CREDIT
- acceptance.supportedPaymentAuthentications:
	- A list of what authentication techniques you want to enforce and apple. For example:
		- 3DS
- fields.card.cardHolder:
	- A boolean to indicate wether or not you want to show/collect the card holder name.
- addons.loader:
	- A boolean to indicate wether or not you want to show a loading view on top of the card form while it is performing api requests.
- interface.locale:
	- The language of the card form. Accepted values as of now are:
		- en
		- ar
- interface.theme:
	- The display style of the card form. Accepted values as of now are:
		- light
		- dark
		- dynamic // follow the device's display style
- interface.edges:
	- How do you want the edges of the card form to. Accepted values as of now are:
		- curved
		- flat
- interface.cardDirection:
	- The layout of the fields (card logo, number, date & CVV) within the card element itself. Accepted values as of now are:
		- ltr // fields will inflate from left to right
		- rtl // fields will inflate from right to left
		- dynamic // fields will inflate in the locale's direction
- interface.powered:
	- A boolean to indicate wether or not you want to show powered by tap.
	- Note, that you have to have the permission to hide it from the integration team. Otherwise, you will get an error if you pass it as false.
- interface.colorStyle:
	- How do you want the icons rendered inside the card form to. Accepted values as of now are:
		- colored
		- monochrome

## Initialisation of the input

### Initialise as a dictionary
You can create a dictionary to pass the data to our sdk. The good part about this, is that you can generate the data from one of your apis. Whenever we have an update to the configurations, you can update your api. This will make sure, that you will not have to update your app on the App Store.

```swift
var  dictConfig:[String:Any] = 
	["operator":["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
	"scope":"AuthenticatedToken",
	
	"purpose":"PAYMENT_TRANSACTION",
	
	"transaction":[	"metadata":["example":"value"],
					"reference":"",
					"paymentAgreement":["id":"",
						"contract":["id":""]
						]
					],
					
	"order":[	"id":"",
				"amount":1,
				"currency":"SAR",
				"description": "Authentication description"
			],
	"invoice":["id":""],
	
	"merchant":["id":""],
	
	"customer":["id":"",
				"name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]],
				"nameOnCard":"TAP PAYMENTS",
				"editable":true,
				"contact":[	"email":"tap@tap.company",
							"phone":["countryCode":"+965","number":"88888888"]
						  ]
			  ],

"features":["scanner":true,
			"nfc":false,
			"acceptanceBadge":true,
			"customerCards":["saveCard":false,"autoSaveCard":false]
			],

"acceptance":["supportedSchemes": 	["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"],
			  "supportedFundSource":["CREDIT","DEBIT"],
			  "supportedPaymentAuthentications":["3DS"]
			  ],

"fields":["card":["cvv":true,"cardHolder":true]],

"addons":["loader": true],

"interface":["locale": "en",
			 "theme": "light",
			 "edges": "curved",
			 "cardDirection": "dynamic",
			 "powered":true,
			 "colorStyle":"colored"
			 ],

"redirect":["url":""],

"post":["url":""]]
```

# Initializing the Card-iOS form

You can initialize `Card-iOS` in different ways

 1. Storyboard.
 2. Code.
 3. SwiftUI

 
## Storyboard

### Adjust the UI
1. Drag and drop a UIView inside the UIViewController you want in the Storyboard.
2. Declare as of type `TapCardView`
3. Make an IBOutlet to the `UIViewController`.

![enter image description here](https://i.ibb.co/F6H9JXy/Screenshot-2023-10-03-at-8-30-35-AM.png)

### Configure the UI in the UIViewController
```swift
/// The outlet from the created view above
@IBOutlet  weak  var  tapCardView: TapCardView!
.
.
.
tapCardView.initTapCardSDK(configDict: self.dictConfig, delegate: self, presentScannerIn: self)
```

## Code
```swift
/// A class level variable
var  tapCardView:TapCardView = .init()
/// The configuration dictionary
var  dictConfig:[String:Any] = 
	["operator":["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
	"scope":"AuthenticatedToken",
	
	"purpose":"PAYMENT_TRANSACTION",
	
	"transaction":[	"metadata":["example":"value"],
					"reference":"",
					"paymentAgreement":["id":"",
						"contract":["id":""]
						]
					],
					
	"order":[	"id":"",
				"amount":1,
				"currency":"SAR",
				"description": "Authentication description"
			],
	"invoice":["id":""],
	
	"merchant":["id":""],
	
	"customer":["id":"",
				"name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]],
				"nameOnCard":"TAP PAYMENTS",
				"editable":true,
				"contact":[	"email":"tap@tap.company",
							"phone":["countryCode":"+965","number":"88888888"]
						  ]
			  ],

"features":["scanner":true,
			"nfc":false,
			"acceptanceBadge":true,
			"customerCards":["saveCard":false,"autoSaveCard":false]
			],

"acceptance":["supportedSchemes": 	["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"],
			  "supportedFundSource":["CREDIT","DEBIT"],
			  "supportedPaymentAuthentications":["3DS"]
			  ],

"fields":["card":["cvv":true,"cardHolder":true]],

"addons":["loader": true],

"interface":["locale": "en",
			 "theme": "light",
			 "edges": "curved",
			 "cardDirection": "dynamic",
			 "powered":true,
			 "colorStyle":"colored"
			 ],

"redirect":["url":""],

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
    ///  Will be fired whenever the customer changes the status of the save card switch
	///  - Parameter  enabled: Will be true if he enabled it. False if he disbled it
	@objc optional func  onChangeSaveCard(enabled: Bool)
}
```

# Tokenize the card

Once you get notified that the `TapCardView` now has a valid input from the delegate. You can start the tokenization process by calling the public interface:

```swift
///  Wil start the process of generating a `TapToken` with the current card data
tapCardView.generateTapToken()
```
