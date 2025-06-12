import Foundation
import PostgresNIO
import NIO 



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
                    return nil 
                }
                guard let name = row.column("name")?.string,
                      let price = row.column("price")?.double else {
                    
                    throw RepositoryError.parseError("Failed to parse product data from database")
                }
                let description = row.column("description")?.string
                
                let retrievedId = row.column("id")?.uuid ?? id
                return Product(id: retrievedId, name: name, description: description, price: price)
            }.always { _ in
                _ = connection.close()
            }
        }
    }

    
    func listProducts() -> EventLoopFuture<[Product]> {
        
        print("listProducts() not yet implemented")
        return Database.eventLoopGroup.next().makeFailedFuture(RepositoryError.notImplemented("listProducts"))
    }

    func updateProduct(id: UUID, dto: CreateProductDTO) -> EventLoopFuture<Product> {
        
        print("updateProduct(id:dto:) not yet implemented")
        return Database.eventLoopGroup.next().makeFailedFuture(RepositoryError.notImplemented("updateProduct"))
    }

    func deleteProduct(id: UUID) -> EventLoopFuture<Void> {
        
        print("deleteProduct(id:) not yet implemented")
        return Database.eventLoopGroup.next().makeFailedFuture(RepositoryError.notImplemented("deleteProduct"))
    }
}

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
