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

                MarvelGrid(model: mode.isComics ? comics : events, titleShown: false, tappable: false)
                    .frame(height: UIScreen.main.bounds.size.height)
            }
        }

        .task {
            comics.charId = character.Id
            events.charId = character.Id
            await withTaskGroup(of: Void.self) { group in
                group.addTask { try? await comics.fetch() }
                group.addTask { try? await events.fetch() }

                // Wait for both tasks a and b to complete
                while let _ = await group.next() {}
                comicCount = comics.total
                eventCount = events.total
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
