import SwiftUI

struct AppView: View {
    @State private var routes: [Route]

    init(routes: [Route] = []) {
        self.routes = routes
    }

    var body: some View {
        NavigationStack(path: $routes) {
            MarvelGrid(model: GridModel(.characters))
                .toolbar(content: {
                    Text(" ")
                })
                .navigationTitle("")
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
        AppView(routes: [])
    }
}

struct DeepLink_Previews: PreviewProvider {
    static var previews: some View {
        AppView(routes: [Route.detail(Character.mock.first!), Route.detail(Character.mock.first!)])
    }
}
