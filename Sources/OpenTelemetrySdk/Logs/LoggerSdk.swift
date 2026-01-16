//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import PraiaOpenTelemetryApi

public class LoggerSdk: PraiaOpenTelemetryApi.Logger {
  private let sharedState: LoggerSharedState
  private let instrumentationScope: InstrumentationScopeInfo
  private let eventDomain: String?
  private let withTraceContext: Bool

  init(sharedState: LoggerSharedState, instrumentationScope: InstrumentationScopeInfo, eventDomain: String?, withTraceContext: Bool = true) {
    self.sharedState = sharedState
    self.instrumentationScope = instrumentationScope
    self.eventDomain = eventDomain
    self.withTraceContext = withTraceContext
  }

  @available(*, deprecated, message: "Use logRecordBuilder() and setEventName(_:) instead")
  public func eventBuilder(name: String) -> PraiaOpenTelemetryApi.EventBuilder {
    var builder = LogRecordBuilderSdk(sharedState: sharedState, instrumentationScope: instrumentationScope, includeSpanContext: true)
      .setEventName(name)
    
    // Backward compatibility: Add deprecated attributes
    var attributes: [String: AttributeValue] = ["event.name": AttributeValue.string(name)]
    if let eventDomain {
      attributes["event.domain"] = AttributeValue.string(eventDomain)
    }
    builder = builder.setAttributes(attributes)
    
    return builder
  }

  public func logRecordBuilder() -> PraiaOpenTelemetryApi.LogRecordBuilder {
    return LogRecordBuilderSdk(sharedState: sharedState, instrumentationScope: instrumentationScope, includeSpanContext: true)
  }

  func withEventDomain(domain: String) -> LoggerSdk {
    if eventDomain == domain {
      return self
    } else {
      return LoggerSdk(sharedState: sharedState, instrumentationScope: instrumentationScope, eventDomain: domain, withTraceContext: withTraceContext)
    }
  }

  func withoutTraceContext() -> LoggerSdk {
    return LoggerSdk(sharedState: sharedState, instrumentationScope: instrumentationScope, eventDomain: eventDomain, withTraceContext: false)
  }
}
