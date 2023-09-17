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

/// A view controller that displays the camera feed + the card scanner within the middle of the screen
internal class TapScannerViewController: UIViewController {
    /// The inline scanner responsible for showing the embedded camera feed
    lazy var tapInlineScanner:TapInlineCardScanner = .init(dataSource:self)
    var previewView:UIView = .init(frame: .zero)
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
            make.width.equalToSuperview().offset(-100)
            make.height.equalTo(250)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tapInlineScanner.delegate = self
        do{
            try tapInlineScanner.startScanning(in: previewView, scanningBorderColor: .green, blurBackground: false,showTapCorners: true, timoutAfter: -1)
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
        
    }
    
    func allowedCardBrands() -> [CardBrand] {
        return CardBrand.allCases
    }
    
    func tapCardScannerDidFinish(with tapCard: TapCard) {
        let alert:UIAlertController = UIAlertController(title: "Scanned", message: "Card Number : \(tapCard.tapCardNumber ?? "")\nCard Name : \(tapCard.tapCardName ?? "")\nCard Expiry : \(tapCard.tapCardExpiryMonth ?? "")/\(tapCard.tapCardExpiryYear ?? "")\n", preferredStyle: .alert)
        let stopAlertAction:UIAlertAction = UIAlertAction(title: "Stop Scanning", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.pauseScanner(stopCamera: true)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let scanAgainAlertAction:UIAlertAction = UIAlertAction(title: "Scan Again", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.resumeScanner()
            }
        }
        alert.addAction(stopAlertAction)
        alert.addAction(scanAgainAlertAction)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){ [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func tapInlineCardScannerTimedOut(for inlineScanner: TapInlineCardScanner) {
        let alert:UIAlertController = UIAlertController(title: "TimeOut", message: "The timeout period ended and the scanner didn't get any card from the camera feed :(", preferredStyle: .alert)
        let stopAlertAction:UIAlertAction = UIAlertAction(title: "Stop Scanning", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.pauseScanner(stopCamera: true)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let scanAgainAlertAction:UIAlertAction = UIAlertAction(title: "Reset Timeout", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.resumeScanner()
                self?.tapInlineScanner.resetTimeOutTimer()
            }
        }
        alert.addAction(stopAlertAction)
        alert.addAction(scanAgainAlertAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
