//
//  TapCardView+Scanner.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 10/09/2023.
//

import Foundation
import TapCardScannerWebWrapper_iOS
import TapCardVlidatorKit_iOS
import SharedDataModels_iOS

extension TapCardView: TapScannerDataSource, TapCreditCardScannerViewControllerDelegate {
    public func allowedCardBrands() -> [CardBrand] {
        return CardBrand.allCases
    }
    
    public func creditCardScannerViewControllerDidCancel(_ viewController: TapCardScannerWebWrapper_iOS.TapFullScreenScannerViewController) {
        
    }
    
    public func creditCardScannerViewController(_ viewController: TapCardScannerWebWrapper_iOS.TapFullScreenScannerViewController, didErrorWith error: Error) {
        
    }
    
    public func creditCardScannerViewController(_ viewController: TapCardScannerWebWrapper_iOS.TapFullScreenScannerViewController, didFinishWith card: TapCard) {
        
    }
    
    
}
