import Foundation

struct Marvel {
    private let credential: Marvel.Credentials = Marvel.getCredentials()
    var endPoint: EndPoint

    enum EndPoint {
        case characters
        case comics
        case events
    }

    func getPath(with characterId: String) -> String {
        switch endPoint {
        case .characters:
            return "characters"
        case .comics:
            return "characters/\(characterId)/comics"
        case .events:
            return "characters/\(characterId)/events"
        }
    }

    func makeURL(_ offset: Int = 0, charId: String = "") -> URL? {
        let base = "https://gateway.marvel.com/v1/public/"

        let timeStamp = "1" // \(Date().timeIntervalSince1970)"
        let hash: String = (timeStamp + credential.privateKey + credential.publicKey).md5
        let urlString = base + getPath(with: charId)
        /// Add default query params
        let queryParamsList: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: credential.publicKey),
            URLQueryItem(name: "ts", value: timeStamp),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        var components = URLComponents(string: urlString)
        components?.queryItems = queryParamsList
        return components?.url
    }
}

// MARK: - Credentials

extension Marvel {
    struct Credentials {
        let publicKey: String
        let privateKey: String
    }

    private static func getCredentials() -> Credentials {
        let fileName = "Configuration"
        let privateKeyName = "privateKey"
        let publicKeyName = "publicKey"
        // We use force unwrap, since this is more a initial setup
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")!

        let data = FileManager.default.contents(atPath: path)!

        let dictionary = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String]

        return Credentials(
            publicKey: dictionary?[publicKeyName] ?? "",
            privateKey: dictionary?[privateKeyName] ?? ""
        )
    }
}
