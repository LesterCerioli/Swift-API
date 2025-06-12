import Foundation
import NIO 



protocol ProductRepositoryProtocol {
    
    func createProduct(dto: CreateProductDTO) -> EventLoopFuture<Product>

    
    func getProduct(id: UUID) -> EventLoopFuture<Product?>

    
    func listProducts() -> EventLoopFuture<[Product]>

    
    func updateProduct(id: UUID, dto: CreateProductDTO) -> EventLoopFuture<Product> // Using CreateProductDTO for update for simplicity

    
    func deleteProduct(id: UUID) -> EventLoopFuture<Void>
}
