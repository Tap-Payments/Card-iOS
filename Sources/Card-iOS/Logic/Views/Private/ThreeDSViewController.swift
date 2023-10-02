//
//  ThreeDSViewController.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 12/09/2023.
//

import UIKit
import WebKit
import SnapKit
import SwiftEntryKit
import SharedDataModels_iOS

class ThreeDSView: UIView {

    /// The web view used to render the 3ds page
    var webView: WKWebView?
    /// The details containitng both threeds and redirect urls
    var cardRedirectionData:CardRedirection = .init()
    /// The timer used to check if no redirection is being called for the last 3 seconds
    var timer: Timer?
    /// The delay that we should wait for to decide if it is idle in  seonds
    var delayTime:CGFloat = 3.000
    /// A custom action block to execute when nothing else being loaded for a while
    var idleForWhile:()->() = {}
    /// A custom action block to execute when nothing else being loaded for a while
    var redirectionReached:(String)->() = { _ in }
    /// A custom action block to execute when the user cancels the authentication
    var threeDSCanceled:()->() = {}
    /// The powered by tap view
    var poweredByTapView:PoweredByTapView = .init(frame: .zero)
    /// Represents the locale needed to render the powered by tap view with
    var selectedLocale:String = "en" {
        didSet{
            self.poweredByTapView.selectedLocale = selectedLocale
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
        themeController()
        themeWebView()
        webViewConstraints()
        poweredByTapViewConstraints()
        poweredByTapView.backButtonClicked = {
            self.threeDSCanceled()
        }
    }
    
    
    /// Starts loading the urls
    func startLoading() {
        webView?.load(URLRequest(url: URL(string: cardRedirectionData.threeDsUrl!)!))
    }
}


// MARK: - UI & Constraints
extension ThreeDSView {
    /// Applies theme on controller level
    func themeController() {
        backgroundColor = .clear
    }
    
    /// Applies theme on web view level
    func themeWebView() {
        webView = .init(frame: .zero)
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.white
        webView?.scrollView.backgroundColor = UIColor.clear
        webView?.scrollView.bounces = false
        webView?.navigationDelegate = self
        webView?.layer.cornerRadius = 0
        webView?.clipsToBounds = true
    }
    /// Applies constrains to correctly size and position the web view
    func webViewConstraints() {
        addSubview(webView!)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.snp.remakeConstraints({ make in
            make.top.equalToSuperview().offset(56)
            make.bottom.equalToSuperview()//.offset(80)
            //make.height.equalTo(500)
            make.leading.equalToSuperview()//.offset(10)
            make.trailing.equalToSuperview()//.offset(100)
            //make.width.equalTo(500)
           // make.height.equalTo(self.webView!.snp.width)
        })
        
        DispatchQueue.main.async {
            self.webView?.setNeedsLayout()
            self.webView?.updateConstraints()
            self.setNeedsLayout()
        }
    }
    
    
    /// Applies constrains to correctly size and position the web view
    func poweredByTapViewConstraints() {
        addSubview(poweredByTapView)
        sendSubviewToBack(poweredByTapView)
        poweredByTapView.translatesAutoresizingMaskIntoConstraints = false
        poweredByTapView.snp.remakeConstraints({ make in
            make.height.equalTo(56)
            make.bottom.equalTo(self.webView!.snp.top).offset(12)
            make.leading.equalToSuperview()//.offset(10)
            make.trailing.equalToSuperview()//.offset(-10)
        })
        
        DispatchQueue.main.async {
            self.poweredByTapView.setNeedsLayout()
            self.poweredByTapView.updateConstraints()
            self.setNeedsLayout()
        }
    }
}

// MARK: - WebView delegate
extension ThreeDSView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Check if it is the return url
        
        if let requestURL:URL = navigationAction.request.url,
           let triggerKeyword:String = cardRedirectionData.keyword,
           let waitedKeyword:String = triggeringValue(from: requestURL, with: triggerKeyword),
           !waitedKeyword.isEmpty {
            self.redirectionReached(requestURL.absoluteString)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let timer = timer {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: false, block: { (timer) in
            timer.invalidate()
            self.idleForWhile()
        })
    }
    
    
    
    func triggeringValue(from url:URL, with triggeringKeyword:String) -> String? {
        return tap_extractDataFromUrl(url,for:triggeringKeyword, shouldBase64Decode: false)
    }
}


// MARK: - Popup UI and Methods
extension ThreeDSView {
    
    
    func swiftEntryAttributes() -> EKAttributes {
        
        var attributes = EKAttributes.bottomFloat
        attributes.entryBackground = .clear
        attributes.screenBackground = .color(color: .init(light: .init(white: 0, alpha: 0.6), dark: .init(red: 0.108, green: 0.108, blue: 0.108, alpha: 0.75)))//.visualEffect(style: .standard)
        attributes.displayDuration = .infinity
        //attributes.popBehavior = .animated(animation: .init(fade: .init(from: 0, to: 1, duration: 2.0, delay: 2.0)))
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.25, radius: 5, offset: .zero))
        attributes.name = "TapOtpCodeWebEntry"
        // Give the entry the width of the screen minus 20pts from each side, the height is decided by the content's contraint's
        attributes.positionConstraints.size = .init(width: .fill, height: .ratio(value: 0.90))//.constant(value: 500))
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .forward
        attributes.roundCorners = .all(radius: 8)
        attributes.positionConstraints.verticalOffset = -50
        //attributes.positionConstraints.hasVerticalOffset = false
        attributes.positionConstraints.safeArea = .overridden
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
        //attributes.entranceAnimation = .init(
          //  fade: .init(from: 0.5, to: 1, duration: 0.5))
        
        //attributes.exitAnimation = .init(
          //  fade: .init(from: 1, to: 0.5, duration: 0.5))

        return attributes
    }
    
}
