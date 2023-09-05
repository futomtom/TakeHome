import SwiftUI

struct NoDataView: View {
    var body: some View {
        VStack {
            Image(systemName: "folder")
            Text("No Data")
        }
        .padding()
    }
}

struct NoDataView_Preview: PreviewProvider {
    static var previews: some View {
        NoDataView()
    }
}
