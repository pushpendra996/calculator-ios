//
//  Package.json
//  calculator-ios
//
//  Created by Pushpendra on 25/05/25.
//

// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "calculator-ios",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "calculator-ios",
            targets: ["calculator-ios"]),
    ],
    dependencies: [
        // Add dependencies here
    ],
    targets: [
        .target(
            name: "calculator-ios",
            dependencies: []),
        .testTarget(
            name: "calculator-iosTests",
            dependencies: ["calculator-ios"]),
    ]
)
