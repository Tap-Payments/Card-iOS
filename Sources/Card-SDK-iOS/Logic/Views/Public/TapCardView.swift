//
//  WebCardView.swift
//  TapCardCheckOutKit
//
//  Created by MahmoudShaabanAllam on 07/09/2023.
//

import UIKit
import WebKit
import SnapKit
import Lottie
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
    /// A lottie animation to provide the shimmering loading before rendering
    internal var animationView: LottieAnimationView?
    /// Defines the base url for the Tap card sdk
    internal static let tapCardBaseUrl:String = "https://demo.dev.tap.company/v2/sdk/checkout?type=card-iframe&configurations="
    /// Defines the scanner object to be called whenever needed
    internal var fullScanner:TapFullScreenScannerViewController?
    /// Defines the UIViewController passed from the parent app to present the scanner controller within
    internal var presentScannerIn:UIViewController? = nil
    /// keeps a hold of the loaded web sdk configurations url
    internal var currentlyLoadedCardConfigurations:URL?
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
        setupShimmeringView()
        setupConstraints()
    }
    
    
    /// Used to open a url inside the Tap card web sdk.
    /// - Parameter url: The url needed to load.
    private func openUrl(url: URL?) {
        // Store it for further usages
        currentlyLoadedCardConfigurations = url
        // First let us hide the web view and show the loading view
        //webView?.isHidden = true
        Task {
            await reAdjustShimmeringView(with: url)
        }
        
        //animationView?.isHidden = false
        //self.animationView?.isHidden = false
        self.updateShimmerView(with: true)
        // Second, instruct the web view to load the needed url
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
        webView?.isHidden = true
        // Let us add it to the view
        self.backgroundColor = .clear
        self.addSubview(webView!)
    }
    
    /// used to setup the constraint of the shimmerling loading view
    private func setupShimmeringView() {
        // let us load the correct shimmerling lottie json file
        Task {
            let animationCachProvider:AnimationCacheProvider = DefaultAnimationCache()
            await animationCachProvider.setAnimation(.loadedFrom(url: URL(string: "https://tap-assets.b-cdn.net/card-sdk/shimmer/Light_Mode_Button_Loader.json")!)!, forKey: "animLight")
            await animationCachProvider.setAnimation(.loadedFrom(url: URL(string: "https://tap-assets.b-cdn.net/card-sdk/shimmer/Dark_Mode_Button_Loader.json")!)!, forKey: "animDark")
        }
        animationView = .init(url: URL(string: "https://tap-assets.b-cdn.net/card-sdk/shimmer/\(UIView().traitCollection.userInterfaceStyle == .dark ? "Dark_Mode_Button_Loader" : "Light_Mode_Button_Loader").json")!, closure: { error in
            if let _ = error {
                self.animationView = .init(name: UIView().traitCollection.userInterfaceStyle == .dark ? "Dark_Mode_Button_Loader" : "Light_Mode_Button_Loader", bundle: Bundle.currentBundle)
            }
        })
        
        // let us set the needed configuratons for the shimmering view
        animationView!.frame = .zero
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.75
        // Add it to the view
        self.addSubview(animationView!)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.animationView!.play()
        }
    }
    
    /// Will recolor and adjust the corners of teh shimmerig view basde on the configurations
    /// - Parameters url; The url that contains the configurations passed to the web card sdk
    private func reAdjustShimmeringView(with url:URL?) async {
        // First set the light/dark based on the card theme
        animationView?.animation = await .loadedFrom(url: URL(string: "https://tap-assets.b-cdn.net/card-sdk/shimmer/\(getCardTheme() == "dark" ? "Dark_Mode_Button_Loader" : "Light_Mode_Button_Loader").json")!)// .named(getCardTheme() == "dark" ? "Dark_Mode_Button_Loader" : "Light_Mode_Button_Loader", bundle: Bundle.currentBundle)
            
        
        // Second set the curves based on the card edges
        animationView?.layer.cornerRadius = getCardEdges() == "curved" ? 8 : 0
        animationView?.clipsToBounds = true
        
        animationView?.play()
    }
    
    
    /// Setup Constaraints for the sub views.
    private func setupConstraints() {
        // Defensive coding
        guard let webView = self.webView,
        let animationView = self.animationView else {
            return
        }
        
        // Preprocessing needed setup
        webView.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        // Define the web view constraints
        let top  = webView.topAnchor.constraint(equalTo: self.topAnchor)
        let left = webView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let right = webView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bottom = webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let cardHeight = self.heightAnchor.constraint(greaterThanOrEqualToConstant: 95)
        
        // Define the shimmering view constraints
        let topanimationView  = animationView.topAnchor.constraint(equalTo: self.webView!.topAnchor)
        let leftanimationView = animationView.leftAnchor.constraint(equalTo: self.webView!.leftAnchor)
        let rightanimationView = animationView.rightAnchor.constraint(equalTo: self.webView!.rightAnchor)
        let shimmerHeight = self.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        
        // Activate the constraints
        NSLayoutConstraint.activate([left, right, top, bottom, cardHeight])
        NSLayoutConstraint.activate([leftanimationView, rightanimationView, topanimationView, shimmerHeight])
    }
    
    /// Decides which lottie json animation file to be used based on the current theme of the device
    internal func setAnimationLoader() {
        if self.traitCollection.userInterfaceStyle == .dark {
            animationView?.animation = .named("Dark_Mode_Button_Loader", bundle: Bundle.currentBundle)
        }else{
            animationView?.animation = .named("Light_Mode_Button_Loader", bundle: Bundle.currentBundle)
        }
    }
    
    /// Auto adjusts the height of the card view
    /// - Parameter to newHeight: The new height the card view should expand/shrink to
    internal func changeHeight(to newHeight:Double?) {
        // make sure we are in the main thread
        DispatchQueue.main.async {
            // move to the new height or safely to the default height
            self.snp.updateConstraints { make in
                make.height.equalTo(newHeight ?? 95)
            }
            // Update the layout of the affected views
            self.layoutIfNeeded()
            self.updateConstraints()
            self.layoutSubviews()
            self.webView?.layoutIfNeeded()
            self.animationView?.layoutIfNeeded()
            self.delegate?.onHeightChange?(height: newHeight ?? 95)
        }
    }
    
    
    internal func updateShimmerView(with visibility:Bool) {
        //var originalAnimationViewAlpha:CGFloat = 0
        var finalAnimationViewAlpha:CGFloat = 0
        
        //var originalCardViewAlpha:CGFloat = 0
        var finalCardViewAlpha:CGFloat = 0
        
        if visibility {
            //originalAnimationViewAlpha = 0
            finalAnimationViewAlpha = 1
            
            //originalCardViewAlpha = 1
            finalCardViewAlpha = 0
            self.animationView?.play()
        }else {
            //originalAnimationViewAlpha = 1
            finalAnimationViewAlpha = 0
            
            //originalCardViewAlpha = 0
            finalCardViewAlpha = 1
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.animationView?.alpha = finalAnimationViewAlpha
                self.webView?.alpha = finalCardViewAlpha
            } completion: { _ in
                self.animationView?.isHidden = !visibility
                self.webView?.isHidden = visibility
            }
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
            self.animationView?.alpha = 1
            self.webView?.alpha = 0
            
            self.animationView?.isHidden = false
            self.webView?.isHidden = false
            
            self.updateShimmerView(with: false)
            self.delegate?.onReady?()
        }
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
    @objc public func initTapCardSDK(configDict: [String : Any], delegate: TapCardViewDelegate? = nil, presentScannerIn:UIViewController? = nil) {
        self.delegate = delegate
        self.presentScannerIn = presentScannerIn
        let operatorModel:Operator = .init(publicKey: configDict["publicKey"] as? String ?? "", metadata: generateApplicationHeader())
        var updatedConfigurations:[String:Any] = configDict
        updatedConfigurations["operator"] = ["publicKey":operatorModel.publicKey ?? "",
                                             "metaData":[:]]
        updatedConfigurations["headers"] = operatorModel.metadata
        
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
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
        setAnimationLoader()
    }
}

