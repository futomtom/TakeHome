import SwiftUI

struct GridCell: View {
    @Environment(\.colorScheme) var colorScheme
    let character: Character

    var body: some View {
        ZStack {
            CacheAsyncImage(url: character.imageURL) { phase in
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

            bannerView()
        }
    }

    func bannerView() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .clear, .black.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                .frame(height: Constant.gridWidth)

            Text(character.safeName)
                .foregroundColor(.white)
                .font(.footnote)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom, .leading], 8)
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        GridCell(character: Character.mock.first!)
    }
}
