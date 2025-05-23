//
//  HealthKitServiceTests.swift
//  StepUpTests
//
//  Created by Hugo Blas on 16/05/2025.
//

import XCTest
import HealthKit
import Combine
@testable import StepUp

@MainActor
final class HealthKitServiceTests: XCTestCase {
    var mockHealthStore: MockHealthKitStore!
    var healthKitService: MockHealthKitService!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() async throws {
        try await super.setUp()
        mockHealthStore = MockHealthKitStore()
        healthKitService = MockHealthKitService(mockHealthStore: mockHealthStore)
    }

    override func tearDown() async throws {
        cancellables.removeAll()
        mockHealthStore = nil
        healthKitService = nil
        try await super.tearDown()
    }

    func testInitialization_success() async {
        // Given
        mockHealthStore.mockStepCount = 12500
        mockHealthStore.mockDistance = 6000

        // When
        await healthKitService.initialize()

        // Then
        let actualStepCount = healthKitService.stepCount
        let actualDistance = healthKitService.distance
        
        XCTAssertEqual(actualStepCount, 12500)
        XCTAssertEqual(actualDistance, 6000)
    }

    func testInitialization_authError_setsZeroValues() async {
        // Given
        mockHealthStore.shouldThrowAuthError = true

        // When
        await healthKitService.initialize()

        // Then
        let actualStepCount = healthKitService.stepCount
        let actualDistance = healthKitService.distance
        
        XCTAssertEqual(actualStepCount, 0)
        XCTAssertEqual(actualDistance, 0)
    }

    func testInitialization_failureFlag_setsZeroValues() async {
        // Given
        healthKitService.shouldFailInitialization = true

        // When
        await healthKitService.initialize()

        // Then
        let actualStepCount = healthKitService.stepCount
        let actualDistance = healthKitService.distance
        
        XCTAssertEqual(actualStepCount, 0)
        XCTAssertEqual(actualDistance, 0)
    }

    func testInitialization_nilCollection_usesDefaultValues() async {
        // Given
        mockHealthStore.shouldReturnNilCollection = true
        mockHealthStore.mockStepCount = 8000
        mockHealthStore.mockDistance = 4500

        // When
        await healthKitService.initialize()

        // Then
        let actualStepCount = healthKitService.stepCount
        let actualDistance = healthKitService.distance
        
        XCTAssertEqual(actualStepCount, 8000)
        XCTAssertEqual(actualDistance, 4500)
    }

    func testAskUserPermission_success() async throws {
        try await healthKitService.askUserPermission()
    }

    func testAskUserPermission_authError_throwsError() async {
        // Given
        mockHealthStore.shouldThrowAuthError = true
        var thrownError: Error?

        // When
        do {
            try await healthKitService.askUserPermission()
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError?.localizedDescription, "Mock auth error")
    }

    func testFetchAllData_setsCorrectValues() async {
        // Given
        mockHealthStore.mockStepCount = 15000
        mockHealthStore.mockDistance = 8000

        // When
        await healthKitService.fetchAllData()

        // Then
        let actualStepCount = healthKitService.stepCount
        let actualDistance = healthKitService.distance

        XCTAssertEqual(actualStepCount, 15000)
        XCTAssertEqual(actualDistance, 8000)
    }

    func testFetchData_stepCount_success() async {
        // Given
        mockHealthStore.mockStepCount = 9500
        let stepCountType = HKQuantityType(.stepCount)

        // When
        let result = await healthKitService.fetchData(for: stepCountType)

        // Then
        XCTAssertEqual(result, 9500)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)
        XCTAssertEqual(healthKitService.lastFetchType, stepCountType)

