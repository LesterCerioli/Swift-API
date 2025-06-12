import Foundation

// DTO for creating a new product
struct CreateProductDTO: Codable {
    let name: String
    let description: String?
    let price: Double
}

// DTO for API responses containing product details
struct ProductResponseDTO: Codable {
    let id: UUID
    let name: String
    let description: String?
    let price: Double
}
