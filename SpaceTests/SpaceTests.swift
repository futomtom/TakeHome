import XCTest
@testable import Space

final class MockMarvelClient: MarvelProtocol {
    func fetch(endPoint: Marvel.EndPoint, _ offset: Int, charId: String) async throws -> MarvelResponse {
        let data = PaginatedInfo(offset: offset, limit: 20, total: 100, count: 11, results: Character.mock)
        return MarvelResponse(code: 0, status: "200", data: data)
    }
}

final class SpaceTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testNetworkMock() async throws {
        let response = try? await MockMarvelClient().fetch(endPoint: .characters, 0, charId: "")
        XCTAssertEqual(response!.data.results?.count, 11)
    }

    @MainActor
    func testModelFetch() {
        let model = GridModel(.characters)
        Task {
            try await model.fetch(0, client: MockMarvelClient())
            XCTAssertEqual(model.characters.count, 11)
        }
    }
}
