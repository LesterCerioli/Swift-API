import PostgresNIO
import NIO // Required for EventLoopGroup

// TODO: Move database configuration to environment variables
struct Database {
    static let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    static func makeConnection() -> EventLoopFuture<PostgresConnection> {
        let configuration = PostgresConnection.Configuration(
            host: "localhost", // Replace with your Docker container's IP or hostname if different
            port: 5432,        // Default Postgres port
            username: "testuser",    // Replace with your Postgres username
            password: "testpassword", // Replace with your Postgres password
            database: "testdb",     // Replace with your Postgres database name
            tls: .disable // Or .require, .prefer if SSL/TLS is configured
        )

        return PostgresConnection.connect(
            on: eventLoopGroup.next(),
            configuration: configuration,
            id: 1 // Unique ID for this connection source
        )
    }

    // Call this when the application is shutting down
    static func shutdown() {
        do {
            try eventLoopGroup.syncShutdownGracefully()
        } catch {
            print("Error shutting down EventLoopGroup: \(error)")
        }
    }
}
