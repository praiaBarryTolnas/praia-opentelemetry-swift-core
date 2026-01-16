//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import PraiaOpenTelemetryApi

public class FilteredExemplarReservoir: ExemplarReservoir {
  let exemplarFilter: ExemplarFilter
  let reservoir: ExemplarReservoir

  init(filter: ExemplarFilter, reservoir: ExemplarReservoir) {
    exemplarFilter = filter
    self.reservoir = reservoir
  }

  override public func offerDoubleMeasurement(value: Double, attributes: [String: PraiaOpenTelemetryApi.AttributeValue]) {
    if exemplarFilter.shouldSampleMeasurement(value: value, attributes: attributes) {
      reservoir.offerDoubleMeasurement(value: value, attributes: attributes)
    }
  }

  override public func offerLongMeasurement(value: Int, attributes: [String: PraiaOpenTelemetryApi.AttributeValue]) {
    if exemplarFilter.shouldSampleMeasurement(value: value, attributes: attributes) {
      reservoir.offerLongMeasurement(value: value, attributes: attributes)
    }
  }

  override public func collectAndReset(attribute: [String: PraiaOpenTelemetryApi.AttributeValue]) -> [ExemplarData] {
    return reservoir.collectAndReset(attribute: attribute)
  }
}
