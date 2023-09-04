import Foundation

extension CharactersGrid {
    @MainActor
    class Model: ObservableObject {
        var offset = 0
        var total = 0
        @Published var characters: [Character] = []
        var isLoading = false

        lazy var marvelClient = MarvelClient()

        func fetch(_ offset: Int = 0) async throws {
            isLoading = true
            guard let response = try? await marvelClient.charactersFetch(offset) else {
                return
            }
            isLoading = false

            let newCharacters = response.data.results?.filter { $0.hasThumbnail } ?? []
            characters.append(contentsOf: newCharacters)
            
            self.offset = response.data.offset +  response.data.count
            total = max(total, response.data.total)
        }

        func loadMore(_ offset: Int) {
            Task {
                try? await fetch(offset)
            }
        }
    }
}
