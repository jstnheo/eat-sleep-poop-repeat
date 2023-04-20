//
//  FeedingViewModel.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import Foundation
import Combine

class FeedingViewModel: ObservableObject {
    @Published private var service: FeedingService

    @Published var measurementMethod: MeasurementMethod = UserDefaults.standard.measurementMethod
    
    @Published var startTime = Date()
    @Published var endTime = Date()
    
    @Published var elapsedLeftTime: TimeInterval = 0
    @Published var elapsedRightTime: TimeInterval = 0
    
    @Published var elapsedTime: TimeInterval = 0 

    @Published var notes = ""
    @Published var feedingSource: FeedingSource = .bottle
    @Published var nourishment: Nourishment = .breastMilk

    @Published var amountOZ: Float = 0
    @Published var amountML: Float = 0
    @Published var amountTS: Float = 0
        
    var feedingToEdit: FeedingEvent?
    var isEditMode: Bool {
        return feedingToEdit != nil
    }
    
    init(service: FeedingService = DataManager.shared, feedingToEdit: FeedingEvent? = nil) {
        self.service = service
        self.feedingToEdit = feedingToEdit
        
        if let edit = feedingToEdit {
            startTime = edit.timestamp
            endTime = edit.endTimestamp ?? Date()
            
            feedingSource = edit.source
            nourishment = edit.nourishment
            
            measurementMethod = .manual
            
            switch UserDefaults.standard.measurementUnit {
            case .ml:
                amountML = Float(edit.mlAmount ?? 0)
            case .oz:
                amountOZ = mlToOz(edit.mlAmount ?? 0)
            }
                    
            notes = edit.note ?? ""
        }
    }
    
    private func mlToOz(_ ml: Float) -> Float {
        let oz = ml / 29.574
        return oz
    }
    
    private func ozToMl(_ oz: Float) -> Float {
        let ml = oz * 29.574
        return ml
    }
    
    func save() {
        
        if let editId = feedingToEdit?.id {
            
            // Calculate End Time
            var endTimeStamp: Date
            if elapsedLeftTime > 0 || elapsedRightTime > 0 {
                endTimeStamp = startTime.addingTimeInterval(elapsedLeftTime).addingTimeInterval(elapsedRightTime)
            } else if elapsedTime > 0 {
                endTimeStamp = startTime.addingTimeInterval(elapsedTime)
            } else {
                endTimeStamp = endTime
            }
            
            // Calculate ML
            var mlAmount: Float
            if amountOZ > 0 {
                mlAmount = ozToMl(amountOZ)
            } else {
                mlAmount = amountML
            }
            
            let feedingEvent = FeedingEvent(id: editId,
                                            serverId: nil,
                                            timestamp: startTime,
                                            endTimestamp: endTimeStamp,
                                            leftSeconds: 0,
                                            rightSeconds: 0,
                                            gAmount: 0,
                                            mlAmount: mlAmount,
                                            source: feedingSource,
                                            nourishment: nourishment,
                                            note: notes)
            
            service.updateFeedingEvent(feedingEvent)
            
        } else {
            
            // Calculate End Time
            var endTimeStamp: Date
            if elapsedLeftTime > 0 || elapsedRightTime > 0 {
                endTimeStamp = startTime.addingTimeInterval(elapsedLeftTime).addingTimeInterval(elapsedRightTime)
            } else if elapsedTime > 0 {
                endTimeStamp = startTime.addingTimeInterval(elapsedTime)
            } else {
                endTimeStamp = endTime
            }
            
            // Calculate ML
            var mlAmount: Float
            if amountOZ > 0 {
                mlAmount = ozToMl(amountOZ)
            } else {
                mlAmount = amountML
            }
            
            let feedingEvent = FeedingEvent(id: UUID(),
                                            serverId: nil,
                                            timestamp: startTime,
                                            endTimestamp: endTimeStamp,
                                            leftSeconds: elapsedLeftTime,
                                            rightSeconds: elapsedRightTime,
                                            gAmount: 0,
                                            mlAmount: mlAmount,
                                            source: feedingSource,
                                            nourishment: nourishment,
                                            note: notes)
       
            service.createFeedingEvent(feedingEvent)
        }
    }
    
    func delete() {
        guard let deleteId = feedingToEdit?.id else { return }
        service.deleteFeedingEvent(id: deleteId)
    }
}
