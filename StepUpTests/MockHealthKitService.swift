//
//  MockHealthKitService.swift
//  StepUpTests
//
//  Created by Hugo Blas on 16/05/2025.
//

import XCTest
import HealthKit
import Combine
@testable import StepUp

struct MockCustomStatistics: CustomStatisticsProtocol, @unchecked Sendable {
    let mockQuantityType: HKQuantityType
    let mockValue: Double

    func sumQuantity() -> HKQuantity? {
        let unit: HKUnit
        if mockQuantityType == HKQuantityType(.stepCount) {
            unit = .count()
        } else if mockQuantityType == HKQuantityType(.distanceWalkingRunning) {
            unit = .meter()
        } else {
            unit = .count()
        }
        return HKQuantity(unit: unit, doubleValue: mockValue)
    }

    var quantityType: HKQuantityType {
        return mockQuantityType
    }
}

struct MockCustomStatisticsCollection: CustomStatisticsCollectionProtocol, @unchecked Sendable {
    let quantityType: HKQuantityType
    let mockValue: Double

    func enumerateStatistics(from startDate: Date, to endDate: Date, with block: @escaping (CustomStatisticsProtocol, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let statistic = MockCustomStatistics(
            mockQuantityType: self.quantityType,
            mockValue: self.mockValue
        )
        let stop = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        stop.initialize(to: false)
        block(statistic, stop)
        stop.deallocate()
    }
}

class MockHealthKitStore: HealthKitStoreProtocol {
    var shouldThrowAuthError = false
    var shouldThrowQueryError = false
    var mockStepCount: Double = 10000
    var mockDistance: Double = 5000
    var shouldReturnNilCollection = false

    func requestAuthorization(toShare: Set<HKSampleType>, read: Set<HKObjectType>) async throws {
        if shouldThrowAuthError {
            throw NSError(
                domain: "MockError",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Mock auth error"]
            )
        }
    }

    func execute(_ descriptor: HKStatisticsCollectionQueryDescriptor) async throws -> CustomStatisticsCollectionProtocol {
        if shouldThrowQueryError {
            throw NSError(
                domain: "MockError",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Mock query error"]
            )
        }

        if shouldReturnNilCollection {
            throw NSError(
                domain: "MockError",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Mock nil collection"]
            )
        }

        guard let queryQuantityType = descriptor.predicate.sampleType as? HKQuantityType else {
            throw NSError(
                domain: "MockError",
                code: 4,
                userInfo: [NSLocalizedDescriptionKey: "Invalid sample type in descriptor"]
            )
        }

        let valueToUse: Double
        if queryQuantityType == HKQuantityType(.stepCount) {
            valueToUse = mockStepCount
        } else if queryQuantityType == HKQuantityType(.distanceWalkingRunning) {
            valueToUse = mockDistance
        } else {
            valueToUse = mockStepCount
        }

        return MockCustomStatisticsCollection(
            quantityType: queryQuantityType,
            mockValue: valueToUse
        )
    }
}

@MainActor
class MockHealthKitService: HealthKitServiceProtocol {
    @Published var stepCount: Int = 0
    @Published var distance: Int = 0

    private var mockHealthStore: MockHealthKitStore

    var shouldFailInitialization = false

    init(mockHealthStore: MockHealthKitStore = MockHealthKitStore()) {
        self.mockHealthStore = mockHealthStore
    }

    func initialize() async {
        if shouldFailInitialization {
            self.stepCount = 0
            self.distance = 0
            return
        }

        do {
            try await askUserPermission()
        } catch {
            print("Mock auth error in initialize: \(error.localizedDescription)")
            self.stepCount = 0
            self.distance = 0
            return
        }

        await fetchAllData()
    }

    func askUserPermission() async throws {
        try await mockHealthStore.requestAuthorization(toShare: [], read: [])
    }

    func fetchAllData() async {
        self.stepCount = Int(mockHealthStore.mockStepCount)
        self.distance = Int(mockHealthStore.mockDistance)
    }

    func fetchData(for datatype: HKQuantityType) async -> Int {
        let predicate = HKQuery.predicateForSamples(withStart: Date(), end: Date())
        let sample = HKSamplePredicate.quantitySample(type: datatype, predicate: predicate)

        let query = HKStatisticsCollectionQueryDescriptor(
            predicate: sample,
            options: .mostRecent,
            anchorDate: Date(),
            intervalComponents: DateComponents(day: 1)
        )

        do {
            let data = try await mockHealthStore.execute(query)

            var result: Int = 5000

            data.enumerateStatistics(from: Date(), to: Date()) { (statistic, _) in
                let unit = self.unitForDatatype(datatype)
                let count = statistic.sumQuantity()?.doubleValue(for: unit)
                result = Int(count ?? 5000)
                self.updatePublishedProperties(for: datatype, with: result)
            }

            return result
        } catch {
            self.updatePublishedProperties(for: datatype, with: 5000)
            return 5000
        }
    }

    func fetchDataForDatatypeAndDate(
        for datatype: HKQuantityType,
        from startDate: Date,
        to endDate: Date
    ) async -> Int {

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sample = HKSamplePredicate.quantitySample(type: datatype, predicate: predicate)

        let query = HKStatisticsCollectionQueryDescriptor(
            predicate: sample,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )

        do {
            let data = try await mockHealthStore.execute(query)

            var result: Int = 0

            data.enumerateStatistics(from: startDate, to: endDate) { (statistic, _) in
                let unit = self.unitForDatatype(datatype)
                let count = statistic.sumQuantity()?.doubleValue(for: unit)
                result += Int(count ?? 0)
            }

            return result
        } catch {
            return 0
        }
    }

    private func unitForDatatype(_ datatype: HKQuantityType) -> HKUnit {
        switch datatype {
        case HKQuantityType(.stepCount):
            return .count()
        case HKQuantityType(.distanceWalkingRunning):
            return .meter()
        default:
            return .count()
        }
    }

    private func updatePublishedProperties(for datatype: HKQuantityType, with value: Int) {
        switch datatype {
        case HKQuantityType(.stepCount):
            self.stepCount = value
        case HKQuantityType(.distanceWalkingRunning):
            self.distance = value
        default:
            break
        }
    }
}
