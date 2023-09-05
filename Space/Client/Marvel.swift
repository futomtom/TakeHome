import Foundation

struct Marvel {
    private let credential: Marvel.Credentials = Marvel.getCredentials()
    var endPoint: EndPoint = .dummy

    enum EndPoint {
        case dummy
        case characters
        case comics(String)
        case events(String)
    }

    var path: String {
        switch endPoint {
        case .characters:
            return "characters"
        case let .comics(characterId: characterId):
            return "characters/\(characterId)/comics"
        case let .events(characterId: characterId):
            return "characters/\(characterId)/events"
        case .dummy:
            return ""
        }
    }

    func makeURL(_ offset: Int = 0) -> URL? {
        let base = "https://gateway.marvel.com/v1/public/"

        let timeStamp = "1" // \(Date().timeIntervalSince1970)"
        let hash: String = (timeStamp + credential.privateKey + credential.publicKey).md5
        let urlString = base + path
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
