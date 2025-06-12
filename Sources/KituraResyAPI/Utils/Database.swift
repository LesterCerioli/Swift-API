import PostgresNIO
import NIO // Required for EventLoopGroup


struct Database {
    static let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    static func makeConnection() -> EventLoopFuture<PostgresConnection> {
        let configuration = PostgresConnection.Configuration(
            host: "localhost", 
            port: 5432,        
            username: "testuser",    
            password: "testpassword", 
            database: "testdb",     
            tls: .disable 
        )

        return PostgresConnection.connect(
            on: eventLoopGroup.next(),
            configuration: configuration,
            id: 1 // Unique ID for this connection source
        )
    }

    
    static func shutdown() {
        do {
            try eventLoopGroup.syncShutdownGracefully()
        } catch {
            print("Error shutting down EventLoopGroup: \(error)")
        }
    }
}
