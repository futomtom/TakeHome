import Foundation

struct Character: Decodable, Identifiable, Equatable, Hashable {
    let id: Int
    let name, description: String?
    let thumbnail: Thumbnail?

    var Id: String {
        "\(id)"
    }

    var imageURL: URL {
        guard let thumbnail = thumbnail else {
            return Character.noImageURL
        }

        return URL(string: thumbnail.urlString) ?? Character.noImageURL
    }

    var safeName: String { name ?? "" }

    var hasThumbnail: Bool {
        !(thumbnail?.path?.hasSuffix("image_not_available") ?? false)
    }

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}
