import SwiftUI

struct GridCell: View {
    @Environment(\.colorScheme) var colorScheme
    private let character: Character
    private let titleShown: Bool

    init(character: Character, titleShown: Bool = true) {
        self.character = character
        self.titleShown = titleShown
    }

    var body: some View {
        ZStack {
            CachedAsyncImage(url: character.imageURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Constant.gridWidth, height: Constant.gridWidth)
                        .clipped()
                default:
                    ZStack {
                        Rectangle()
                            .fill(colorScheme == .dark ? .black : .white)
                        ProgressView()
                    }
                }
            }
            if titleShown {
                bannerView()
            }
        }
    }

    private func bannerView() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .clear, .black.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))

            Text(character.safeName)
                .foregroundColor(.white)
                .font(.footnote)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom, .leading], 8)
        }
        .frame(width: Constant.gridWidth, height: Constant.gridWidth)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        GridCell(character: Character.mock.first!)
    }
}
