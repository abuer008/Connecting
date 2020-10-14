//
//  HealthKitData.swift
//  Connecting
//
//  Created by bowei xiao on 06.10.20.
//

import HealthKit

class HealthKitData {
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")

    var heartRateValue:Int = 0

    func start() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.heartRate)
    }

    func autorizeHealthKit() {
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if !success { print("healthStore authorisation failed...") }
        }
    }

    func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
//        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        #if os(watchOS)
        let predicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let limit = HKObjectQueryNoLimit
        #else
        let predicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-3600), end: Date(), options: [])
        let limit = Int(3)
        #endif
        
        let realtimeQuery = HKObserverQuery(sampleType: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: nil) { (realtimeQuery, _, errorOrNil) in
            if errorOrNil != nil { return }
        
        }
        
        self.healthStore.execute(realtimeQuery)


        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: predicate, anchor: nil, limit: limit) { (query, samples, deletedObjects, queryAnchor, error) in
            guard let samples = samples as? [HKQuantitySample] else { return }

            self.process(samples, type: quantityTypeIdentifier)
        }

        healthStore.execute(query)
    }

    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0

        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }

            self.heartRateValue = Int(lastHeartRate)
            print("\(self.heartRateValue)")
        }
    }
}
