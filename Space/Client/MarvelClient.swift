import Foundation

typealias MarvelResponse = Response<PaginatedInfo<Character>>

protocol MarvelProtocol {
    func fetch(endPoint: Marvel.EndPoint, _ offset: Int, charId: String) async throws -> MarvelResponse
}

struct MarvelClient: MarvelProtocol {
    @discardableResult
    func fetch(endPoint: Marvel.EndPoint, _ offset: Int, charId: String) async throws -> MarvelResponse {
        let marvel = Marvel(endPoint: endPoint)
        guard let url = marvel.makeURL(offset, charId: charId) else {
            throw NetworkError.invalidURL
        }

        let result: MarvelResponse = try await MarvelClient.get(from: url)
        return result
    }
}

extension MarvelClient {
    static func get<T: Decodable>(from url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidServerResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let result: T = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print("🙂", error)
            throw error
        }
    }
}
