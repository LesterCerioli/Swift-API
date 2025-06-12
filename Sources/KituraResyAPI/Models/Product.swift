import Foundation

struct Product: Codable { // Added Codable for later use in API responses/requests
    let id: UUID
    let name: String
    let description: String?
    let price: Double
}
