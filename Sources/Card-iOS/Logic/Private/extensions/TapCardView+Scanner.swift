//
//  TapCardView+Scanner.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 10/09/2023.
//

import Foundation
import SharedDataModels_iOS

extension TapCardView: TapScannerViewControllerDelegate {
    
    func cardScanned(with card: TapCard, and scanner: TapScannerViewController) {
        scanner.dismiss(animated: true) {
            self.handleScanner(with: card)
        }
    }
}
