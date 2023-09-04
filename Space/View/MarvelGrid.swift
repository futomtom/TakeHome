import SwiftUI

enum GridMode {
    case main, detail
}

struct MarvelGrid: View {
    @ObservedObject var model: MarvelGrid.Model
    let titleShown: Bool
    let columns: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: Constant.gridSpacing),
        count: 3
    )
    init(model: MarvelGrid.Model, titleShown: Bool = true) {
        self.model = model
        self.titleShown = titleShown
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: Constant.gridSpacing) {
                ForEach(model.characters) { character in
                    GridCell(character: character, titleShown: titleShown)
                        .onAppear {
                            if model.characters.isLast(character) {
                                model.loadMore(model.offset)
                            }
                        }
                }
            }
        }
        .task {
            do {
                try await model.fetch(model.offset)
            } catch {
                print("🙂", error.localizedDescription)
            }
        }
    }
}

// struct CharactersGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        CharactersGrid(model: CharactersGrid.Model())
//    }
// }
