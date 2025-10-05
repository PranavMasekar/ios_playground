import Foundation
import HealthKit

class HealthKitApiImplementation: HealthKitApi {

    let store = HKHealthStore()
    
    let typesToRead: Set = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!
    ]
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        store.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if success {
                print("Permission Approved")
                completion(true)
            } else {
                print("Permission Rejected: \(String(describing: error))")
                completion(false)
            }
        }
    }
    
    // MARK: Get Health Summary
    func getHealthSummary(completion: @escaping (Result<HealthSummary, any Error>) -> Void) {
        requestPermission { granted in
            guard granted else {
                completion(.success(HealthSummary(steps: 0, calories: 0, avgHeartRate: 0)))
                return
            }
            
            let startOfDay = Calendar.current.startOfDay(for: Date())
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
            
            var steps: Double = 0
            var calories: Double = 0
            var heartRate: Double = 0
            
            let group = DispatchGroup()
            
            if let type = HKQuantityType.quantityType(forIdentifier: .stepCount) {
                group.enter()
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                    steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    group.leave()
                }
                self.store.execute(query)
            }
            
            if let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
                group.enter()
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                    calories = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                    group.leave()
                }
                self.store.execute(query)
            }
            
            if let type = HKQuantityType.quantityType(forIdentifier: .heartRate) {
                group.enter()
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
                    heartRate = result?.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0
                    group.leave()
                }
                self.store.execute(query)
            }
            
            group.notify(queue: .main) {
                let summary = HealthSummary(
                    steps: Int64(steps),
                    calories: calories,
                    avgHeartRate: heartRate
                )
                print("Health summary:", summary)
                completion(.success(summary))
            }
        }
    }
}
