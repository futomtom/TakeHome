import Foundation

struct Character: Decodable, Identifiable, Equatable, Hashable {
    let id: Int
    let name, description: String?
    let thumbnail: Thumbnail?
    let comics: SubInfo?
    let events: SubInfo?

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

    func getTitle(for tab: TabMode) -> String {
        if tab == .comics, let comics {
            return "\(comics.count)"
        } else if tab == .events, let events {
            return "\(events.count)"
        }
        return ""
    }

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}
