//
//  WebCardView.swift
//  TapCardCheckOutKit
//
//  Created by MahmoudShaabanAllam on 07/09/2023.
//

import UIKit
import WebKit
import SnapKit
import SharedDataModels_iOS
import Foundation
import TapCardScannerWebWrapper_iOS
import AVFoundation
import SwiftEntryKit

/// The custom view that provides an interface for the Tap card sdk form
@objc public class TapCardView: UIView {
    /// The web view used to render the tap card sdk
    internal var webView: WKWebView?
    /// A protocol that allows integrators to get notified from events fired from Tap card sdk
    internal var delegate: TapCardViewDelegate?
    /// Holds a reference to the prefilling card number if  any
    internal var cardNumber:String = ""
    /// Holds a reference to the prefilling card expiry if  any
    internal var cardExpiry:String = ""
    /// Defines the base url for the Tap card sdk
    internal static let tapCardBaseUrl:String = "https://sdk.staging.tap.company/v2/card/wrapper?configurations="
    /// Defines the scanner object to be called whenever needed
    internal var fullScanner:TapFullScreenScannerViewController?
    /// Defines the UIViewController passed from the parent app to present the scanner controller within
    internal var presentScannerIn:UIViewController? = nil
    /// keeps a hold of the loaded web sdk configurations url
    internal var currentlyLoadedCardConfigurations:URL?
    /// holds the initial width
    internal var initialWidth:CGFloat = 0
    /// The headers encryption key
    internal var headersEncryptionPublicKey:String {
        if getCardKey().contains("test") {
            return """
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8AX++RtxPZFtns4XzXFlDIxPB
h0umN4qRXZaKDIlb6a3MknaB7psJWmf2l+e4Cfh9b5tey/+rZqpQ065eXTZfGCAu
BLt+fYLQBhLfjRpk8S6hlIzc1Kdjg65uqzMwcTd0p7I4KLwHk1I0oXzuEu53fU1L
SZhWp4Mnd6wjVgXAsQIDAQAB
-----END PUBLIC KEY-----
"""
        }else{
            return """
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8AX++RtxPZFtns4XzXFlDIxPB
h0umN4qRXZaKDIlb6a3MknaB7psJWmf2l+e4Cfh9b5tey/+rZqpQ065eXTZfGCAu
BLt+fYLQBhLfjRpk8S6hlIzc1Kdjg65uqzMwcTd0p7I4KLwHk1I0oXzuEu53fU1L
SZhWp4Mnd6wjVgXAsQIDAQAB
-----END PUBLIC KEY-----
"""
        }
    }
    //MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: - Private methods
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        setupWebView()
        setupConstraints()
    }
    
    
    /// Used to open a url inside the Tap card web sdk.
    /// - Parameter url: The url needed to load.
    private func openUrl(url: URL?) {
        // Store it for further usages
        currentlyLoadedCardConfigurations = url
        // instruct the web view to load the needed url
        let request = URLRequest(url: url!)
        webView?.navigationDelegate = self
        webView?.load(request)
    }
    
    /// used to setup the constraint of the Tap card sdk view
    private func setupWebView() {
        // Creates needed configuration for the web view
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        // Let us make sure it is of a clear background and opaque, not to interfer with the merchant's app background
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.clear
        webView?.scrollView.backgroundColor = UIColor.clear
        webView?.scrollView.bounces = false
        webView?.isHidden = false
        // Let us add it to the view
        self.backgroundColor = .clear
        self.addSubview(webView!)
    }
    
    
    /// Setup Constaraints for the sub views.
    private func setupConstraints() {
        // Defensive coding
        guard let webView = self.webView else {
            return
        }
        
        // Preprocessing needed setup
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Define the web view constraints
        let top  = webView.topAnchor.constraint(equalTo: self.topAnchor)
        let left = webView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4)
        let right = webView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4)
        let bottom = webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let cardHeight = self.heightAnchor.constraint(equalToConstant: 95)
        let cardWidth = self.widthAnchor.constraint(equalToConstant: self.frame.width)
        
        // Activate the constraints
        constraints.first { $0.firstAnchor == heightAnchor }?.isActive = false
        constraints.first { $0.firstAnchor == widthAnchor }?.isActive = false
        
        NSLayoutConstraint.activate([left, right, top, bottom, cardHeight,cardWidth])
        DispatchQueue.main.async {
            /*let currentWidth:CGFloat = self.frame.width
            self.snp.remakeConstraints { make in
                make.height.equalTo(95)
                make.width.equalTo(currentWidth)
            }
            
            self.webView?.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            */
            self.layoutIfNeeded()
            self.updateConstraints()
            self.layoutSubviews()
            self.initialWidth = self.frame.width
            self.webView?.layoutIfNeeded()
        }
        
    }
    
    
    /// Auto adjusts the height of the card view
    /// - Parameter to newHeight: The new height the card view should expand/shrink to
    internal func changeHeight(to newHeight:Double?) {
        // make sure we are in the main thread
        DispatchQueue.main.async {
            // move to the new height or safely to the default height
            let currentWidth:CGFloat = self.frame.width
            
            let cardHeight = self.heightAnchor.constraint(equalToConstant: (newHeight ?? 95) + 10.0)
            let cardWidth = self.widthAnchor.constraint(equalToConstant: currentWidth)
            
            // Activate the constraints
            self.constraints.first { $0.firstAnchor == self.heightAnchor }?.isActive = false
            self.constraints.first { $0.firstAnchor == self.widthAnchor }?.isActive = false
            NSLayoutConstraint.activate([cardHeight,cardWidth])
            // Update the layout of the affected views
            self.layoutIfNeeded()
            self.updateConstraints()
            self.layoutSubviews()
            self.webView?.layoutIfNeeded()
            self.delegate?.onHeightChange?(height: newHeight ?? 95)
        }
    }
    
    
    /// Will handle passing the scanned data to the web based sdk
    /// - Parameter with scannedCard: The card data needed to be passed to the web card sdk
    internal func handleScanner(with scannedCard:TapCard) {
        webView?.evaluateJavaScript("window.fillCardInputs({cardNumber: '\(scannedCard.tapCardNumber ?? "")',expiryDate: '\(scannedCard.tapCardExpiryMonth ?? "")/\(scannedCard.tapCardExpiryYear ?? "")',cvv: '\(scannedCard.tapCardCVV ?? "")',cardHolderName: '\(scannedCard.tapCardName ?? "")'})")
    }
    
    /// Will do needed logic post getting a message from the web sdk that it is ready to be displayd
    internal func handleOnReady() {
        // Give a moment for the iFrame to be fully rendered
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.delegate?.onReady?()
            self.prefillCardData()
        }
    }
    
    /// Will check if card number and expiry are passed by merchant, will ask the web sdk to fill them in
    internal func prefillCardData() {
        guard cardNumber.count > 6 else {
            cardNumber = ""
            cardExpiry = ""
            return
        }
        webView?.evaluateJavaScript("window.fillCardInputs({cardNumber: '\(cardNumber)',expiryDate: '\(cardExpiry)',cvv: '',cardHolderName: ''})")
        cardNumber = ""
        cardExpiry = ""
    }
    
    /// Will handle & starte the redirection process when called
    /// - Parameter data: The data string fetched from the url parameter
    internal func handleRedirection(data:String) {
        // let us make sure we have the data we need to start such a process
        guard let cardRedirection:CardRedirection = try? CardRedirection(data),
              let _:String = cardRedirection.threeDsUrl,
              let _:String = cardRedirection.redirectUrl else {
            // This means, there is such an error from the integration with web sdk
            delegate?.onError?(data: "Failed to start authentication process")
            return
        }
        
        // This means we are ok to start the authentication process
        let threeDsView:ThreeDSView = .init(frame: .zero)
        // Set to web view the needed urls
        threeDsView.cardRedirectionData = cardRedirection
        // Set the selected card locale for correct semantic rendering
        threeDsView.selectedLocale = getCardLocale()
        // Set to web view what should it when the process is canceled by the user
        threeDsView.threeDSCanceled = {
            // reload the card data
            self.openUrl(url: self.currentlyLoadedCardConfigurations)
            // inform the merchant
            self.delegate?.onError?(data: "Payer canceled three ds process")
            // dismiss the threeds page
            SwiftEntryKit.dismiss()
        }
        // Hide or show the powered by tap based on coming parameter
        threeDsView.poweredByTapView.isHidden = !(cardRedirection.powered ?? true)
        // Set to web view what should it when the process is completed by the user
        threeDsView.redirectionReached = { redirectionUrl in
            SwiftEntryKit.dismiss {
                DispatchQueue.main.async {
                    self.passRedirectionDataToSDK(rediectionUrl: redirectionUrl)
                }
            }
        }
        // Set to web view what should it do when the content is loaded in the background
        threeDsView.idleForWhile = {
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: threeDsView, using: threeDsView.swiftEntryAttributes())
            }
        }
        // Tell it to start rendering 3ds content in background
        threeDsView.startLoading()
        
    }
    
    /// Tells the web sdk the process is finished with the data from backend
    /// - Parameter rediectionUrl: The url with the needed data coming from back end at the end of the currently running process
    internal func passRedirectionDataToSDK(rediectionUrl:String) {
        webView?.evaluateJavaScript("window.loadAuthentication('\(rediectionUrl)')")
        //generateTapToken()
    }
    
    
    /// Starts the scanning process if all requirements are met
    internal func scanCard() {
        //Make sure we have something to present within
        guard let presentScannerIn = presentScannerIn else {
            let error:[String:String] = ["error":"In order to be able to use the scanner, you need to reconfigure the card and pass presentScannerIn"]
            delegate?.onError?(data: String(data: try! JSONSerialization.data(
                withJSONObject: error,
                options: []), encoding: .utf8) ?? "In order to be able to use the scanner, you need to reconfigure the card and pass presentScannerIn")
            return }
        let scannerController:TapScannerViewController = .init()
        scannerController.delegate = self
        //scannerController.modalPresentationStyle = .overCurrentContext
        // Second grant the authorization to use the camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                DispatchQueue.main.async {
                    presentScannerIn.present(scannerController, animated: true)
                    //SwiftEntryKit.display(entry: scannerController, using: ThreeDSView().swiftEntryAttributes())
                }
            }else {
                self.delegate?.onError?(data: "{\"error\":\"The user didn't approve accessing the camera.\"}")
            }
        }
    }
    
    //MARK: - Public init methods
    /*///  configures the tap card sdk with the needed configurations for it to work
    ///  - Parameter config: The configurations model
    ///  - Parameter delegate:A protocol that allows integrators to get notified from events fired from Tap card sdk
    ///  - Parameter presentScannerIn: We will need a reference to the controller that we can present from the card scanner feature
    @objc public func initTapCardSDK(config: TapCardConfiguration, delegate: TapCardViewDelegate? = nil, presentScannerIn:UIViewController? = nil) {
        self.delegate = delegate
        config.operatorModel = .init(publicKey: config.publicKey, metadata: generateApplicationHeader())
        
        self.presentScannerIn = presentScannerIn
        do {
            try openUrl(url: URL(string: generateTapCardSdkURL(from: config)))
        }catch {
            self.delegate?.onError?(data: "{error:\(error.localizedDescription)}")
        }
    }*/
    
    ///  configures the tap card sdk with the needed configurations for it to work
    ///  - Parameter config: The configurations dctionary. Recommended, as it will make you able to customly add models without updating
    ///  - Parameter delegate:A protocol that allows integrators to get notified from events fired from Tap card sdk
    ///  - Parameter presentScannerIn: We will need a reference to the controller that we can present from the card scanner feature
    @objc public func initTapCardSDK(configDict: [String : Any], delegate: TapCardViewDelegate? = nil, presentScannerIn:UIViewController? = nil, cardNumber:String = "", cardExpiry:String = "") {
        
        self.delegate = delegate
        self.presentScannerIn = presentScannerIn ?? self.parentViewController
        // Remove any non numerical charachters for passed card number and date
        self.cardNumber = cardNumber.tap_byRemovingAllCharactersExcept("0123456789")
        self.cardExpiry = cardExpiry.tap_byRemovingAllCharactersExcept("0123456789/")
        
        // We will have to add app related information to the request
        var updatedConfigurations:[String:Any] = configDict
        updatedConfigurations["headers"] = generateApplicationHeader()
        // We will have to force NFC to false in iOS
        self.update(dictionary: &updatedConfigurations, at: ["features","alternativeCardInputs","cardNFC"], with: false)
        
        do {
            try openUrl(url: URL(string: generateTapCardSdkURL(from: updatedConfigurations)))
        }
        catch {
            self.delegate?.onError?(data: "{error:\(error.localizedDescription)}")
        }
    }
    
    /*///  configures the tap card sdk with the needed configurations for it to work
    ///  - Parameter config: The configurations string json format. Recommended, as it will make you able to customly add models without updating
    ///  - Parameter delegate:A protocol that allows integrators to get notified from events fired from Tap card sdk
    ///  - Parameter presentScannerIn: We will need a reference to the controller that we can present from the card scanner feature
    @objc public func initTapCardSDK(configString: String, delegate: TapCardViewDelegate? = nil, presentScannerIn:UIViewController? = nil) {
        self.delegate = delegate
        self.presentScannerIn = presentScannerIn
        openUrl(url: URL(string: generateTapCardSdkURL(from: configString))!)
    }*/
    
    
    //MARK: - Public interfaces
    
    /// Wil start the process of generating a `TapToken` with the current card data
    @objc public func generateTapToken() {
        // Let us instruct the card sdk to start the tokenizaion process
        endEditing(true)
        webView?.evaluateJavaScript("window.generateTapToken()")
    }
    
    private func update(dictionary dict: inout [String: Any], at keys: [String], with value: Any) {

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
