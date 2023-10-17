
# Card-iOS

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


# Parameters Reference[](https://developers.tap.company/docs/card-sdk-ios#parameters-reference)

Below you will find more details about each parameter shared in the above tables that will help you easily integrate Card-iOS SDK.

## operator[](https://developers.tap.company/docs/card-sdk-ios#operator)

1.  Definition: It links the payment gateway to your merchant account with Tap, in order to know your business name, logo, etc...
2.  Type: string (_required_)
3.  Fields:
    -   **publicKey**  
        _Definition_: This is a unique public key that you will receive after creating an account with Tap which is considered a reference to identify you as a merchant. You will receive 2 public keys, one for sandbox/testing and another one for production.  
4. Example:
        
```swift
let operator:[String:Any]: ["publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"]
```
## scope [](https://developers.tap.company/docs/card-sdk-ios#scope)

1.  Definition: This is used in order to identify the type of token you want to generate. A token is created in order to save the card details after submitting the form in a more secure way.
2.  Type: string (_required_)
3.  Possible Values:
    -   **Token**  
        _Definition:_  Created before the payment in complete, in order to save the card and do a charge later  
	4. Example: `let scope:String = "Token"`
        
    -   **AuthenticatedToken**  
        _Definition:_  This is a token created and authenticated by the customer. Which means that the customer entered the card information and also passed the Authentication step (3DS) and got the token after.  
        _Example:_ `let scope:String = "AuthenticatedToken"`
        
    -   **SaveToken**  
        _Definition:_  This is used in case you want to have the card information saved in a token, however you want the customer to go through the authentication step (receive OTP or PIN) each time the card is used.  
        _Example:_ `let scope:String = "SaveToken"`
    
        
    -   **SaveAuthenticatedToken**  
        _Definition:_  This means you will get an authenticated token to use in multiple times right away.  
        _Example:_ `let scope:String = "SaveAuthenticatedToken"`

## purpose[](https://developers.tap.company/docs/card-sdk-ios#purpose)

1.  Definition: This will identify the reason of choosing the type of token generated in the scope field, like if it will be used for a single transaction, recurring, saving the token, etc...  
    Note: Only choose the option that suits your needs best.
2.  Type: string (_required_)
3.  Possible Values:
    -   **Transaction**:  
        _Definition:_  In case the token will be used only for a single charge request.  
        _Example:_ `let purpose:String = "Transaction"`
        
    -   **Milestone Transaction**:  
        _Definition:_  Using the token for paying a part of a bigger order, when reaching a certain milestone.  
        _Example:_`let purpose:String = "Milestone Transaction"`
        
    -   **Instalment Transaction**:  
        _Definition:_  Using the token for a charge that is a part of an instalment plan.  
        _Example:_`let purpose:String = "Instalment Transaction"`
        
    -   **Billing Transaction**:  
        _Definition:_  Using the token for paying a bill.  
        _Example:_`let purpose:String = "Billing Transaction"`
        
    -   **Subscription Transaction**:  
        _Definition:_  Using the token for a recurring based transaction.  
        _Example:_`let purpose:String = "Subscription Transaction"`
        
    -   **Verify Cardholder**:  
        _Definition:_  Using the token to verify the ownership of the card, in other words, making sure of the identity of the cardholder.  
        _Example:_`let purpose:String = "Verify Cardholder*"`
        
    -   **Save Card**:  
        _Definition:_  Using the token to save this card and link it to the customer itself.  
        _Example:_`let purpose:String = "Save Card"`
        
    -   **Maintain Card**:  
        _Definition:_  Used to renew a saved card.  
        _Example:_`let purpose:String = "Maintain Card"`
        

##  order [](https://developers.tap.company/docs/card-sdk-ios#order)

1.  Definition: This defined the details of the order that you are trying to purchase, in which you need to specify some details like the id, amount, currency ...
2.  Type: Dictionary, (_required_)
3.  Fields:
    -   **id**  
        _Definition:_  Pass the order ID created for the order you are trying to purchase, which will be available in your database.  
        Note: This field can be empty  
    -   **currency**  
        _Definition:_  The currency which is linked to the order being paid.  
    -   **amount**  
        _Definition:_  The order amount to be paid by the customer.  
        Note: Minimum amount to be added is 0.1.  
    -   **description**  
        _Definition:_  Order details, which defines what the customer is paying for or the description of the service you are providing.  
    -   **reference**  
        _Definition:_  This will be the order reference present in your database in which the paying is being done for.  
