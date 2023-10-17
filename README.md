
# Android

Integrating iOS Card SDK in your application

# Introduction[](https://developers.tap.company/docs/card-sdk-ios#introduction)

Before diving into the development process, it's essential to establish the prerequisites and criteria necessary for a successful build. In this step, we'll outline the specific iOS requirements, including the minimum SDK version and other important details you need to consider. Let's ensure your project is set up for success from the very beginning.

# Sample Demo

![enter image description here](https://github.com/Tap-Payments/Card-iOS/raw/main/ezgif.com-video-to-gif.gif?raw=true)



# Step 1: Requirements[](https://developers.tap.company/docs/card-sdk-ios#step-1-requirements)

-   We support from iOS 13.0+
-    Swift Version 5.0+
-    Objective-C
-  In order to be able to use card scanner functionality, please make sure you added the correct permission key-value in the project info.plist.
    
    ```xml
    <key>NSCameraUsageDescription</key>
    <string>Card SDK needs it for scanner functionality</string>
    ```


# Step 2: Get Your Public Keys[](https://developers.tap.company/docs/card-sdk-ios#step-2-get-your-public-keys)

While you can certainly use the sandbox keys available within our sample app which you can get by following the  [installation](https://developers.tap.company/docs/android-card-sdk#step-3-installation-using-gradle)  process, however, we highly recommend visiting our  [onboarding](https://register.tap.company/ae/en/sell)  page, there you'll have the opportunity to register your package name and acquire your essential Tap Key for activating Card-iOS integration.

# Step 3: Installation[](https://developers.tap.company/docs/card-sdk-ios#step-3-installation)

## Swift Package Manager
1. Open your project's settings.
2. Navigate to `Package Dependencies`
3. Add a new package
4. Paste `Card-iOS` package url : https://github.com/Tap-Payments/Card-iOS.git
5. Add to the target.

![enter image description here](https://i.ibb.co/RQ9Hxms/Screenshot-2023-10-17-at-12-31-36-PM.png)

## CocoaPods
1. Add this to your pod file:
2. `pod Card-iOS`
3. Run this in terminal :
 ```
 pod install
 pod update
 ```

# Step 4: Integrating Card-iOS[](https://developers.tap.company/docs/card-sdk-ios#step-4--integrating-card-ios)

This integration offers two distinct options: a  [simple integration](https://developers.tap.company/docs/android-card-sdk#simple-integration)  designed for rapid development and streamlined merchant requirements, and an  [advanced integration](https://developers.tap.company/docs/android-card-sdk#advanced-integration)  that adds extra features for a more dynamic payment integration experience.

## Integration Flow[](https://developers.tap.company/docs/card-sdk-ios#integration-flow)

Noting that in iOS, you have the ability to create the UI part of the Card-iOS by creating it as normal view in your storyboard then implement the functionality through code or fully create it by code. Below we will describe both flows:

1.  You will have to create a variable of type TapCardView, which can be done in one of two ways:
    -   Created in the storyboard and then linked to a variable in code.
    -   Created totally within the code.
2.  Once you create the variable in any way, you will have to follow these steps:
    -   Create the parameters.
    -   Pass the parameters to the variable.
    -   Implement TapCardViewDelegate protocol, which allows you to get notified by different events fired from within the Card-iOS SDK, also called callback functions.
    -   Start tokenizing a card on demand.


##  Initialising the UI[](https://developers.tap.company/docs/card-sdk-ios#initialising-the-ui)

> 🚧
> Note: You can initialise the Card-iOS SDK either using Storyboard for the UIview then implementing the functionality through code or directly create everything through Code as provided below.

### Using Storyboard
1. **Creating the TapCardView in storyboard**
	1.  Drag and drop a UIView inside the UIViewController you want in the Storyboard.
	2.  Declare as of type  `TapCardView`
	3.  Make an IBOutlet to the  `UIViewController`.
	4. ![enter image description here](https://camo.githubusercontent.com/f1ea93357ee32ca4e7697fe4ff53becd5c6cf07b5362f1096d508e83deb290c2/68747470733a2f2f692e6962622e636f2f463648394a58792f53637265656e73686f742d323032332d31302d30332d61742d382d33302d33352d414d2e706e67)(https://camo.githubusercontent.com/f1ea93357ee32ca4e7697fe4ff53becd5c6cf07b5362f1096d508e83deb290c2/68747470733a2f2f692e6962622e636f2f463648394a58792f53637265656e73686f742d323032332d31302d30332d61742d382d33302d33352d414d2e706e67)
2. **Accessing the Card From created in storyboard in your code**
	3. Create an IBOutlet from the created view above to your UIViewController
 ```swift
  /// The outlet from the created view above
@IBOutlet  weak  var  tapCardView: TapCardView!
 ```

###  Using Code to create the TapCardView[](https://developers.tap.company/docs/card-sdk-ios#using-code-to-create-the-tapcardview)

-   **Creating the TapCardView from code**
    
    1.  Head to your UIViewController where you want to display the `TapCardView` as a subview.
    2. Import `Card-iOS` as follows `import Card_iOS` at the top of your UIViewController.
    3. Create a class variable `var tapCardView:TapCardView = .init() ///  An instance of the card view`
    4. In the coming code sample, we will show how to create the view and how to set its layout constraints to take full width as recommended.
```swift
.
.
.
// First of all, add it to your view
view.addSubview(tapCardView)

// Make it adjusttable to manual constraints
tapCardView.translatesAutoresizingMaskIntoConstraints = false

// Please it is a must to set the constraints, don't asssign a height constraint to allow the card to adapt dynamically.
// We are now assigning the recommended width constraints to be full width with 10px margins
NSLayoutConstraint.activate([
tapCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
tapCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
tapCardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
.
.
```

## Simple Integration[](https://developers.tap.company/docs/card-sdk-ios#simple-integration)

Here, you'll discover a comprehensive table featuring the parameters applicable to the simple integration. Additionally, you'll explore the various methods for integrating the SDK, either using storyboard to create the layout and then implementing the controllers functionalities by code, or directly using code. Furthermore, you'll gain insights into card tokenization after the initial payment and learn how to receive the callback notifications.

### Parameters[](https://developers.tap.company/docs/card-sdk-ios#parameters)
Each parameter is linked to the  [reference](https://developers.tap.company/docs/card-sdk-ios#reference)  section, which provides a more in depth explanation of it.

|Parameter|Description | Required | Type| Sample
|--|--|--| --|--|
| operator| Key obtained after registering your package name, also known as Public key. | True  | String| `let operator:[String:Any]: ["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"]` |
| scope| Defines the intention of using Card-iOS. | True  | String| ` let scope:String = "Token"`|
| purpose| Defines the intention of using the generated Token. | True  | String| ` let purpose:String = "Transaction"` |
| order| Order details linked to the token. | True  | `Dictionary`| ` let order:[String:String] = ["id":"", "amount":1, "currency":"SAR", "description": "Authentication description","reference":"","metadata":[:]]` |


### Configuring the Card-iOS SDK[](https://developers.tap.company/docs/card-sdk-ios#configuring-the-card-ios-sdk)

After creating the UI using any of the previously mentioned ways, it is time to pass the parameters needed for the SDK to work as expected and serve your need correctly.

1.  **Creating the parameters**  
    To allow flexibility and to ease the integration, your application will only has to pass the parameters as a  `Dictionary[String:Any]` .  
    First, let us create the required parameters:

```swift
/// The minimum needed configuration dictionary
    let parameters: [String: Any] =
      [
        "operator": ["publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
        "scope": "Token",
        "purpose":"Transaction",
        "order": [
          "amount": 1,
          "currency": "SAR",
          "metadata": ["key": "value"],
        ],
        "customer": [
          "name": [["lang": "en", "first": "TAP", "middle": "", "last": "PAYMENTS"]],
          "contact": [
            "email": "tap@tap.company",
            "phone": ["countryCode": "+965", "number": "88888888"],
          ],
        ],
      ]
```

2. Pass these parameters to the created Card Form variable before as follows
```swift
// We provide the card view the needed parameters and we assign ourselves optionally to be the delegate, where we can listen to callbacks.
tapCardView.initTapCardSDK(configDict: self.parameters, delegate: self)
```

**Full code snippet for creating the parameters + passing it TapCardKit variable**
```swift
import Card_iOS
import UIKit

class ViewController: UIViewController, TapCardViewDelegate {

  /// An instance of the card fiew
  var tapCardView: TapCardView = .init()
  /// The minimum needed configuration dictionary
  let parameters: [String: Any] =
    [
      "operator": ["publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
      "scope": "Token",
      "purpose": "Transaction",
      "order": [
        "amount": 1,
        "currency": "SAR",
        "metadata": ["key": "value"],
      ],
      "customer": [
        "name": [["lang": "en", "first": "TAP", "middle": "", "last": "PAYMENTS"]],
        "contact": [
          "email": "tap@tap.company",
          "phone": ["countryCode": "+965", "number": "88888888"],
        ],
      ],
    ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // First of all, add it to your view
    view.addSubview(tapCardView)
    // Make it adjusttable to manual constraints
    tapCardView.translatesAutoresizingMaskIntoConstraints = false
    // Please it is a must to set the constraints, don't asssign a height constraint to allow the card to adapt dynamically.
    // We are now assigning the recommended width constraints to be full width with 10px margins
    NSLayoutConstraint.activate([
      tapCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
      tapCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
      tapCardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ])

    // We provide the card view the needed parameters and we assign ourselves optionally to be the delegate, where we can listen to callbacks.
    tapCardView.initTapCardSDK(configDict: self.parameters, delegate: self)
  }
}
```


###  Tokenise the card[](https://developers.tap.company/docs/card-sdk-ios#tokenise-the-card)

> 📘
> 
> A token is like a secret code that stands in for sensitive info, like credit card data. Instead of keeping the actual card info, we use this code. Tokens are hard for anyone to understand if they try to peek, making it a safer way to handle sensitive stuff.

Following the above code samples, once the TapCardView now has a valid input, you will be able to start the tokenization process by calling the public interface which you can find by following  [Step 5 - Tokenize the card](https://developers.tap.company/docs/ios-card-sdk#step-5-tokenize-the-card).

### Receiving Callback Notifications[](https://developers.tap.company/docs/card-sdk-ios#receiving-callback-notifications)

Now we have created the UI and the parameters required to to correctly display Tap card form. For the best experience, your class will have to implement TapCardViewDelegate protocol, which is a set of optional callbacks, that will be fired based on different events from within the card form. This will help you in deciding the logic you need to do upon receiving each event. Kindly follow the below steps in order to complete the mentioned flow:

1.  Go back to  UIViewController/UiView  file you want to get the callbacks into.
2.  Head to the class declaration line
3.  Add TapCardViewDelegate
4.  Override the required callbacks as follows:
```swift
  /// Will be fired whenever the card sdk finishes successfully the task assigned to it.
  func onSuccess(data: String) {
    print("CardWebSDKExample onSuccess \(data)")
  }
  /// Will be fired whenever there is an error related to the card connectivity or apis
  /// - Parameter data: includes a JSON format for the error description and error
  func onError(data: String) {
    print("CardWebSDKExample onError \(data)")
  }
  /// Will be fired whenever the validity of the card data changes.
  /// - Parameter invalid: Will be true if the card data is invalid and false otherwise.
  func onInvalidInput(invalid: Bool) {
	 print("CardWebSDKExample onInvalidInput \(invalid)")
  }
```

**Full code snippet for creating the parameters + passing it TapCardKit variable + Listening to callbacks**

```swift
import Card_iOS
import UIKit

class ViewController: UIViewController, TapCardViewDelegate {

  func onSuccess(data: String) {
    print(data)
  }

  func onError(data: String) {
    print(data)
  }

  func onInvalidInput(invalid: Bool) {
    print(invalid)
  }

  /// An instance of the card fiew
  var tapCardView: TapCardView = .init()
  /// The minimum needed configuration dictionary
  let parameters: [String: Any] =
    [
      "operator": ["publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
      "scope": "Token",
      "purpose": "Transaction",
      "order": [
        "amount": 1,
        "currency": "SAR",
        "metadata": ["key": "value"],
      ],
      "customer": [
        "name": [["lang": "en", "first": "TAP", "middle": "", "last": "PAYMENTS"]],
        "contact": [
          "email": "tap@tap.company",
          "phone": ["countryCode": "+965", "number": "88888888"],
        ],
      ],
    ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // First of all, add it to your view
    view.addSubview(tapCardView)
    // Make it adjusttable to manual constraints
    tapCardView.translatesAutoresizingMaskIntoConstraints = false
    // Please it is a must to set the constraints, don't asssign a height constraint to allow the card to adapt dynamically.
    // We are now assigning the recommended width constraints to be full width with 10px margins
    NSLayoutConstraint.activate([
      tapCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
      tapCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
      tapCardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ])

    // We provide the card view the needed parameters and we assign ourselves optionally to be the delegate, where we can listen to callbacks.
    tapCardView.initTapCardSDK(configDict: self.parameters, delegate: self)
  }
}

```


## Advanced Integration

[](https://developers.tap.company/docs/card-sdk-ios#advanced-integration)

The advanced configuration for the Card-iOS integration not only has all the features available in the simple integration but also introduces new capabilities, providing merchants with maximum flexibility. You can find a code below, where you'll discover comprehensive guidance on implementing the advanced flow as well as a complete description of each parameter.

### Parameters[](https://developers.tap.company/docs/card-sdk-ios#parameters-1)
Each parameter is linked to the  [reference](https://developers.tap.company/docs/ios-card-sdk#reference)  section, which provides a more in depth explanation of it.
|Configuration|Description | Required | Type| Sample
|--|--|--| --|--|
| operator| Key obtained after registering your bundle id. | True  | String| `let operator:[String:Any]: ["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"]` |
| scope| Defines the intention of using `Card-iOS`. | True  | String| ` let scope:String = "Token"`|
| purpose|Defines the intention of using the generated Token. | True  | String| ` let purpose:String = "Transaction"` |
| order| Order details linked to the token. | True  | `Dictionary`| ` let order:[String:String] = ["id":"", "amount":1, "currency":"SAR", "description": "Authentication description","reference":"","metadata":[:]]` |
| invoice| Invoice id to link to the token (optional). | False  | `Dictionary`| ` let invoice:[String:String] = ["id":""]` |
| merchant| Merchant id obtained after registering your bundle id. | True  | `Dictionary`| ` let merchant:[String:String] = ["id":""]` |
| customer|Customer details for tokenization process. | True  | `Dictionary`| ` let customer:[String:Any] = ["id":"", "name":[["lang":"en","first":"TAP","middle":"","last":"PAYMENTS"]], "nameOnCard":"TAP PAYMENTS", "editble":true, "contact":["email":"tap@tap.company", "phone":["countryCode":"+965","number":"88888888"]]]` |
| features| Extra features for customization (optional). | False  | `Dictionary`| ` let features:[String:Any] = ["acceptanceBadge":true, "customerCards":["saveCard":false, "autoSaveCard":false], "alternativeCardInputs":["cardScanner":true] `|
| acceptance| Acceptance details for the transaction (optional). | False  | `Dictionary`| ` let acceptance:[String:Any] = ["supportedSchemes":["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"], "supportedFundSource":["CREDIT","DEBIT"], "supportedPaymentAuthentications":["3DS"]]`|
| fieldVisibility| Visibility of optional fields in the card form (optional). | False  | `Dictionary`| ` let fieldVisibility:[String:Any] = "card":["cardHolder":true]` |
| interface| Look and feel related configurations (optional). | False  | `Dictionary`| ` let interface:[String:String] = ["locale": "en", "theme": "light", "edges": "curved", "direction": "dynamic", "powered": true, "colorStyle": "colored", "loader": true]` |
| post| Webhook for server-to-server updates (optional). | False  | `Dictionary`| ` let post:[String:String] = ["url":""]` |

###  Initialisation of the input[](https://developers.tap.company/docs/card-sdk-ios#initialisation-of-the-input)

You can use a Dictionary  to send data to our SDK. The benefit is that you can generate this data from one of your APIs. If we make updates to the configurations, you can update your API, avoiding the need to update your app on the  App Store.

```swift
  /// The   configuration dictionary
  let parameters: [String: Any] = [
    "operator": ["publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
    "scope": "AuthenticatedToken",
    "purpose": "Transaction",
    "transaction": [
      "paymentAgreement": [
        "id": "",
        "contract": ["id": ""],
      ]
    ],
    "order": [
      "id": "",
      "amount": 1,
      "currency": "SAR",
      "description": "Authentication description",
      "reference": "",
      "metadata": ["key": "value"],
    ],
    "invoice": ["id": ""],
    "merchant": ["id": ""],
    "customer": [
      "id": "",
      "name": [["lang": "en", "first": "TAP", "middle": "", "last": "PAYMENTS"]],
      "nameOnCard": "TAP PAYMENTS",
      "editable": true,
      "contact": [
        "email": "tap@tap.company",
        "phone": ["countryCode": "+965", "number": "88888888"],
      ],
    ],
    "features": [
      "alternativeCardInputs": [
        "cardScanner": true,
        "cardNFC": false,
      ],
      "acceptanceBadge": true,
      "customerCards": [
        "saveCard": false,
        "autoSaveCard": false,
      ],

    ],
    "acceptance": [
      "supportedSchemes": ["AMERICAN_EXPRESS", "VISA", "MASTERCARD", "OMANNET", "MADA"],
      "supportedFundSource": ["CREDIT", "DEBIT"],
      "supportedPaymentAuthentications": ["3DS"],
    ],
    "fieldVisibility": [
      "card": [
        "cvv": true,
        "cardHolder": true,
      ]
    ],
    "interface": [
      "locale": "en",
      "theme": UIView().traitCollection.userInterfaceStyle == .dark ? "dark" : "light",
      "edges": "curved",
      "cardDirection": "dynamic",
      "powered": true,
      "loader": true,
      "colorStyle": UIView().traitCollection.userInterfaceStyle == .dark ? "monochrome" : "colored",
    ],
    "post": ["url": ""],
  ]
```


###  Receiving Callback Notifications (Advanced Version)[](https://developers.tap.company/docs/card-sdk-ios#receiving-callback-notifications-advanced-version)

The below will allow the integrators to get notified from events fired from the TapCardView.

```swift
  func onHeightChange(height: Double) {
    print("CardWebSDKExample onHeightChange \(height)")
  }

  func onBinIdentification(data: String) {
    print("CardWebSDKExample onBinIdentification \(data)")
  }

  func onValidInput(valid: Bool) {
    print("CardWebSDKExample onValidInput \(valid)")

  }

  func onInvalidInput(invalid: Bool) {
    print("CardWebSDKExample onInvalidInput \(invalid)")
  }

  func onChangeSaveCard(enabled: Bool) {
    print("CardWebSDKExample onInvalidInput \(invalid)")
  }

  func onSuccess(data: String) {
    print("CardWebSDKExample onSuccess \(data)")
  }

  func onError(data: String) {
    print("CardWebSDKExample onError \(data)")
  }

  func onReady() {
    print("CardWebSDKExample onReady")
  }

  func onFocus() {
    print("CardWebSDKExample onFocus")
  }
```


# Step 5: Tokenize the Card[](https://developers.tap.company/docs/card-sdk-ios#step-5-tokenize-the-card)

The Card-iOS SDK provides a public interface that allows you to instruct it to start the tokenization process on demand or whenever you see convenient, in your logic flow. As a guidance we would only recommend calling this interface after getting  **onInValidInput** with data `false`  callback as described above and shown in the code block below.

> 📘
> 
> Tokenize the Card
> 
> ### 
> 
> What is a Token?
> 
> [](https://developers.tap.company/docs/card-sdk-android#what-is-a-token)
> 
> A token is like a secret code that stands in for sensitive info, like credit card data. Instead of keeping the actual card info, we use this code. Tokens are hard for anyone to understand if they try to peek, making it a safer way to handle sensitive stuff.
> 
> ### 
> 
> What is Tokenization of a Card?
> 
> [](https://developers.tap.company/docs/card-sdk-android#what-is-a-token)
> 
> Card tokenization is like changing your credit card into a secret code. You can use this code safely without showing your actual card info. It's a common practice in payments to keep things secure and prevent your card details from being seen by others.
> 
> ### 
> 
> Why Do I Need to Tokenize a Card?
> 
> [](https://developers.tap.company/docs/card-sdk-android#what-is-tokenization-of-a-card)
> 
> There are several reasons to tokenize a card:
> 
> -   **Security**  
>     Tokenization helps protect sensitive card data, reducing the risk of data breaches or unauthorized access.
> -   **Compliance**  
>     Many regulations and industry standards, like PCI DSS, require the use of tokenization to safeguard cardholder data.
> -   **Recurring Payments**  
>     Tokens are useful for recurring payments, as they allow you to charge a customer's card without storing their actual card details.
> -   **Convenience**  
>     Tokens simplify payment processing, as you only need to deal with tokens instead of card numbers.

```swift
/// In this example, we will assume that you want to generate the token, once the user fills in correct and valid card data
func  onInvalidInput(invalid:  Bool)  {
	if !invalid {
		tapCardView.generateTapToken()
	}
}
```

> 👍
> 
> Also, once you correctly trigger the interface, you should expect to hear back from the SDK in one of two callbacks, onSuccess or onError.

#  Full Code Sample

[](https://developers.tap.company/docs/card-sdk-ios#full-code-sample)

Once all of the above steps are successfully completed, your UIViewController  file should look like this:
```swift
//
//  ViewController.swift
//  CardTest
//
//  Created by Osama Rabie on 17/10/2023.
//

import Card_iOS
import UIKit

class ViewController: UIViewController, TapCardViewDelegate {

  /// An instance of the card fiew
  var tapCardView: TapCardView = .init()
  /// The minimum needed configuration dictionary
  let parameters: [String: Any] =
    [
      "operator": ["publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"],
      "scope": "Token",
      "purpose": "Transaction",
      "order": [
        "amount": 1,
        "currency": "SAR",
        "metadata": ["key": "value"],
      ],
      "customer": [
        "name": [["lang": "en", "first": "TAP", "middle": "", "last": "PAYMENTS"]],
        "contact": [
          "email": "tap@tap.company",
          "phone": ["countryCode": "+965", "number": "88888888"],
        ],
      ],
    ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // First of all, add it to your view
    view.addSubview(tapCardView)
    // Make it adjusttable to manual constraints
    tapCardView.translatesAutoresizingMaskIntoConstraints = false
    // Please it is a must to set the constraints, don't asssign a height constraint to allow the card to adapt dynamically.
    // We are now assigning the recommended width constraints to be full width with 10px margins
    NSLayoutConstraint.activate([
      tapCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
      tapCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
      tapCardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ])

    // We provide the card view the needed parameters and we assign ourselves optionally to be the delegate, where we can listen to callbacks.
    tapCardView.initTapCardSDK(configDict: self.parameters, delegate: self)
  }

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
  func onSuccess(data: String) {
    print(data)
  }

  /// Will be fired whenever there is an error related to the card connectivity or apis
  /// - Parameter data: includes a JSON format for the error description and error

  func onError(data: String) {
    print(data)
  }

  func onInvalidInput(invalid: Bool) {
    if !invalid {
      tapCardView.generateTapToken()
    }
  }
  // Will be fired whenever the card element changes its height for your convience
  /// - Parameter height: The new needed height
  func onHeightChange(height: Double) {
    print("NEW HEIGHT \(height)")
  }

  /// Will be fired whenever the card is rendered and loaded
  func onReady() {
    print("Card is read")
  }

  /// Will be fired once the user focuses any of the card fields
  func onFocus() {
    print("Card is focused")
  }

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
  func onBinIdentification(data: String) {
    print(data)
  }
}
```

