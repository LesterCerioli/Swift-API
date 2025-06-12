import Foundation
import NIO // For EventLoopFuture

// Assuming Product and CreateProductDTO are defined in Models and DTOs respectively
// If they are in the main module KituraResyAPI, direct usage is fine.
// Otherwise, ensure they are accessible, possibly via `import KituraResyAPI` if these files
// are treated as part of the same module, or by organizing them into a library target.
// For now, we assume they are available in the current module scope.

protocol ProductRepositoryProtocol {
    /// Creates a new product in the database.
    /// - Parameter productDTO: The DTO containing the data for the new product.
    /// - Returns: An `EventLoopFuture` holding the created `Product` or an error.
    func createProduct(dto: CreateProductDTO) -> EventLoopFuture<Product>

    /// Retrieves a product by its unique identifier.
    /// - Parameter id: The UUID of the product to retrieve.
    /// - Returns: An `EventLoopFuture` holding the `Product` if found, or `nil` if not found, or an error.
    func getProduct(id: UUID) -> EventLoopFuture<Product?>

    /// Retrieves all products.
    /// - Returns: An `EventLoopFuture` holding an array of `Product`s or an error.
    func listProducts() -> EventLoopFuture<[Product]>

    /// Updates an existing product.
    /// - Parameter id: The UUID of the product to update.
    /// - Parameter productDTO: The DTO containing the updated data.
    /// - Returns: An `EventLoopFuture` holding the updated `Product` or an error (e.g., if not found).
    func updateProduct(id: UUID, dto: CreateProductDTO) -> EventLoopFuture<Product> // Using CreateProductDTO for update for simplicity

    /// Deletes a product by its unique identifier.
    /// - Parameter id: The UUID of the product to delete.
    /// - Returns: An `EventLoopFuture` indicating success (Void) or an error.
    func deleteProduct(id: UUID) -> EventLoopFuture<Void>
}
