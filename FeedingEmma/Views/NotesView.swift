//
//  NotesView.swift
//  FeedingEmma
//
//  Created by Justin on 4/5/23.
//

import SwiftUI

struct NotesView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var note: String
    private let maxNoteLength = 10 // Set the maximum character limit
    
    var body: some View {
        
        VStack {
            TextEditor(text: $note)
                .frame(minHeight: 300)
               
            Text("\(note.count)/\(maxNoteLength)")
        }
        .background {
            Color("Baby Blue")
        }
        .navigationTitle("Notes")
        .navigationBarItems(trailing:
            Button(action: {
                note = ""
            }, label: {
                Text("Clear")
            })
        )
        .onAppear {
           note = String(note.prefix(maxNoteLength)) // Set initial value of note to be no more than the maximum limit
        }
        .onChange(of: note) { newValue in
            note = String(newValue.prefix(maxNoteLength))
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(note: .constant("Some notes"))
    }
}
