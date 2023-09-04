import Foundation

typealias CharactersResponse = Response<PaginatedInfo<Character>>

protocol MarvelProtocol {
    func charactersFetch(_ offset: Int) async throws -> CharactersResponse
}

struct MarvelClient: MarvelProtocol {

    @discardableResult
    func charactersFetch(_ offset: Int) async throws -> CharactersResponse {
        let marvel = Marvel(endPoint: .characters(characterId: .init()))
        guard let url = marvel.makeURL(offset) else {
            throw NetworkError.invalidURL
        }

        let result: CharactersResponse = try await MarvelClient.get(from: url)
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
            do {
                let result: T = try decoder.decode(T.self, from: data)
                return result
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
