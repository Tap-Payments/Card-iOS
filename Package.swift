// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tap-Card-SDK",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Tap-Card-SDK",
            targets: ["Tap-Card-SDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/huri000/SwiftEntryKit.git", from: "1.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/TakeScoop/SwiftyRSA.git", from: "1.0.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Tap-Payments/SharedDataModels-iOS.git", from: "0.0.1"),
        .package(url: "https://github.com/Tap-Payments/TapCardScannerWebWrapper-iOS.git", exact: "0.0.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Tap-Card-SDK",
            dependencies: ["SwiftEntryKit",
                          "SnapKit",
                           .product(name: "Lottie", package: "lottie-spm"),
                          "SwiftyRSA",
                          "SharedDataModels-iOS",
                          "TapCardScannerWebWrapper-iOS"],
            resources: [.copy("Resources/Dark_Mode_Button_Loader.json"),
                        .copy("Resources/Light_Mode_Button_Loader.json"),
                        .process("Resources/Media.xcassets")],
            swiftSettings: [
                    .define("SPM")
                  ]),
        .testTarget(
            name: "Tap-Card-SDKTests",
            dependencies: ["Tap-Card-SDK",
                           "SwiftEntryKit",
                            "SnapKit",
                            "SwiftyRSA",
                            "SharedDataModels-iOS",
                            "TapCardScannerWebWrapper-iOS"]),
    ],
    swiftLanguageVersions: [.v5]
)
