//
//  WatchHistoricalGlucoseTest.swift
//  LoopTests
//
//  Created by Darin Krauss on 10/13/20.
//  Copyright © 2020 LoopKit Authors. All rights reserved.
//

import XCTest
import HealthKit
import LoopKit

@testable import Loop

class WatchHistoricalGlucoseTests: XCTestCase {
    private lazy var device = HKDevice(name: "NAME", manufacturer: "MANUFACTURER", model: "MODEL", hardwareVersion: "HARDWAREVERSION", firmwareVersion: "FIRMWAREVERSION", softwareVersion: "SOFTWAREVERSION", localIdentifier: "LOCALIDENTIFIER", udiDeviceIdentifier: "UDIDEVICEIDENTIFIER")
    private lazy var samples: [StoredGlucoseSample] = {
        return [StoredGlucoseSample(uuid: UUID(),
                                    provenanceIdentifier: UUID().uuidString,
                                    syncIdentifier: UUID().uuidString,
                                    syncVersion: 4,
                                    startDate: Date(timeIntervalSinceReferenceDate: .hours(100)),
                                    quantity: HKQuantity(unit: .milligramsPerDeciliter, doubleValue: 123.45),
                                    trend: nil,
                                    isDisplayOnly: false,
                                    wasUserEntered: true,
                                    device: device),
                StoredGlucoseSample(uuid: UUID(),
                                    provenanceIdentifier: UUID().uuidString,
                                    syncIdentifier: UUID().uuidString,
                                    syncVersion: 2,
                                    startDate: Date(timeIntervalSinceReferenceDate: .hours(99)),
                                    quantity: HKQuantity(unit: .millimolesPerLiter, doubleValue: 7.2),
                                    trend: .up,
                                    isDisplayOnly: true,
                                    wasUserEntered: false,
                                    device: device),
                StoredGlucoseSample(uuid: nil,
                                    provenanceIdentifier: UUID().uuidString,
                                    syncIdentifier: nil,
                                    syncVersion: nil,
                                    startDate: Date(timeIntervalSinceReferenceDate: .hours(98)),
                                    quantity: HKQuantity(unit: .milligramsPerDeciliter, doubleValue: 187.65),
                                    trend: .downDownDown,
                                    isDisplayOnly: false,
                                    wasUserEntered: false,
                                    device: nil),
        ]
    }()

    func testDefaultInitializer() {
        let glucose = WatchHistoricalGlucose(samples: self.samples)
        XCTAssertEqual(glucose.samples, self.samples)
    }

    func testRawValueInitializerMissingSamples() {
        let rawValue: WatchHistoricalGlucose.RawValue = [:]
        XCTAssertNil(WatchHistoricalGlucose(rawValue: rawValue))
    }

    func testRawValueInitializerInvalidSamples() {
        let rawValue: WatchHistoricalGlucose.RawValue = [
            "sample": Data()
        ]
        XCTAssertNil(WatchHistoricalGlucose(rawValue: rawValue))
    }

    func testRawValue() {
        let rawValue = WatchHistoricalGlucose(samples: self.samples).rawValue
        XCTAssertEqual(rawValue.count, 1)
        XCTAssertNotNil(rawValue["samples"] as? Data)
        XCTAssertEqual(WatchHistoricalGlucose(rawValue: rawValue)?.samples, self.samples)
    }
}
