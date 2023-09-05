import SwiftUI

enum GridMode {
    case main, detail
}

struct MarvelGrid: View {
    @Environment(\.navigate) private var navigate

    @StateObject private var model = GridModel()
    @State private var endPoint: Marvel.EndPoint
    @State private var hasFetched = false
    let titleShown: Bool
    let tappable: Bool
    let columns: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: Constant.gridSpacing),
        count: 3
    )

    init(endPoint: Marvel.EndPoint, titleShown: Bool = true, tappable: Bool = true) {
        self.endPoint = endPoint
        self.titleShown = titleShown
        self.tappable = tappable
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: Constant.gridSpacing) {
                ForEach(model.characters) { character in
                    GridCell(character: character, titleShown: titleShown)
                        .onAppear {
                            model.loadMoreIfCan(character)
                        }
                        .disabled(!tappable)
                        .onTapGesture {
                            navigate(.detail(character))
                        }
                }
            }
            if hasFetched, model.characters.isEmpty {
                NoDataView()
            }
        }
        .task {
            guard !hasFetched else {
                return
            }
            model.updateEndPoint(endPoint)
            do {
                try await model.fetch()
                hasFetched = true
            } catch {
                hasFetched = true
                print(error.localizedDescription)
            }
        }
    }
}

struct CharactersGrid_Previews: PreviewProvider {
    static var previews: some View {
        MarvelGrid(endPoint: .characters)
    }
}
