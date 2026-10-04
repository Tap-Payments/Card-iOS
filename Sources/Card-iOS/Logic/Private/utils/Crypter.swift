//
//  Crypter.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 13/09/2023.
//

import Foundation
import Security

/// Crypter helper class.
/// Uses the Security framework directly (no third party RSA wrapper), so no
/// Objective-C class names are exported that could clash with system classes.
class Crypter {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Encrypts the given string using the given key.
    ///
    /// - Parameters:
    ///   - string: String to encrypt.
    ///   - key: PEM (or bare base64 DER) RSA public key to encrypt with.
    /// - Returns: Base64 string if the encryption succeed.
    static func encrypt(_ string: String, using key: String) -> String? {
        
        guard let secKey = publicSecKey(fromPEM: key),
              let clear = string.data(using: .utf8) else { return nil }
        
        while true {
            guard let encrypted = encryptPKCS1(clear, with: secKey) else { return nil }
            let resultString = encrypted.base64EncodedString()
            if !resultString.hasSuffix("AA==") {
                return resultString
            }
        }
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    /// RSA PKCS#1 v1.5 encryption, chunked by the key's block size.
    private static func encryptPKCS1(_ data: Data, with key: SecKey) -> Data? {
        let maxChunk = SecKeyGetBlockSize(key) - 11
        guard maxChunk > 0 else { return nil }
        var result = Data()
        var offset = 0
        repeat {
            let end = min(offset + maxChunk, data.count)
            let chunk = data.subdata(in: offset..<end)
            var error: Unmanaged<CFError>?
            guard let encrypted = SecKeyCreateEncryptedData(key, .rsaEncryptionPKCS1, chunk as CFData, &error) as Data? else {
                return nil
            }
            result.append(encrypted)
            offset = end
        } while offset < data.count
        return result
    }
    
    private static func publicSecKey(fromPEM pem: String) -> SecKey? {
        let base64 = pem
            .components(separatedBy: .newlines)
            .filter { !$0.hasPrefix("-----") }
            .joined()
        guard let der = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
              let pkcs1 = stripSPKIHeader(der) else { return nil }
        let attributes: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic
        ]
        return SecKeyCreateWithData(pkcs1 as CFData, attributes as CFDictionary, nil)
    }
    
    /// Accepts either an X.509 SubjectPublicKeyInfo or a bare PKCS#1 RSAPublicKey
    /// and returns the PKCS#1 RSAPublicKey bytes expected by `SecKeyCreateWithData`.
    private static func stripSPKIHeader(_ der: Data) -> Data? {
        let bytes = [UInt8](der)
        var index = 0
        
        func readLength() -> Int? {
            guard index < bytes.count else { return nil }
            let first = bytes[index]; index += 1
            if first & 0x80 == 0 { return Int(first) }
            let count = Int(first & 0x7F)
            guard count > 0, count <= 4, index + count <= bytes.count else { return nil }
            var length = 0
            for _ in 0..<count { length = (length << 8) | Int(bytes[index]); index += 1 }
            return length
        }
        
        guard index < bytes.count, bytes[index] == 0x30 else { return nil }   // outer SEQUENCE
        index += 1
        guard readLength() != nil, index < bytes.count else { return nil }
        
        // Already PKCS#1: SEQUENCE { INTEGER modulus, INTEGER exponent }
        if bytes[index] == 0x02 { return der }
        
        // SPKI: SEQUENCE { algorithm SEQUENCE, BIT STRING { 0x00, RSAPublicKey } }
        guard bytes[index] == 0x30 else { return nil }
        index += 1
        guard let algLength = readLength() else { return nil }
        index += algLength
        guard index < bytes.count, bytes[index] == 0x03 else { return nil }
        index += 1
        guard let bitLength = readLength(), bitLength > 1,
              index + bitLength <= bytes.count, bytes[index] == 0x00 else { return nil }
        index += 1
        return Data(bytes[index..<(index + bitLength - 1)])
    }
}
