import Foundation
import PostgresNIO
import NIO // For EventLoopFuture

// Assumes Product, CreateProductDTO, ProductRepositoryProtocol, and Database are accessible.

// MARK: - Database Schema Assumption
// This repository assumes a PostgreSQL table named 'products' with the following schema:
// CREATE TABLE products (
//     id UUID PRIMARY KEY,
//     name TEXT NOT NULL,
//     description TEXT,
//     price NUMERIC(10, 2) NOT NULL -- Example precision, adjust as needed
// );

class PostgresProductRepository: ProductRepositoryProtocol {

    private func getConnection() -> EventLoopFuture<PostgresConnection> {
        return Database.makeConnection()
    }

    func createProduct(dto: CreateProductDTO) -> EventLoopFuture<Product> {
        let newId = UUID()
        let sql = """
        INSERT INTO products (id, name, description, price)
        VALUES ($1, $2, $3, $4)
        RETURNING id, name, description, price;
        """

        // Convert Double to Decimal for Postgres NUMERIC type if direct binding is problematic
        // PostgresNIO typically handles Double to NUMERIC conversion, but explicit Decimal might be safer for precision.
        // For now, we'll use Double directly.
        let parameters: [PostgresData] = [
            PostgresData(uuid: newId),
            PostgresData(string: dto.name),
            dto.description != nil ? PostgresData(string: dto.description!) : PostgresData(null: ()),
            PostgresData(double: dto.price)
        ]

        return getConnection().flatMap { connection in
            connection.query(sql, parameters).flatMapThrowing { result in
                guard let row = result.rows.first,
                      let id = row.column("id")?.uuid,
                      let name = row.column("name")?.string,
                      let price = row.column("price")?.double else {
                    throw RepositoryError.creationFailed("Could not parse returned product data")
                }
                let description = row.column("description")?.string
                return Product(id: id, name: name, description: description, price: price)
            }.always { _ in
                _ = connection.close()
            }
        }
    }

    func getProduct(id: UUID) -> EventLoopFuture<Product?> {
        let sql = "SELECT id, name, description, price FROM products WHERE id = $1;"
        let parameters: [PostgresData] = [PostgresData(uuid: id)]

        return getConnection().flatMap { connection in
            connection.query(sql, parameters).flatMapThrowing { result in
                guard let row = result.rows.first else {
                    return nil // Not found
                }
                guard let name = row.column("name")?.string,
                      let price = row.column("price")?.double else {
                    // This case implies data integrity issues or unexpected nulls if row was found
                    throw RepositoryError.parseError("Failed to parse product data from database")
                }
                let description = row.column("description")?.string
                // id is already known and confirmed by the WHERE clause, but good to retrieve for consistency
                let retrievedId = row.column("id")?.uuid ?? id
                return Product(id: retrievedId, name: name, description: description, price: price)
            }.always { _ in
                _ = connection.close()
            }
        }
    }

    // MARK: - TODO: Implement other protocol methods
    func listProducts() -> EventLoopFuture<[Product]> {
        // TODO: Implement
        print("listProducts() not yet implemented")
        return Database.eventLoopGroup.next().makeFailedFuture(RepositoryError.notImplemented("listProducts"))
    }

    func updateProduct(id: UUID, dto: CreateProductDTO) -> EventLoopFuture<Product> {
        // TODO: Implement
        print("updateProduct(id:dto:) not yet implemented")
        return Database.eventLoopGroup.next().makeFailedFuture(RepositoryError.notImplemented("updateProduct"))
    }

    func deleteProduct(id: UUID) -> EventLoopFuture<Void> {
        // TODO: Implement
        print("deleteProduct(id:) not yet implemented")
        return Database.eventLoopGroup.next().makeFailedFuture(RepositoryError.notImplemented("deleteProduct"))
    }
}

// Define some basic repository errors
enum RepositoryError: Error, LocalizedError {
    case notImplemented(String)
    case creationFailed(String)
    case updateFailed(String)
    case generalError(String)
    case parseError(String)

    var errorDescription: String? {
        switch self {
        case .notImplemented(let method): return "Method not implemented: \(method)"
        case .creationFailed(let reason): return "Failed to create entity: \(reason)"
        case .updateFailed(let reason): return "Failed to update entity: \(reason)"
        case .generalError(let message): return message
        case .parseError(let reason): return "Failed to parse data: \(reason)"
        }
    }
}
