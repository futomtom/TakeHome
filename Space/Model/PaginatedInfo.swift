import Foundation

struct PaginatedInfo<T: Decodable & Equatable>: Decodable & Equatable {
    let offset, limit, total, count: Int
    let results: [T]?
}
