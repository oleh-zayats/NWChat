// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCPServer",
    products: [
        .library(name: "TCPServer", targets: ["TCPServer"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.7.3")
    ],
    targets: [
        .target(name: "TCPServer", dependencies: ["NIO", "NIOConcurrencyHelpers"])
    ]
)
