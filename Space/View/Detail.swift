import SwiftUI

@MainActor
struct Detail: View {
    @Environment(\.navigate) private var navigate

    let character: Character
    @State var mode: TabMode = .comics

    init(character: Character) {
        self.character = character
    }

    var body: some View {
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
}

struct CharacterDetail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(character: Character.mock.first!)
    }
}
