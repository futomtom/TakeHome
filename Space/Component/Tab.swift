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
        HStack(spacing: 10) {
            ForEach(TabMode.allCases, id: \.self) { tab in
                VStack {
                    tabIcon(tab: tab, mode: mode)
                    Text(character.getTitle(for: tab))
                        .font(.system(size: 12, weight: .bold))
                        .padding(.top, 5)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background {
                    if mode == tab {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.gray.opacity(0.3))
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                .foregroundColor(mode == tab ? .primary : .secondary)
                .onTapGesture {
                    mode = tab
                }
            }
        }
    }

    private func tabIcon(tab: TabMode, mode: TabMode) -> some View {
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
