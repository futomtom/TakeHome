import NukeUI
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
            LazyImage(url: character.imageURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .transition(.opacity)
                        .clipped()
                } else {
                    ZStack {
                        Rectangle()
                            .fill(colorScheme == .dark ? .black : .white)
                        ProgressView()
                    }
                }
            }
            .frame(width: Constant.gridWidth, height: Constant.gridWidth)

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
