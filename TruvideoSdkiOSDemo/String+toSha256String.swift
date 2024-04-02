//
//  String+toSha256String.swift
//  TruvideoSdkiOSDemo
//
//  Created by Luis Francisco Piura Mejia on 2/4/24.
//

import Foundation
import CommonCrypto

extension String {
    /// Calculates the HMAC-SHA256 value for a given message using a key.
    ///
    /// - Parameters:
    ///    - msg: The message for which the HMAC will be calculated.
    ///    - key: The secret key used to calculate the HMAC.
    /// - Returns: The calculated HMAC-SHA256 value in hexadecimal format.
    func toSha256String(using key: String) -> String {
        let hmac256 = CCHmacAlgorithm(kCCHmacAlgSHA256)
        var macData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

        key.withCString { keyCString in
            withCString { msgCString in
                macData.withUnsafeMutableBytes { macDataBytes in
                    guard let keyBytes = UnsafeRawPointer(keyCString)?.assumingMemoryBound(to: UInt8.self),
                          let msgBytes = UnsafeRawPointer(msgCString)?.assumingMemoryBound(to: UInt8.self) else {
                        return
                    }

                    CCHmac(
                        hmac256,
                        keyBytes, Int(strlen(keyCString)),
                        msgBytes, Int(strlen(msgCString)),
                        macDataBytes.bindMemory(to: UInt8.self).baseAddress
                    )
                }
            }
        }

        return macData.map { String(format: "%02x", $0) }
            .joined()
    }
}
