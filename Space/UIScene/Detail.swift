import SwiftUI

@MainActor
struct Detail: View {
    @Environment(\.navigate) private var navigate
    @StateObject var comics = GridModel(.comics)
    @StateObject var events = GridModel(.events)
    @State var comicCount: Int?
    @State var eventCount: Int?
    
    let character: Character
    @State private var mode: TabMode = .comics

    init(character: Character) {
        self.character = character
    }

    var body: some View {

        ScrollView(.vertical) {
            VStack {
                Panel(content: Header(character: character))
                Tab(mode: $mode, comicsCount: comicCount, eventsCount: eventCount)
                if mode.isComics {
                    MarvelGrid(model: comics, titleShown: false, tappable: false)
                } else {
                    MarvelGrid(model: events, titleShown: false, tappable: false)
                }
            }
        }
        .task {
            comics.charId = character.Id
            events.charId = character.Id
            async let comic = comics.fetch()
            async let event = events.fetch()
            do {
                try await (comic, event)
                comicCount = comics.total
                eventCount = events.total
            } catch {
                print("load fail")
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
