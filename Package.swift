// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
  name: "praia-opentelemetry-swift-core",
  platforms: [
    .macOS(.v10_13),
    .iOS(.v12),
    .tvOS(.v12),
    .watchOS(.v4),
    .visionOS(.v1),
  ],
  products: [
    .library(name: "PraiaOpenTelemetryApi", targets: ["PraiaOpenTelemetryApi"]),
    .library(name: "OpenTelemetryConcurrency", targets: ["OpenTelemetryConcurrency"]),
    .library(name: "OpenTelemetrySdk", targets: ["OpenTelemetrySdk"]),
    .library(name: "StdoutExporter", targets: ["StdoutExporter"]),
    .executable(name: "ConcurrencyContext", targets: ["ConcurrencyContext"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-atomics.git", from: "1.3.0"),
  ],
  targets: [
    .target(
      name: "PraiaOpenTelemetryApi",
      dependencies: [],
      path: "Sources/OpenTelemetryApi"
    ),
    .target(
      name: "OpenTelemetrySdk",
      dependencies: [
        "PraiaOpenTelemetryApi",
        .product(name: "Atomics", package: "swift-atomics", condition: .when(platforms: [.linux])),
      ]
    ),
    .target(
      name: "OpenTelemetryConcurrency",
      dependencies: ["PraiaOpenTelemetryApi"]
    ),
    .target(
      name: "StdoutExporter",
      dependencies: ["OpenTelemetrySdk"],
      path: "Sources/Exporters/Stdout"
    ),
    .target(
      name: "OpenTelemetryTestUtils",
      dependencies: ["PraiaOpenTelemetryApi", "OpenTelemetrySdk"]
    ),
    .testTarget(
      name: "OpenTelemetryApiTests",
      dependencies: ["PraiaOpenTelemetryApi", "OpenTelemetryTestUtils"],
      path: "Tests/OpenTelemetryApiTests",
      swiftSettings: [.unsafeFlags(["-Xfrontend", "-disable-availability-checking", "-strict-concurrency=minimal"])]
    ),
    .testTarget(
      name: "OpenTelemetrySdkTests",
      dependencies: [
        "OpenTelemetrySdk",
        "OpenTelemetryConcurrency",
        "OpenTelemetryTestUtils",
      ],
      path: "Tests/OpenTelemetrySdkTests",
      swiftSettings: [.unsafeFlags(["-Xfrontend", "-disable-availability-checking"])]
    ),
    .executableTarget(
      name: "ConcurrencyContext",
      dependencies: ["OpenTelemetrySdk", "OpenTelemetryConcurrency", "StdoutExporter"],
      path: "Examples/ConcurrencyContext"
    ),
  ]
)

if ProcessInfo.processInfo.environment["OTEL_ENABLE_SWIFTLINT"] != nil {
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.1")
  ])

  for target in package.targets {
    target.plugins = [
      .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
    ]
  }
}
