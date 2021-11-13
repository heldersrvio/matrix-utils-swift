// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "matrix-utils-swift",
    products: [
        .library(
            name: "matrix-utils-swift",
            targets: ["matrix-utils-swift"]),
    ],
    targets: [
        .target(
            name: "matrix-utils-swift",
            dependencies: []),
        .testTarget(
            name: "matrix-utils-swiftTests",
            dependencies: ["matrix-utils-swift"]),
    ],
    swiftLanguageVersions: [.v5]
)
