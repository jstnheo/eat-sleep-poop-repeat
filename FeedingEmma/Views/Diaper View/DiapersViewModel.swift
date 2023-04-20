//
//  DiapersViewModel.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import Foundation
import Combine

class DiapersViewModel: ObservableObject {
    
    @Published private var service: DiaperService
    
    @Published var startTime = Date()
    @Published var diaperCondition: DiaperCondition = .clean
    @Published var messyRating: Double = 0
    @Published var notes = ""
    
    var anyCancellable: AnyCancellable? = nil
    
    var diaperToEdit: DiaperEvent?
    var isEditMode: Bool {
        return diaperToEdit != nil
    }
    
    init(service: DiaperService = DataManager.shared, diaperToEdit: DiaperEvent? = nil) {
        self.service = service
        self.diaperToEdit = diaperToEdit
        
        if let edit = diaperToEdit {
            startTime = edit.timestamp
            diaperCondition = edit.condition
            messyRating = Double(edit.messRating)
            notes = edit.note ?? ""
        }
    }
    
    func save() {
        if let editId = diaperToEdit?.id {
            
            let diaperEvent = DiaperEvent(id: editId,
                                          serverId: nil,
                                          timestamp: startTime,
                                          condition: diaperCondition,
                                          messRating: Int(messyRating),
                                          note: notes)
            
            service.updateDiaperEvent(diaperEvent)
            
        } else {
            
            let diaperEvent = DiaperEvent(id: UUID(),
                                          serverId: nil,
                                          timestamp: startTime,
                                          condition: diaperCondition,
                                          messRating: Int(messyRating),
                                          note: notes)
            
            service.createDiaperEvent(diaperEvent)
        }
    }
    
    func delete() {
        guard let deleteId = diaperToEdit?.id else { return }
        service.deleteDiaperEvent(id: deleteId)
    }
}
