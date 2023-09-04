import CryptoKit
import Foundation

extension String {
    // To generate MD5 for Marvel API
    var md5: String {
        let hash = Insecure.MD5.hash(data: data(using: .utf8) ?? Data())

        return hash.map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