4.  _Example:_
  ```swift
  let order: [String: String] = [
      "id": "", "amount": 1, "currency": "SAR", "description": "Authentication description",
      "reference": "",
    ]
  ```

## 

merchant

[](https://developers.tap.company/docs/card-sdk-ios#merchant)

1.  Definition: It is the Merchant id that you get from our onboarding team. This will be used as reference for your account in Tap.
2.  Type: Dictionary (_required_)
3.  Fields:
    -   **id**  
        _Definition:_  Generated once your account with Tap is created, which is unique for every merchant.  
        _Example:_
```swift
	let merchant:[String:String] = ["id":""]
```
        

##  invoice [](https://developers.tap.company/docs/card-sdk-ios#invoice)

1.  Definition: After the token is generated, you can use it to pay for any invoice. Each invoice will have an invoice ID which you can add here using the SDK.  
    Note: An invoice will first show you a receipt/summary of the order you are going to pay for as well as the amount, currency, and any related field before actually opening the payment form and completing the payment.
2.  Type: Dictionary (_optional_)
3.  Fields:
    -   **id**  
        _Definition:_  Unique Invoice ID which we are trying to pay.  
        _Example:_
```swift
let invoice:[String:String] = ["id":""]
```
        

## customer [](https://developers.tap.company/docs/card-sdk-ios#customer)

1.  Definition: Here, you will collect the information of the customer that is paying using the token generate in the SDK.
    
2.  Type: Dictionary (_required_)
    
3.  Fields:
    
    -   **id**  
        _Definition:_  This is an optional field that you do not have before the token is generated. But, after the token is created once the card details are added, then you will receive the customer ID in the response which can be handled in the onSuccess callback function.  
    -   **name**  
        _Definition:_  Full Name of the customer paying.  
        _Fields:_
        
        1.  **lang**  
            Definition: Language chosen to write the customer name.
        2.  **first**  
            Definition: Customer's first name.
        3.  **middle**  
            Definition: Customer's middle name.
        4.  **last**  
            Definition: Customer's last name.  
        
    -   **editable**  
        _Definition:_  The customer's name on the card he is paying with, also known as cardholder name.  
        Note: It is of type Boolean, and indicated whether or not the customer can edit the cardholder name already entered when the token got created.  
      
    -   **contact**  
        _Definition:_  The customer's contact information like email address and phone number.  
        Note: The contact information has to either have the email address or the phone details of the customers or both but it should not be empty.  
        _Fields:_
        
        1.  **email**  
            Definition: Customer's email address  
            Note: The email is of type string.
        2.  **phone**  
            Definition: Customer's Phone number details
            1.  **countryCode**
            2.  **number**  
      
    -   **nameOnCard**  
        _Definition:_  Pre-fill the cardholder name already received once the payment form is submitted.  
4.  _Example:_
```swift
let customer: [String: Any] = [
      "id": "", "name": [["lang": "en", "first": "TAP", "middle": "", "last": "PAYMENTS"]],
      "nameOnCard": "TAP PAYMENTS", "editble": true,
      "contact": [
        "email": "tap@tap.company", "phone": ["countryCode": "+965", "number": "88888888"],
      ],
    ]
```
        

##  featuresv[](https://developers.tap.company/docs/card-sdk-ios#features)

1.  Definition: Additional functionalities to be added in order to make the payment gateway experience more customisable for your needs, like showing the accepted card brands on the payment form, save card toggle button...
    
2.  Type: Dictionary (optional)
    
3.  Fields:
    
    -   **acceptanceBadge**  
        _Definition:_  A boolean to indicate wether or not you want to display the list of supported card brands that appear beneath the card form itself.  
        
    -   **customerCards**  
        _Definition:_  You will have the option to display either the toggle button that allows to save the card or the autosave card.  
        _Fields:_
        
        1.  **saveCard**  
            Definition: A boolean to indicate wether or not you want to display the save card option to the customer.  
            Must be used with a combination of these 2 scopes either SaveToken or SaveAuthenticatedToken.
        2.  **autoSave**  
            Definition: A boolean to indicate wether or not you want the save card switch to be on by default.  
       
    -   **alternativeCardInput**  
        _Definition:_ You can also, either add the card information by scanning the card or by using NFC.  
        Note: In order for that to work, you will need to add the Camera usage description to your info.plist file like so 
```xml
<key>NSCameraUsageDescription</key>
<string>Card SDK needs it for scanner functionality</string>
```
		_Fields:_
        
        1.  **cardScanner**  
            Definition: A boolean to indicate whether or not you want to display the scan card icon.
4. - _Example:_
```swift
let features: [String: Any] = [
      "acceptanceBadge": true, "customerCards": ["saveCard": false, "autoSaveCard": false],
      "alternativeCardInputs": ["cardScanner": true],
    ]
```
    
        

## acceptancev[](https://developers.tap.company/docs/card-sdk-ios#acceptance)

1.  Definition: This will help in controlling the supported payment schemes, like MasterCard and Visa, and the fund source either being debit or credit card and you will also be able to check if you want the customers to complete the 3DS phase (Authentication) or not.
2.  Type: Dictionary (_optional_)
3.  Fields:
    -   **supportedSchemes**  
        _Definition:_  A list to control which card schemes the customer can pay with, note that he can choose more than one card scheme.  
        _Possible Values:_
        
        1.  AMERICAN_EXPRESS
        2.  VISA
        3.  MASTERCARD
        4.  MADA
        5.  OMANNET  
        
    -   **supportedFundSource**  
        _Definition:_  A list to control which card types are allowed by your customer.  
        _Possible Values:_
        
        1.  Debit
        2.  Credit  
        
    -   **supportedPaymentAuthentications**  
        _Definition:_  A list of what authentication techniques you want to enforce like 3DS authentication  
        _Possible Values:_
        
        1.  3DS
4.  _Example:_
```swift
let acceptance: [String: Any] = [
      "supportedSchemes": ["AMERICAN_EXPRESS", "VISA", "MASTERCARD", "OMANNET", "MADA"],
      "supportedFundSource": ["CREDIT", "DEBIT"], "supportedPaymentAuthentications": ["3DS"],
    ]
  ```
        

## fieldVisibility [](https://developers.tap.company/docs/card-sdk-ios#fieldvisibility)

1.  Definition: A boolean to indicate wether or not you want to show/collect the card holder name.
2.  Type: Dictionary (_optional_)
3.  Fields:
    -   **card**
        1.  **cardHolder**  
            _Definition:_  The person that is paying using credit or debit card.  
4. _Example:_
```swift
let fieldVisibility: [String: Any] = ["card": ["cardHolder": true]]
```
            

##  interface [](https://developers.tap.company/docs/card-sdk-ios#interface)

1.  Definition: This will help you control the layout (UI) of the payment form, like changing the theme light to dark, the language used (en or ar), ...
2.  Type: Dictionary (_optional_)
3.  Fields:
    -   **loader**  
        _Definition:_  A boolean to indicate wether or not you want to show a loading view on top of the card form while it is performing api requests.  
    -   **locale**  
        _Definition:_  The language of the card form. Accepted values as of now are:  
        _Possible Values:_
        
        1.  **en**(for english)
        2.  **ar**(for arabic).  
        
    -   **theme**  
        _Definition:_  The display styling of the card form. Accepted values as of now are:  
        _Options:_
        
        1.  **light**
        2.  **dark**
        3.  **dynamic**  ( follow the device's display style )  
        
    -   **edges**  
        _Definition:_  Control the edges of the payment form.  
        _Possible Values:_
        
        1.  **curved**
        2.  **flat**  
        
    -   **cardDirection**  
        _Definition:_  The layout of the fields (card logo, number, date & CVV) within the card element itself.  
        _Possible Values:_
        
        1.  **ltr**  
            Definition: The fields will inflate from left to right.
        2.  **rtl  
            **Definition: The fields will inflate from right to left.
        3.  **dynamic**  
            Definition: The fields will inflate in the locale's direction.  
        
    -   **powered**  
        _Definition:_  A boolean to indicate wether or not you want to show powered by tap.  
        Note, that you have to have the permission to hide it from the integration team. Otherwise, you will get an error if you pass it as false.  

    -   **colorStyle**  
        _Definition:_  How do you want the icons rendered inside the card form.  
        _Possible Values:_
        
        1.  **colored**
        2.  **monochrome**  
4.  _Example:_
```swift
let interface: [String: String] = [
      "locale": "en", "theme": "light", "edges": "curved", "direction": "dynamic", "powered": true,
      "colorStyle": "colored", "loader": true,
    ]
```
        

##  post [](https://developers.tap.company/docs/card-sdk-ios#post)

1.  Definition: Here you can pass the webhook URL you have, in order to receive notifications of the results of each Transaction happening on your application.
    
2.  Type: Dictionary (_optional_)
    
3.  Fields:
    
    -   **url**  
        _Definition:_  The webhook server's URL that you want to receive notifications on.  
        _Example:_
```swift
let post:[String:String] = ["url":""]
```        
