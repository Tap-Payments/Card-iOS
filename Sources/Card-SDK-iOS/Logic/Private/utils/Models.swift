//
//  Models.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 12/09/2023.
//

import Foundation

// MARK: - CardRedirection
/// The model expected to be fetched from the card web sdk when it sends the event of showing OTP/3ds page
struct CardRedirection: Codable {
    /// The 3DS/Otp page link we need to display
    var threeDsUrl: String?
    /// The url that we need to listen to, to detect the end of the authentication process
    var redirectUrl: String?
    /// The keyword we need to listen to know that this is the desired url that has the data post the current process
    var keyword:String?
}

// MARK: CardRedirection convenience initializers and mutators

extension CardRedirection {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CardRedirection.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        threeDsUrl: String?? = nil,
        redirectUrl: String?? = nil,
        keyword: String?? = nil
    ) -> CardRedirection {
        return CardRedirection(
            threeDsUrl: threeDsUrl ?? self.threeDsUrl,
            redirectUrl: redirectUrl ?? self.redirectUrl,
            keyword: keyword ?? self.keyword
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
