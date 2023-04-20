//
//  SleepViewModel.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import Foundation
import Combine

class SleepViewModel: ObservableObject {
    @Published private var sleepService: SleepService

    @Published var measurementMethod: MeasurementMethod = UserDefaults.standard.measurementMethod
    
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var notes = ""
    
    @Published var elapsedTime: TimeInterval = 0
    
    var sleepToEdit: SleepEvent?
    var isEditMode: Bool {
        return sleepToEdit != nil
    }
        
    init(sleepService: SleepService = DataManager.shared, sleepToEdit: SleepEvent? = nil) {
        self.sleepService = sleepService
        self.sleepToEdit = sleepToEdit
        
        if let edit = sleepToEdit {
            startTime = edit.timestamp
            endTime = edit.endTimestamp ?? Date()            
            notes = edit.note ?? ""
            measurementMethod = .manual
        }
    }
    
    func save() {
        
        if let editId = sleepToEdit?.id {
            
            var endTimestamp: Date
            if elapsedTime > 0 {
                endTimestamp = startTime.addingTimeInterval(elapsedTime)
            } else {
                endTimestamp = endTime
            }
            
            let sleepEvent = SleepEvent(id: editId,
                                        serverId: nil,
                                        timestamp: startTime,
                                        endTimestamp: endTimestamp,
                                        note: notes)
            sleepService.update(sleepEvent)
            
        } else {
            
            var endTimestamp: Date
            if elapsedTime > 0 {
                endTimestamp = startTime.addingTimeInterval(elapsedTime)
            } else {
                endTimestamp = endTime
            }
            
            let sleepEvent = SleepEvent(id: UUID(),
                                        serverId: nil,
                                        timestamp: startTime,
                                        endTimestamp: endTimestamp,
                                        note: notes)
       
            sleepService.create(sleepEvent)
        }
    }
    
    func delete() {
        guard let deleteId = sleepToEdit?.id else { return }
        sleepService.delete(id: deleteId)
    }
}
