import SwiftUI

struct Panel<Content: View>: View {
    let content: Content

    init(content: Content) {
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)

            content
        }
        .padding()
        .frame(height: 200)
    }
}

struct Panel_Previews: PreviewProvider {
    static var previews: some View {
        Panel(content: Header(character: Character.mock.first!))
    }
}
