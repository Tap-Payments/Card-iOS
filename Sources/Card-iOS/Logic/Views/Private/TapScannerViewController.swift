//
//  TapScannerViewController.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 10/09/2023.
//

import UIKit
import TapCardScannerWebWrapper_iOS
import TapCardVlidatorKit_iOS
import SnapKit
import SharedDataModels_iOS

/// A protocol to listen to the events fired from the full screen controllr
internal protocol TapScannerViewControllerDelegate {
    /// A card scanned
    /// - Parameter with card: The tap card fetcehd from the scanner
    /// - Parameter and scanner: The scanner view controller
    func cardScanned(with card:TapCard, and scanner:TapScannerViewController)
}

/// A view controller that displays the camera feed + the card scanner within the middle of the screen
internal class TapScannerViewController: UIViewController {
    /// The inline scanner responsible for showing the embedded camera feed
    lazy var tapInlineScanner:TapInlineCardScanner = .init(dataSource:self)
    var previewView:UIView = .init(frame: .zero)
    /// A protocol to listen to the events fired from the full screen controllr
    var delegate:TapScannerViewControllerDelegate?
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.backgroundColor = .clear
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 1
        blurView.frame = .zero
        blurView.backgroundColor = .clear
        view.insertSubview(blurView, at: 0)
        
        view.addSubview(previewView)
        
        previewView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        blurView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        previewView.setNeedsLayout()
        previewView.updateConstraints()
        blurView.setNeedsLayout()
        blurView.updateConstraints()
        view.setNeedsLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tapInlineScanner.delegate = self
        do{
            try tapInlineScanner.startScanning(in: previewView, scanningBorderColor: .green, blurBackground: true,showTapCorners: true, timoutAfter: -1)
        }catch{
            
        }
        
        //view.bringSubviewToFront(previewView)
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

extension TapScannerViewController:TapScannerDataSource, TapInlineScannerProtocl {
    func tapFullCardScannerDimissed() {
        dismiss(animated: true)
    }
    
    func allowedCardBrands() -> [CardBrand] {
        return CardBrand.allCases
    }
    
    func tapCardScannerDidFinish(with tapCard: TapCard) {
        delegate?.cardScanned(with: tapCard, and: self)
    }
    
    func tapInlineCardScannerTimedOut(for inlineScanner: TapInlineCardScanner) {
        dismiss(animated: true)
    }
}
