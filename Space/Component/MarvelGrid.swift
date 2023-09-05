import SwiftUI

enum GridMode {
    case main, detail
}

struct MarvelGrid: View {
    @Environment(\.navigate) private var navigate

    @StateObject var model = GridModel()
    @State var endPoint: Marvel.EndPoint
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
            model.updateEndPoint(endPoint)
            do {
                try await model.fetch()
            } catch {
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
