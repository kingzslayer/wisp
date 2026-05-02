// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WispShared",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "WispShared", targets: ["WispShared"])
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "WispShared",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]
        ),
        .testTarget(
            name: "WispSharedTests",
            dependencies: ["WispShared"]
        )
    ]
)
