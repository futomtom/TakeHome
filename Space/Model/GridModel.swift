import Foundation

@MainActor
final class GridModel: ObservableObject {
    @Published private(set) var characters: [Character]
    var charId: String = ""
    var total = 0

    private var offset = 0
    private var hasMore: Bool = true
    private var endPoint: Marvel.EndPoint

    init(_ endPoint: Marvel.EndPoint, characters: [Character] = []) {
        self.endPoint = endPoint
        self.characters = characters
    }

    func updateEndPoint(_ endPoint: Marvel.EndPoint) {
        self.endPoint = endPoint
    }

    func fetch(_ offset: Int = 0, client: MarvelProtocol = MarvelClient()) async throws {
        let marvelClient = MarvelClient()
        print("🙂fetch", dMsg, "offset", offset)
        let response = try? await marvelClient.fetch(endPoint: endPoint, offset, charId: charId)

        guard let response else {
            return
        }
        toModel(data: response.data)
    }

    private func toModel(data: PaginatedInfo<Character>) {
        // let newCharacters = data.results?.filter { $0.hasThumbnail } ?? []
        let newCharacters = data.results ?? []
        characters.append(contentsOf: newCharacters)
        offset = data.offset + data.count
        total = data.total
        hasMore = data.count == data.limit
    }

    func loadMoreIfCan(_ index: Int, _ character: Character) {
        guard canLoadMore(index, character) else {
            return
        }

        Task {
            print("🙂loadMore")
            try? await fetch(offset)
        }
    }

    private func canLoadMore(_ index: Int, _ character: Character) -> Bool {
        if characters.isLast(character) && hasMore {
            print("🙂 index", index)
            return true
        }
        return false
    }
}

extension GridModel {
    var dMsg: String {
        switch endPoint {
        case .characters:
            return "characters"
        case .comics:
            return "comics"
        case .events:
            return "events"
        }
    }
}
