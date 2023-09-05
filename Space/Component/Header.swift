import SwiftUI

struct Header: View {
    let character: Character
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(character.safeName)
                    .font(.headline)
                Spacer()
                circularAvatar()
            }
            Text(character.description ?? "")
                .font(.body)
                .frame(height: 50)
        }
        .padding()
    }

    private func circularAvatar() -> some View {
        CachedAsyncImage(
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

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(character: Character.mock.first!)
    }
}
