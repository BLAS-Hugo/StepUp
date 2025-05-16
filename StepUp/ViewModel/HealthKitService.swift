//
//  HealthKitService.swift
//  StepUp
//
//  Created by Hugo Blas on 10/04/2025.
//

import HealthKit

class HealthKitService: ObservableObject {
    @Published var stepCount: Int = 0
    @Published var distance: Int = 0

    private let healthStore = HKHealthStore()

    private let datatypeToRead = Set([
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    ])

    init() {
        Task {
            await initialize()
        }
    }

    func initialize() async {
        do {
            try await askUserPermission()
        } catch {
            print(error.localizedDescription)
            return
        }
        await fetchAllData()
    }

    private func askUserPermission() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
              print("health data not available!")
              return
            }

            try await healthStore.requestAuthorization(toShare: [], read: datatypeToRead)

    }

    private func fetchAllData() async {
        _ = await fetchData(for: HKQuantityType(.stepCount))
        _ = await fetchData(for: HKQuantityType(.distanceWalkingRunning))
    }

    private func fetchData(for datatype: HKQuantityType) async -> Int {
        let predicate = HKQuery.predicateForSamples(withStart: Date(), end: Date())
        let sample = HKSamplePredicate.quantitySample(type: datatype, predicate: predicate)

        let query = HKStatisticsCollectionQueryDescriptor(
            predicate: sample,
            options: .mostRecent,
            anchorDate: Date(),
            intervalComponents: DateComponents(day: 1)
        )

        let data = try? await query.result(for: healthStore)

        var result: Int = 5000

        data?.enumerateStatistics(
            from: Date(), to: Date()) { (statistic, _) in
            let unit: HKUnit
            switch datatype {
            case HKQuantityType(.stepCount):
                unit = .count()
            case HKQuantityType(.distanceWalkingRunning):
                unit = .meter()
            default:
                unit = .count()
            }
            let count = statistic.sumQuantity()?.doubleValue(for: unit)
            result = Int(count ?? 5000)
            DispatchQueue.main.async {
                switch datatype {
                case HKQuantityType(.stepCount):
                    self.stepCount = Int(count ?? 5000)
                case HKQuantityType(.distanceWalkingRunning):
                    self.distance = Int(count ?? 5000)
                default:
                    break
                }
            }
        }
        return result
    }

    func fetchDataForDatatypeAndDate(
        for datatype: HKQuantityType,
        from startDate: Date,
        to endDate: Date) async -> Int {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sample = HKSamplePredicate.quantitySample(type: datatype, predicate: predicate)

        let query = HKStatisticsCollectionQueryDescriptor(
            predicate: sample,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )

        let data = try? await query.result(for: healthStore)

        var result: Int = 0

        data?.enumerateStatistics(
            from: startDate, to: endDate) { (statistic, _) in
            let unit: HKUnit
            switch datatype {
            case HKQuantityType(.stepCount):
                unit = .count()
            case HKQuantityType(.distanceWalkingRunning):
                unit = .meter()
            default:
                unit = .count()
            }
            let count = statistic.sumQuantity()?.doubleValue(for: unit)
            result += Int(count ?? 0)
        }
        return result
    }
}
