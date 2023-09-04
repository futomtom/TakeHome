import Foundation

struct Response<T: Decodable & Equatable>: Decodable & Equatable {
    let code: Int
    let status: String
    let data: T
}
