import Foundation

struct Character: Decodable, Identifiable, Equatable {
    let id: Int?
    let name, description: String?
    let thumbnail: Thumbnail?
    let comics: SubInfo?
    let events: SubInfo?

    var imageURL: URL {
        guard let thumbnail = thumbnail else {
            return Character.noImageURL
        }
        return URL(string: "\(thumbnail.path ?? "").\(thumbnail.thumbnailExtension ?? "")") ?? Character.noImageURL
    }

    var safeName: String { name ?? "" }

    var hasThumbnail: Bool {
        !(thumbnail?.path?.hasSuffix("image_not_available") ?? false)
    }

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id && lhs.id != nil
    }
}

// MARK: Helper Decodable struct

extension Character {
    struct Thumbnail: Codable {
        let path: String?
        let thumbnailExtension: String?

        enum CodingKeys: String, CodingKey {
            case path
            case thumbnailExtension = "extension"
        }
    }

    struct SubInfo: Codable {
        let returned: Int
        let collectionURI: String?
    }
}

// MARK: mock data

extension Character {
    static let noImageURL = URL(fileURLWithPath: Bundle.main.path(forResource: "noImage", ofType: "jpg")!)

    static var mock: [Character] {
        let numbers = Array(1 ... 20)
        let thumbnail = Character.Thumbnail(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
            thumbnailExtension: "jpg"
        )
        let description = "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!"

        return numbers.map { index in
            Character(
                id: index,
                name: "Captain America",
                description: description,
                thumbnail: thumbnail,
                comics: SubInfo(returned: 12, collectionURI: "http://mock"),
                events: SubInfo(returned: 22, collectionURI: "http://mock")
            )
        }
    }
}
