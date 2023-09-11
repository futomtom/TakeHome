import Foundation

extension Array where Element == Character {
    func isLast(_ character: Character) -> Bool {
        last == character
    }
}
