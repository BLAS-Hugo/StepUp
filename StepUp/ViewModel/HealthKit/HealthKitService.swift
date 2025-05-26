//
//  HealthKitService.swift
//  StepUp
//
//  Created by Hugo Blas on 10/04/2025.
//

import HealthKit

struct HKStatisticsAdapter: CustomStatisticsProtocol {
    private let hkStatistics: HKStatistics

    init(hkStatistics: HKStatistics) {
        self.hkStatistics = hkStatistics
    }

    func sumQuantity() -> HKQuantity? {
        return hkStatistics.sumQuantity()
    }

    var quantityType: HKQuantityType {
        return hkStatistics.quantityType
    }
}

struct HKStatisticsCollectionAdapter: CustomStatisticsCollectionProtocol {
    private let hkStatisticsCollection: HKStatisticsCollection

    init(hkStatisticsCollection: HKStatisticsCollection) {
        self.hkStatisticsCollection = hkStatisticsCollection
    }

    func enumerateStatistics(
        from startDate: Date,
        to endDate: Date,
        with block: @escaping (CustomStatisticsProtocol, UnsafeMutablePointer<ObjCBool>) -> Void) {
        hkStatisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (hkStatistic, stop) in
            let adapter = HKStatisticsAdapter(hkStatistics: hkStatistic)
            block(adapter, stop)
        }
    }
}

extension HKHealthStore: HealthKitStoreProtocol {
    func execute(_ descriptor: HKStatisticsCollectionQueryDescriptor)
        async throws -> CustomStatisticsCollectionProtocol {
        let realCollection = try await descriptor.result(for: self)
        return await HKStatisticsCollectionAdapter(hkStatisticsCollection: realCollection)
    }
}

class HealthKitService: HealthKitServiceProtocol {
    @Published var stepCount: Int = 0
    @Published var distance: Int = 0

    var healthStore: HealthKitStoreProtocol

    let datatypeToRead: Set<HKObjectType> = {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return Set()
        }
        return [stepType, distanceType]
    }()

    init(healthStore: HealthKitStoreProtocol = HKHealthStore()) {
        self.healthStore = healthStore
        Task {
            await initialize()
        }
    }

    func initialize() async {
        do {
            try await askUserPermission()
        } catch {
            return
        }
        await fetchAllData()
    }

    func askUserPermission() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }

        try await healthStore.requestAuthorization(toShare: [], read: datatypeToRead)
    }

    func fetchAllData() async {
        _ = await fetchData(for: HKQuantityType(.stepCount))
        _ = await fetchData(for: HKQuantityType(.distanceWalkingRunning))
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

        let data: CustomStatisticsCollectionProtocol?
        do {
            data = try await healthStore.execute(query)
        } catch {
            data = nil
        }

        var result: Int = 5000

        data?.enumerateStatistics(
            from: Date(), to: Date()) { (statistic, _) in
            let unit = self.unitFor(datatype: datatype)
            let count = statistic.sumQuantity()?.doubleValue(for: unit)
            result = Int(count ?? 5000)
            DispatchQueue.main.async {
                self.updatePublishedProperties(for: datatype, with: count ?? 5000)
            }
        }
        return result
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

        let data: CustomStatisticsCollectionProtocol?
        do {
            data = try await healthStore.execute(query)
        } catch {
            data = nil
        }

        var result: Int = 0

        data?.enumerateStatistics(
            from: startDate, to: endDate) { (statistic, _) in
            let unit = self.unitFor(datatype: datatype)
            let count = statistic.sumQuantity()?.doubleValue(for: unit)
            result += Int(count ?? 0)
        }
        return result
    }

    private func updatePublishedProperties(for datatype: HKQuantityType, with value: Double) {
        let intValue = Int(value)
        switch datatype {
        case HKQuantityType(.stepCount):
            self.stepCount = intValue
        case HKQuantityType(.distanceWalkingRunning):
            self.distance = intValue
        default:
            break
        }
    }

    private func unitFor(datatype: HKQuantityType) -> HKUnit {
        switch datatype {
        case HKQuantityType(.stepCount):
            return .count()
        case HKQuantityType(.distanceWalkingRunning):
            return .meter()
        default:
            return .count()
        }
    }
}