        let actualStepCount = healthKitService.stepCount
        XCTAssertEqual(actualStepCount, 9500)
    }

    func testFetchData_distance_success() async {
        // Given
        mockHealthStore.mockDistance = 3800
        let distanceType = HKQuantityType(.distanceWalkingRunning)

        // When
        let result = await healthKitService.fetchData(for: distanceType)

        // Then
        XCTAssertEqual(result, 3800)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)
        XCTAssertEqual(healthKitService.lastFetchType, distanceType)

        let actualDistance = healthKitService.distance
        XCTAssertEqual(actualDistance, 3800)
    }

    func testFetchData_queryError_returnsDefaultValue() async {
        // Given
        mockHealthStore.shouldThrowQueryError = true
        let stepCountType = HKQuantityType(.stepCount)

        // When
        let result = await healthKitService.fetchData(for: stepCountType)

        // Then
        XCTAssertEqual(result, 5000)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)

        let actualStepCount = healthKitService.stepCount
        XCTAssertEqual(actualStepCount, 5000)
    }

    func testFetchData_unknownType_usesStepCountLogic() async {
        // Given
        mockHealthStore.mockStepCount = 2300
        let unknownType = HKQuantityType(.bodyMass)

        // When
        let result = await healthKitService.fetchData(for: unknownType)

        // Then
        XCTAssertEqual(result, 2300)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)
        XCTAssertEqual(healthKitService.lastFetchType, unknownType)
    }

    func testFetchData_nilCollection_returnsDefaultValue() async {
        // Given
        mockHealthStore.shouldReturnNilCollection = true
        let stepCountType = HKQuantityType(.stepCount)

        // When
        let result = await healthKitService.fetchData(for: stepCountType)

        // Then
        XCTAssertEqual(result, 5000)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)

        let actualStepCount = healthKitService.stepCount
        XCTAssertEqual(actualStepCount, 5000)
    }

    func testFetchData_withMockDataToReturn_returnsMockValue() async {
        // Given
        let mockValue = 7777
        healthKitService.mockDataToReturn = mockValue
        let stepCountType = HKQuantityType(.stepCount)

        // When
        let result = await healthKitService.fetchData(for: stepCountType)

        // Then
        XCTAssertEqual(result, mockValue)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)

        let actualStepCount = healthKitService.stepCount
        XCTAssertEqual(actualStepCount, mockValue)
    }

    func testFetchDataForDatatypeAndDate_steps_success() async {
        // Given
        mockHealthStore.mockStepCount = 14000
        let stepCountType = HKQuantityType(.stepCount)
        let startDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        let endDate = Date()

        // When
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: stepCountType,
            from: startDate,
            to: endDate
        )

        // Then
        XCTAssertEqual(result, 14000)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertEqual(healthKitService.lastFetchType, stepCountType)
    }

    func testFetchDataForDatatypeAndDate_distance_success() async {
        // Given
        mockHealthStore.mockDistance = 9500
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        let endDate = Date()

        // When
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: distanceType,
            from: startDate,
            to: endDate
        )

        // Then
        XCTAssertEqual(result, 9500)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertEqual(healthKitService.lastFetchType, distanceType)
    }

    func testFetchDataForDatatypeAndDate_queryError_returnsZero() async {
        // Given
        mockHealthStore.shouldThrowQueryError = true
        let stepCountType = HKQuantityType(.stepCount)
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()

        // When
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: stepCountType,
            from: startDate,
            to: endDate
        )

        // Then
        XCTAssertEqual(result, 0)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 1)
    }

    func testFetchDataForDatatypeAndDate_unknownType_usesStepCountLogic() async {
        // Given
        let unknownType = HKQuantityType(.uvExposure)
        mockHealthStore.mockStepCount = 1500
        let startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let endDate = Date()

        // When
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: unknownType,
            from: startDate,
            to: endDate
        )

        // Then
        XCTAssertEqual(result, 1500)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertEqual(healthKitService.lastFetchType, unknownType)
    }

    func testFetchDataForDatatypeAndDate_nilCollection_returnsZero() async {
        // Given
        mockHealthStore.shouldReturnNilCollection = true
        let stepCountType = HKQuantityType(.stepCount)
        let startDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
        let endDate = Date()

        // When
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: stepCountType,
            from: startDate,
            to: endDate
        )

        // Then
        XCTAssertEqual(result, 0)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 1)
    }

    func testFetchDataForDatatypeAndDate_withMockDataToReturn_returnsMockValue() async {
        // Given
        let mockValue = 5555
        healthKitService.mockDataToReturn = mockValue
        let stepCountType = HKQuantityType(.stepCount)
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let endDate = Date()

        // When
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: stepCountType,
            from: startDate,
            to: endDate
        )

        // Then
        XCTAssertEqual(result, mockValue)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 1)
    }

    func testPublishedStepCountUpdated() async {
        // Given
        let expectation = XCTestExpectation(description: "Step count published property updated")
        let expectedValue = 11000

        healthKitService.$stepCount
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value, expectedValue)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        mockHealthStore.mockStepCount = Double(expectedValue)
        _ = await healthKitService.fetchData(for: HKQuantityType(.stepCount))

        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testPublishedDistanceUpdated() async {
        // Given
        let expectation = XCTestExpectation(description: "Distance published property updated")
        let expectedValue = 6500

        healthKitService.$distance
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value, expectedValue)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        mockHealthStore.mockDistance = Double(expectedValue)
        _ = await healthKitService.fetchData(for: HKQuantityType(.distanceWalkingRunning))

        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testReset_clearsAllData() async {
        // Given
        healthKitService.mockDataToReturn = 999
        _ = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        _ = await healthKitService.fetchDataForDatatypeAndDate(
            for: HKQuantityType(.distanceWalkingRunning),
            from: Date(),
            to: Date()
        )

        // Verify data exists before reset
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertNotNil(healthKitService.lastFetchType)
        XCTAssertNotNil(healthKitService.mockDataToReturn)

        // When
        healthKitService.reset()

        // Then
        XCTAssertEqual(healthKitService.fetchDataCallCount, 0)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 0)
        XCTAssertNil(healthKitService.lastFetchType)
        XCTAssertNil(healthKitService.mockDataToReturn)
        
        let stepCount = healthKitService.stepCount
        let distance = healthKitService.distance
        XCTAssertEqual(stepCount, 0)
        XCTAssertEqual(distance, 0)
    }

    func testCallCountTracking_multipleCallsIncrement() async {
        // Given
        let stepCountType = HKQuantityType(.stepCount)
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        let startDate = Date()
        let endDate = Date()

        // When
        _ = await healthKitService.fetchData(for: stepCountType)
        _ = await healthKitService.fetchData(for: distanceType)
        _ = await healthKitService.fetchDataForDatatypeAndDate(for: stepCountType, from: startDate, to: endDate)
        _ = await healthKitService.fetchDataForDatatypeAndDate(for: distanceType, from: startDate, to: endDate)

        // Then
        XCTAssertEqual(healthKitService.fetchDataCallCount, 2)
        XCTAssertEqual(healthKitService.fetchDataForDatatypeAndDateCallCount, 2)
        XCTAssertEqual(healthKitService.lastFetchType, distanceType)
    }

    func testFetchData_multipleTypesSequentially() async {
        // Given
        mockHealthStore.mockStepCount = 5000
        mockHealthStore.mockDistance = 3000

        // When & Then
        let stepResult = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        XCTAssertEqual(stepResult, 5000)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 1)

        let distanceResult = await healthKitService.fetchData(for: HKQuantityType(.distanceWalkingRunning))
        XCTAssertEqual(distanceResult, 3000)
        XCTAssertEqual(healthKitService.fetchDataCallCount, 2)

        let finalStepCount = healthKitService.stepCount
        let finalDistance = healthKitService.distance
        XCTAssertEqual(finalStepCount, 5000)
        XCTAssertEqual(finalDistance, 3000)
    }

    func testFetchData_zeroValues() async {
        // Given
        mockHealthStore.mockStepCount = 0
        mockHealthStore.mockDistance = 0

        // When
        let stepResult = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        let distanceResult = await healthKitService.fetchData(for: HKQuantityType(.distanceWalkingRunning))

        // Then
        XCTAssertEqual(stepResult, 0)
        XCTAssertEqual(distanceResult, 0)
        
        let finalStepCount = healthKitService.stepCount
        let finalDistance = healthKitService.distance
        XCTAssertEqual(finalStepCount, 0)
        XCTAssertEqual(finalDistance, 0)
    }

    func testFetchData_largeValues() async {
        // Given
        let largeStepCount = 99999.0
        let largeDistance = 88888.0
        mockHealthStore.mockStepCount = largeStepCount
        mockHealthStore.mockDistance = largeDistance

        // When
        let stepResult = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        let distanceResult = await healthKitService.fetchData(for: HKQuantityType(.distanceWalkingRunning))

        // Then
        XCTAssertEqual(stepResult, Int(largeStepCount))
        XCTAssertEqual(distanceResult, Int(largeDistance))
    }

    func testCompleteWorkflow_initializeAndFetch() async {
        // Given
        mockHealthStore.mockStepCount = 7500
        mockHealthStore.mockDistance = 4200

        // When
        await healthKitService.initialize()
        let fetchedSteps = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        let fetchedDistance = await healthKitService.fetchDataForDatatypeAndDate(
            for: HKQuantityType(.distanceWalkingRunning),
            from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            to: Date()
        )

        // Then
        XCTAssertEqual(fetchedSteps, 7500)
        XCTAssertEqual(fetchedDistance, 4200)
        
        let finalStepCount = healthKitService.stepCount
        let finalDistance = healthKitService.distance
        XCTAssertEqual(finalStepCount, 7500)
        XCTAssertEqual(finalDistance, 4200)
    }
}
