import SwiftUI

enum GridMode {
    case main, detail
}

struct MarvelGrid: View {
    @Environment(\.navigate) private var navigate

    @ObservedObject var model: MarvelGrid.Model
    let titleShown: Bool
    let tappable: Bool
    let columns: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: Constant.gridSpacing),
        count: 3
    )

    init(model: MarvelGrid.Model, titleShown: Bool = true, tappable: Bool = true) {
        self.model = model
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
                        .onTapGesture {
                            guard tappable else {
                                return
                            }
                            navigate(.detail(character))
                        }
                }
            }
        }
        .task {
            do {
                try await model.fetch(model.offset)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct CharactersGrid_Previews: PreviewProvider {
    static var previews: some View {
        MarvelGrid(model: MarvelGrid.Model(endPoint: .characters, Character.mock))
    }
}
