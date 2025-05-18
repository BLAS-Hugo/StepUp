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

// MARK: - Test cases
class HealthKitServiceTests: XCTestCase {
    var mockHealthStore: MockHealthKitStore!
    var healthKitService: MockHealthKitService!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() async throws {
        mockHealthStore = MockHealthKitStore()
        healthKitService = await MockHealthKitService(mockHealthStore: mockHealthStore)
    }

    override func tearDown() {
        cancellables.removeAll()
        mockHealthStore = nil
        healthKitService = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitialization_Success() async {
        await healthKitService.initialize()
        let actualStepCount = await healthKitService.stepCount
        XCTAssertEqual(
            actualStepCount,
            10000,
            "Default mock step count should be set on successful init."
        )
        let actualDistance = await healthKitService.distance
        XCTAssertEqual(
            actualDistance,
            5000,
            "Default mock distance should be set on successful init."
        )
    }

    func testInitialization_AuthError() async {
        mockHealthStore.shouldThrowAuthError = true
        await healthKitService.initialize()
        let actualStepCount = await healthKitService.stepCount
        XCTAssertEqual(
            actualStepCount,
            0,
            "Step count should be 0 after auth error."
        )
        let actualDistance = await healthKitService.distance
        XCTAssertEqual(
            actualDistance,
            0,
            "Distance should be 0 after auth error."
        )
    }

    @MainActor
    func testInitialization_QueryErrorDuringFetchAllData() async {
        healthKitService.shouldFailInitialization = true
        await healthKitService.initialize()
        let actualStepCount = healthKitService.stepCount
        XCTAssertEqual(
            actualStepCount,
            0,
            "Step count should be default error value after query error during init."
        )
        let actualDistance = healthKitService.distance
        XCTAssertEqual(
            actualDistance,
            0,
            "Distance should be default error value after query error during init."
        )
    }

    func testInitialization_NilCollectionDuringFetchAllData() async {
        mockHealthStore.shouldReturnNilCollection = true
        await healthKitService.initialize()
        let actualStepCount = await healthKitService.stepCount
        XCTAssertEqual(
            actualStepCount,
            10000,
            "Step count should match mockHealthStore value if collection is nil during init."
        )
        let actualDistance = await healthKitService.distance
        XCTAssertEqual(
            actualDistance,
            5000,
            "Distance should match mockHealthStore value if collection is nil during init."
        )
    }

    // MARK: - Data Fetching Tests (fetchData)

    func testFetchData_StepCount_Success() async {
        mockHealthStore.mockStepCount = 8500
        let result = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        XCTAssertEqual(result, 8500)
        let actualStepCount = await healthKitService.stepCount
        XCTAssertEqual(
            actualStepCount,
            8500,
            "Published stepCount should be updated."
        )
    }

    func testFetchData_Distance_Success() async {
        mockHealthStore.mockDistance = 3200
        let result = await healthKitService.fetchData(for: HKQuantityType(.distanceWalkingRunning))
        XCTAssertEqual(result, 3200)
        let actualDistance = await healthKitService.distance
        XCTAssertEqual(
            actualDistance,
            3200,
            "Published distance should be updated."
        )
    }

    func testFetchData_QueryError() async {
        mockHealthStore.shouldThrowQueryError = true
        let result = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        XCTAssertEqual(
            result,
            5000,
            "Should return default value on query error."
        )
        let actualStepCount = await healthKitService.stepCount
        XCTAssertEqual(
            actualStepCount,
            5000,
            "Published stepCount should be default on query error."
        )
    }

    func testFetchData_UnknownType() async {
        mockHealthStore.mockStepCount = 1234
        let result = await healthKitService.fetchData(for: HKQuantityType(.bodyMass))
        XCTAssertEqual(
            result,
            1234,
            "Result for unknown type should use mockStepCount via default .count() logic."
        )
    }

    func testFetchData_NilCollection() async {
        mockHealthStore.shouldReturnNilCollection = true
        let result = await healthKitService.fetchData(for: HKQuantityType(.stepCount))
        XCTAssertEqual(
            result,
            5000,
            "Result should be default if collection is nil."
        )
        let actualStepCount = await healthKitService.stepCount
        XCTAssertEqual(
            actualStepCount,
            5000,
            "Published stepCount should be default if collection is nil."
        )
    }

    // MARK: - Fetching Data for Date Range Tests (fetchDataForDatatypeAndDate)

    func testFetchDataForDatatypeAndDate_Steps_Success() async {
        mockHealthStore.mockStepCount = 12000
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: HKQuantityType(.stepCount),
            from: startDate,
            to: endDate
        )
        XCTAssertEqual(result, 12000)
    }

    func testFetchDataForDatatypeAndDate_Distance_Success() async {
        mockHealthStore.mockDistance = 7500
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: HKQuantityType(.distanceWalkingRunning),
            from: startDate,
            to: endDate
        )
        XCTAssertEqual(result, 7500)
    }

    func testFetchDataForDatatypeAndDate_QueryError() async {
        mockHealthStore.shouldThrowQueryError = true
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: HKQuantityType(.stepCount),
            from: startDate,
            to: endDate
        )
        XCTAssertEqual(
            result,
            0,
            "Should return 0 on query error for date range fetch."
        )
    }

    func testFetchDataForDatatypeAndDate_UnknownType() async {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        mockHealthStore.mockStepCount = 987
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: HKQuantityType(.uvExposure),
            from: startDate,
            to: endDate
        )
        XCTAssertEqual(
            result,
            987,
            "Result for unknown type in date range should use mockStepCount via default .count() logic."
        )
    }

    func testFetchDataForDatatypeAndDate_NilCollection() async {
        mockHealthStore.shouldReturnNilCollection = true
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let result = await healthKitService.fetchDataForDatatypeAndDate(
            for: HKQuantityType(.stepCount),
            from: startDate,
            to: endDate
        )
        XCTAssertEqual(
            result,
            0,
            "Result should be 0 if collection is nil for date range fetch."
        )
    }

    // MARK: - Published Properties Tests

    func testPublishedPropertiesUpdated() async {
        let expectation = XCTestExpectation(description: "Published property updated")

        await healthKitService.$stepCount
            .dropFirst() // Skip initial value
            .sink { value in
                XCTAssertEqual(value, 8000) // This XCTAssertEqual is fine as `value` is not actor-isolated here.
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockHealthStore.mockStepCount = 8000
        _ = await healthKitService.fetchData(for: HKQuantityType(.stepCount))

        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
