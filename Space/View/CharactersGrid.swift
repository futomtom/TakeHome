import SwiftUI

struct CharactersGrid: View {
    @StateObject private var model = Model()
    var columns: [GridItem] =
        Array(repeating: .init(.flexible(), spacing: Constant.gridSpacing), count: 3)

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: Constant.gridSpacing) {
                ForEach(model.characters) { character in
                    GridCell(character: character)
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

//struct CharactersGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        CharactersGrid(model: CharactersGrid.Model())
//    }
//}
