// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GithubKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "GithubKit",
                 targets: ["GithubKit"]),
    ],
    targets: [
        .target(name: "GithubKit",
                path: "GithubKit")
    ],
    swiftLanguageVersions: [.v5]
)
