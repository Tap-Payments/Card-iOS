//
//  File.swift
//  
//
//  Created by Osama Rabie on 17/09/2023.
//

import Foundation

internal extension Bundle {
    static var currentBundle:Bundle {
        let bundleName = "Tap-Card-SDK_Tap-Card-SDK"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: TapCardView.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named BioSwift_BioSwift")
    }
}
