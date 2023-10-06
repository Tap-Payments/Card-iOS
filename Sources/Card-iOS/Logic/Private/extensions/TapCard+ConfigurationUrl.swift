//
//  TapCard+ConfigurationUrl.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 13/09/2023.
//

import Foundation
import SharedDataModels_iOS

internal extension TapCardView {
    
    /// Fetch the localisation selected by the parent app for the card sdk
    func getCardLocale() -> String {
        /// Let us make sure we can get a correctly passed locale from the configurations
        if let configurationUrl:URL = currentlyLoadedCardConfigurations {
            // Is it a correct json
            let configurationsString:String = tap_extractDataFromUrl(configurationUrl,for: "configurations", shouldBase64Decode: false).lowercased()
            if let configurationData = configurationsString.data(using: .utf8),
               let configurationDictionary: [String:Any] = try? JSONSerialization.jsonObject(with: configurationData, options: []) as? [String: Any],
               // Did the merchant pass an interface
               let interfaceDictionary:[String:Any] = configurationDictionary["interface"] as? [String:Any],
               // Did the merchant pass a locale
               let selectedLocale:String = interfaceDictionary["locale"] as? String {
                return selectedLocale.lowercased()
            }
        }
        // The default case
        return "en"
    }
    
    
    /// Fetch the localisation selected by the parent app for the card sdk
    func getCardTheme() -> String {
        /// Let us make sure we can get a correctly passed locale from the configurations
        if let configurationUrl:URL = currentlyLoadedCardConfigurations {
            // Is it a correct json
            let configurationsString:String = tap_extractDataFromUrl(configurationUrl,for: "configurations", shouldBase64Decode: false).lowercased()
            if let configurationData = configurationsString.data(using: .utf8),
               let configurationDictionary: [String:Any] = try? JSONSerialization.jsonObject(with: configurationData, options: []) as? [String: Any],
               // Did the merchant pass an interface
               let interfaceDictionary:[String:Any] = configurationDictionary["interface"] as? [String:Any],
               // Did the merchant pass a locale
               let selectedTheme:String = interfaceDictionary["theme"] as? String {
                return selectedTheme.lowercased()
            }
        }
        // The default case
        return "light"
    }
    
    
    /// Fetch the localisation selected by the parent app for the card sdk
    func getCardEdges() -> String {
        /// Let us make sure we can get a correctly passed locale from the configurations
        if let configurationUrl:URL = currentlyLoadedCardConfigurations {
            // Is it a correct json
            let configurationsString:String = tap_extractDataFromUrl(configurationUrl,for: "configurations", shouldBase64Decode: false).lowercased()
            if let configurationData = configurationsString.data(using: .utf8),
               let configurationDictionary: [String:Any] = try? JSONSerialization.jsonObject(with: configurationData, options: []) as? [String: Any],
               // Did the merchant pass an interface
               let interfaceDictionary:[String:Any] = configurationDictionary["interface"] as? [String:Any],
               // Did the merchant pass a locale
               let selectedEdges:String = interfaceDictionary["edges"] as? String {
                return selectedEdges.lowercased()
            }
        }
        // The default case
        return "curved"
    }
    
    
    /// Fetch the localisation selected by the parent app for the card sdk
    func getCardKey() -> String {
        /// Let us make sure we can get a correctly passed locale from the configurations
        if let configurationUrl:URL = currentlyLoadedCardConfigurations {
            // Is it a correct json
            let configurationsString:String = tap_extractDataFromUrl(configurationUrl,for: "configurations", shouldBase64Decode: false).lowercased()
            if let configurationData = configurationsString.data(using: .utf8),
               let configurationDictionary: [String:Any] = try? JSONSerialization.jsonObject(with: configurationData, options: []) as? [String: Any],
               // Did the merchant pass an interface
               let interfaceDictionary:[String:Any] = configurationDictionary["operator"] as? [String:Any],
               // Did the merchant pass a locale
               let selectedKey:String = interfaceDictionary["publicKey"] as? String {
                return selectedKey.lowercased()
            }
        }
        // The default case
        return "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"
    }
}
