import Foundation

public struct PaginatedBlueprint<T: Decodable>: Decodable {
    public let info: PaginationInfoBlueprint
    public let results: [T]
}

public struct PaginationInfoBlueprint: Decodable {
    public let next: URL?
}
