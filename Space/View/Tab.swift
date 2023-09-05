import SwiftUI

enum TabMode: CaseIterable {
    case comics
    case events

    var isComics: Bool {
        self == .comics
    }
}

struct Tab: View {
    @Binding var mode: TabMode
    let character: Character

    @Namespace private var animation

    var body: some View {
        HStack(spacing: 30) {
            ForEach(TabMode.allCases, id: \.self) { tab in
                VStack {
                    tabIcon(tab: tab, mode: mode)
                    Text(character.getTitle(for: tab))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                }
                .padding()
                .background {
                    if mode == tab {
                        Rectangle()
                            .fill(.blue)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    } else {
                        Rectangle()
                            .fill(.gray.opacity(0.1))
                    }
                }
                .foregroundColor(mode == tab ? .white : .secondary)

                .onTapGesture {
                    mode = tab
                }
            }
        }
    }

    func tabIcon(tab: TabMode, mode: TabMode) -> some View {
        var iconName = ""
        if tab == .comics {
            iconName = tab == mode ? "book.fill" : "book"
        } else {
            iconName = tab == mode ? "tv.fill" : "tv"
        }
        return Image(systemName: iconName)
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab(mode: .constant(.comics), character: Character.mock.first!)
    }
}
