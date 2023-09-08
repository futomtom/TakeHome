import Foundation

// MARK: Helper Decodable struct

extension Character {
    struct Thumbnail: Codable {
        let path: String?
        let fileExtension: String?

        enum CodingKeys: String, CodingKey {
            case path
            case fileExtension = "extension"
        }

        var urlString: String {
            "\(path ?? "").\(fileExtension ?? "")"
        }
    }

    struct SubInfo: Codable {
        let count: Int

        enum CodingKeys: String, CodingKey {
            case count = "returned"
        }
    }
}

// MARK: mock data

extension Character {
    static let noImageURL = URL(fileURLWithPath: Bundle.main.path(forResource: "noImage", ofType: "jpg")!)

    static var mock: [Character] {
        let numbers = Array(0 ... 10)
        let thumbnail = Character.Thumbnail(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
            fileExtension: "jpg"
        )
        let description = "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!"

        return numbers.map { index in
            Character(
                id: index + 1_017_574,
                name: "Captain America",
                description: description,
                thumbnail: thumbnail,
                comics: SubInfo(count: 12),
                events: SubInfo(count: 22)
            )
        }
    }
}
