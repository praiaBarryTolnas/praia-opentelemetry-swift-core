//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import PraiaOpenTelemetryApi

public final class EmptyMetricStorage: SynchronousMetricStorageProtocol, @unchecked Sendable {
  public func recordLong(value: Int, attributes: [String: PraiaOpenTelemetryApi.AttributeValue]) {}

  public func recordDouble(value: Double, attributes: [String: PraiaOpenTelemetryApi.AttributeValue]) {}

  public static let instance = EmptyMetricStorage()

  public var metricDescriptor: MetricDescriptor = .init(name: "", description: "", unit: "")

  public func collect(resource: Resource, scope: InstrumentationScopeInfo, startEpochNanos: UInt64, epochNanos: UInt64) -> MetricData {
    MetricData.empty
  }

  public func isEmpty() -> Bool {
    true
  }
}
