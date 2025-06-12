import PackageDescription

let package = Package(
    name: "KituraResyAPI",
    dependencies: [
        .package(url: "https://github.com/Kitura/Kitura.git", from: "3.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "KituraResyAPI",
            dependencies: ["Kitura"]
        ),
    ]
)