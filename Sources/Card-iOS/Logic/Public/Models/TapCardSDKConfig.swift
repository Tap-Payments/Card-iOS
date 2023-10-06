//
//  WebCardSDKConfig.swift
//  TapCardCheckOutKit
//
//  Created by MahmoudShaabanAllam on 06/09/2023.
//

import Foundation
import SharedDataModels_iOS
//import TapCardVlidatorKit_iOS
//import CommonDataModelsKit_iOS


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tapCardConfiguration = try TapCardConfiguration(json)

import Foundation

// MARK: - TapCardConfiguration
/// A configuration model for the sdk parameters
@objcMembers public class TapCardConfiguration: NSObject, Codable {
    /// The Tap public key
    public var publicKey: String?
    /// The encrypted headers
    internal var operatorModel:Operator? {
        didSet{
            headers = operatorModel?.metadata
            operatorModel?.metadata = [:]
        }
    }
    /// The scope of the card sdk. Default is generating a tap token
    public var scope: Scope = .Token
    /// The Tap merchant details
    public var merchant: Merchant?
    /// The transaction details
    public var transaction: Transaction?
    /// The authentication data, needed only if scope is set to Authenticate
    public var authentication: Authentication?
    /// The Tap customer details
    public var customer: Customer?
    /// The acceptance details for the transaction
    public var acceptance: Acceptance?
    /// Defines the fields visibility
    public var fields: Fields?
    /// Defines some UI/UX addons enablement
    public var addons: Addons?
    /// Defines some UI related configurations
    public var interface: Interface?
    /// headers values to share unqieu device and bundle data to the card web sdk
    internal var headers:[String:String]?
    
    /**
     Creates a configuration model to be passed to the SDK
     - Parameters:
        - publicKey: The Tap public key
        - scope: The scope of the card sdk. Default is generating a tap token
        - merchant: The Tap merchant details
        - transaction: The transaction details
        - authenticate: The authentication data, needed only if scope is set to Authenticate
        - customer: The Tap customer details
        - acceptance: The acceptance details for the transaction
        - fields: Defines the fields visibility
        - addons: Defines some UI/UX addons enablement
        - interface: Defines some UI related configurations
     */
    @objc public init(publicKey: String?, scope: Scope = .Token, merchant: Merchant? = .init(id: ""), transaction: Transaction?, authentication: Authentication?, customer: Customer?, acceptance: Acceptance? = .init(supportedBrands: [], supportedCards: ["DEBIT","CREDIT"]), fields: Fields? = .init(cardHolder: true), addons: Addons? = .init(displayPaymentBrands: true, loader: true, saveCard: false), interface: Interface? = .init(locale: "dynamic", theme: "dynamic", edges: "curved", direction: "dynamic")) {
        self.publicKey = publicKey
        self.scope = scope
        self.merchant = merchant
        self.transaction = transaction
        self.authentication = authentication
        self.customer = customer
        self.acceptance = acceptance
        self.fields = fields
        self.addons = addons
        self.interface = interface
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case operatorModel  = "operator"
        case publicKey, scope, merchant, transaction, authentication, customer, acceptance, fields, addons, interface, headers
    }
}

// MARK: TapCardConfiguration convenience initializers and mutators

extension TapCardConfiguration {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(TapCardConfiguration.self, from: data)
        self.init(publicKey: me.publicKey, scope: me.scope, merchant: me.merchant, transaction: me.transaction, authentication: me.authentication, customer: me.customer, acceptance: me.acceptance, fields: me.fields, addons: me.addons, interface: me.interface)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        publicKey: String?? = nil,
        scope: Scope = .Token,
        merchant: Merchant?? = nil,
        transaction: Transaction?? = nil,
        authentication: Authentication?? = nil,
        customer: Customer?? = nil,
        acceptance: Acceptance?? = nil,
        fields: Fields?? = nil,
        addons: Addons?? = nil,
        interface: Interface?? = nil
    ) -> TapCardConfiguration {
        return TapCardConfiguration(
            publicKey: publicKey ?? self.publicKey,
            scope: scope,
            merchant: merchant ?? self.merchant,
            transaction: transaction ?? self.transaction,
            authentication: authentication ?? self.authentication,
            customer: customer ?? self.customer,
            acceptance: acceptance ?? self.acceptance,
            fields: fields ?? self.fields,
            addons: addons ?? self.addons,
            interface: interface ?? self.interface
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
