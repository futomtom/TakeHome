import Foundation

extension Array where Element == Character {
    func isLast(_ character: Character) -> Bool {
        endIndex - 1 == lastIndex(of: character)
    }
}
