
import PackageDescription

let package = Package(
    name: "KituraResyAPI",
    dependencies: [
        .package(url: "https://github.com/Kitura/Kitura.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.14.0")
    ],
    targets: [
        .executableTarget(
            name: "KituraResyAPI",
            dependencies: [
                "Kitura",
                "PostgresNIO"
            ]
        ),
    ]
)
