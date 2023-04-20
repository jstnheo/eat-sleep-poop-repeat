//
//  UserDefaultsManager.swift
//  FeedingEmma
//
//  Created by Justin on 4/6/23.
//

import Foundation

extension UserDefaults {

    private struct Keys {
        static let babyName = "babyName"
        static let measurementUnit = "measurementUnit"
        static let measurementMethod = "measurementMethod"
    }

    func registerDefaults() {
        register(defaults: [
            Keys.babyName: "",
            Keys.measurementUnit: MeasurementUnit.ml,
            Keys.measurementMethod: MeasurementMethod.timer,
        ])
    }

    var babyName: String {
        get {
            return string(forKey: Keys.babyName) ?? ""
        }
        
        set {
            set(newValue, forKey: Keys.babyName)
        }
    }
    
    var measurementUnit: MeasurementUnit {
        get {
            let unit = string(forKey: Keys.measurementUnit)
            return MeasurementUnit(rawValue: unit ?? "ml") ?? .ml
        }
        set {
            set(newValue.rawValue, forKey: Keys.measurementUnit)
        }
    }
    
    var measurementMethod: MeasurementMethod {
        get {
            let method = string(forKey: Keys.measurementMethod)
            return MeasurementMethod(rawValue: method ?? "timer") ?? .timer
        }
        set {
            set(newValue.rawValue, forKey: Keys.measurementMethod)
        }
    }

}
