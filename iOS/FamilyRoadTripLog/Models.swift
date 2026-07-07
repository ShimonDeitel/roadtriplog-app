import Foundation

struct Stop: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var placeName: String
    var note: String
    var date: Date = Date()
}
