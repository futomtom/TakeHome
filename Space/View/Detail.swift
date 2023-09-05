import SwiftUI

@MainActor
struct Detail: View {
    @Environment(\.navigate) private var navigate

    let character: Character
    @State var mode: TabMode = .comics
    private var comics: MarvelGrid.Model
    private var events: MarvelGrid.Model

    init(character: Character) {
        self.character = character
        let charId = "\(character.id)"
        comics = MarvelGrid.Model(endPoint: .comics(characterId: charId))
        events = MarvelGrid.Model(endPoint: .events(characterId: charId))
    }

    var body: some View {
        VStack {
            headerPanel(character)
            Tab(mode: $mode, character: character)
            MarvelGrid(
                model: mode.isComics ? comics : events,
                titleShown: false,
                tappable: false
            )
        }
        .task {
            try? await comics.fetch()
            try? await events.fetch()
        }
    }

    func headerPanel(_ character: Character) -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)

            header(character)
        }
        .padding()
        .frame(height: 200)
    }

    func header(_ character: Character) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(character.safeName)
                    .font(.headline)
                Spacer()
                circularAvatar(character)
            }
            Text(character.description ?? "")
                .font(.body)
                .frame(height: 50)
        }
        .padding()
    }

    func circularAvatar(_ character: Character) -> some View {
        CacheAsyncImage(
            url: character.imageURL
        ) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.yellow, lineWidth: 2))
                    .clipped()

            default:
                ProgressView()
            }
        }
    }
}

struct CharacterDetail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(character: Character.mock.first!)
    }
}
