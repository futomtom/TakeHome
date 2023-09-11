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

    func loadMoreIfCan(_ character: Character) {
        guard canLoadMore(character) else {
            return
        }

        Task {
            try? await fetch(offset)
        }
    }

    private func canLoadMore(_ character: Character) -> Bool {
        characters.isLast(character) && hasMore && characters.count != total
    }
}

/*
 extension GridModel {
     var dMsg: String {
         switch endPoint {
         case .dummy:
             return "dummy"
         case .characters:
             return "characters"
         case .comics(_):
             return "comics"
         case .events(_):
             return "events"
         }
     }
 }
 */
