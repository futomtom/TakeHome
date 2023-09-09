import SwiftUI

@MainActor
struct Detail: View {
    @Environment(\.navigate) private var navigate

    let character: Character
    @State private var mode: TabMode = .comics

    init(character: Character) {
        self.character = character
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Panel(content: Header(character: character))
                Tab(mode: $mode, character: character)
                if mode.isComics {
                    MarvelGrid(
                        endPoint: .comics(character.Id), titleShown: false, tappable: false
                    )
                } else {
                    MarvelGrid(
                        endPoint: .events(character.Id), titleShown: false, tappable: false
                    )
                }
            }
        }
        .toolbar {
            Image(systemName: "ellipsis")
        }
    }
}

struct CharacterDetail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(character: Character.mock.first!)
    }
}
