import Foundation

extension MarvelGrid {
    @MainActor
    final class Model: ObservableObject {
        @Published var characters: [Character]

        let endPoint: Marvel.EndPoint
        var offset = 0
        var hasMore: Bool = true
        var isLoading = false

        init(endPoint: Marvel.EndPoint, _ characters: [Character] = []) {
            self.endPoint = endPoint
            self.characters = characters
        }

        func fetch(_ offset: Int = 0) async throws {
            let marvelClient = MarvelClient()
            isLoading = true
            guard let response = try? await marvelClient.charactersFetch(endPoint: endPoint, offset) else {
                return
            }
            isLoading = false
            toModel(data: response.data)
        }

        func toModel(data: PaginatedInfo<Character>) {
            let newCharacters = data.results?.filter { $0.hasThumbnail } ?? []
            characters.append(contentsOf: newCharacters)

            offset = data.offset + data.count
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
            characters.isLast(character) && hasMore
        }
    }
}
