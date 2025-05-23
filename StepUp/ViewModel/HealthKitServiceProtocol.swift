//
//  HealthKitServiceProtocol.swift
//  StepUp
//
//  Created by Hugo Blas on 16/05/2025.
//

import Foundation
import HealthKit
import Combine

@MainActor
protocol CustomStatisticsProtocol {
    func sumQuantity() -> HKQuantity?
    var quantityType: HKQuantityType { get }
}

@MainActor
protocol CustomStatisticsCollectionProtocol {
    func enumerateStatistics(
        from startDate: Date,
        to endDate: Date,
        with block: @escaping (CustomStatisticsProtocol,
                               UnsafeMutablePointer<ObjCBool>) -> Void)
}

protocol HealthKitStoreProtocol {
    func requestAuthorization(
        toShare: Set<HKSampleType>,
        read: Set<HKObjectType>) async throws
    func execute(_ descriptor: HKStatisticsCollectionQueryDescriptor) async throws -> CustomStatisticsCollectionProtocol
}

/// Interface for the HealthKit service
@MainActor
protocol HealthKitServiceProtocol: ObservableObject {
    /// Published step count
    var stepCount: Int { get }

    /// Published distance
    var distance: Int { get }

    /// Initialize the service and request permissions
    func initialize() async

    /// Ask for user permission to access HealthKit data
    func askUserPermission() async throws

    /// Fetch all available data
    func fetchAllData() async

    /// Fetch data for a specific quantity type
    /// - Parameter datatype: The quantity type to fetch
    /// - Returns: The fetched value as an integer
    func fetchData(for datatype: HKQuantityType) async -> Int

    /// Fetch data for a specific quantity type and date range
    /// - Parameters:
    ///   - datatype: The quantity type to fetch
    ///   - startDate: The start date for the query
    ///   - endDate: The end date for the query
    /// - Returns: The accumulated value as an integer
    func fetchDataForDatatypeAndDate(
        for datatype: HKQuantityType,
        from startDate: Date,
        to endDate: Date) async -> Int
}
