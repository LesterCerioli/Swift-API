import Foundation


struct CreateProductDTO: Codable {
    let name: String
    let description: String?
    let price: Double
}


struct ProductResponseDTO: Codable {
    let id: UUID
    let name: String
    let description: String?
    let price: Double
}
