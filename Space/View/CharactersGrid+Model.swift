import Foundation

extension MarvelGrid {
    @MainActor
    class Model: ObservableObject {
        let endPoint: Marvel.EndPoint

        var offset = 0
        var total = 0
        @Published var characters: [Character] = []
        var isLoading = false



        init(endPoint: Marvel.EndPoint, offset: Int = 0, total: Int = 0) {
            self.endPoint = endPoint
            self.offset = offset
            self.total = total
        }

        func fetch(_ offset: Int = 0) async throws {
            let marvelClient = MarvelClient()
            isLoading = true
            guard let response = try? await marvelClient.charactersFetch(endPoint: endPoint, offset) else {
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
