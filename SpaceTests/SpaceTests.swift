import XCTest
@testable import Space

final class MockMarvelClient: MarvelProtocol {
    func fetch(endPoint: Marvel.EndPoint, _ offset: Int) async throws -> MarvelResponse {
        let data = PaginatedInfo(offset: offset, limit: 20, total: 100, count: 0, results: Character.mock)
       return  MarvelResponse(code: 0, status: "200", data: data)
    }
}

final class SpaceTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testNetworkMock() async throws {
        let response = try? await MockMarvelClient().fetch(endPoint: .characters, 0)
        XCTAssertEqual(response!.data.results?.count, 11)
    }
}
