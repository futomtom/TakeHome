import SwiftUI

struct AppView: View {
    @State private var routes: [Route] = []

    var body: some View {
        NavigationStack(path: $routes) {
            MarvelGrid(
                model: MarvelGrid.Model(endPoint: .characters)
            )
            .environment(\.navigate) { route in
                routes.append(route)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .detail(character):
                    Detail(character: character)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
