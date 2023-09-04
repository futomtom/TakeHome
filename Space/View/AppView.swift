import SwiftUI

struct AppView: View {
    var body: some View {
        NavigationStack {
            MarvelGrid(
                model: MarvelGrid.Model(endPoint: .characters))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
