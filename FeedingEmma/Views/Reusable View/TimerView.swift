//
//  TimerView.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//

import SwiftUI

// Add an enumeration for the time format
enum TimeFormat {
    case hoursMinutesSeconds
    case minutesSeconds
}

struct TimerView: View {
    @Binding var elapsedTime: TimeInterval
    @State private var timer: Timer? = nil
    @State private var isRunning: Bool = false

    private let maxTime: TimeInterval = 3600 // Set the maximum value (e.g., 3600 seconds or 1 hour)
    
    // Add a property for the time format
    var timeFormat: TimeFormat = .hoursMinutesSeconds

    var body: some View {
        VStack {
            Text(timeFormatted(elapsedTime))
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

            Button(action: {
                if isRunning {
                    pauseTimer()
                } else {
                    startTimer()
                }
            }) {
                Text(isRunning ? "Pause" : "Start")
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.icon)
                    .cornerRadius(10)
            }
        }
    }

    private func startTimer() {
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if elapsedTime < maxTime {
                elapsedTime += 1
            } else {
                pauseTimer()
            }
        }
    }

    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    private func timeFormatted(_ totalSeconds: TimeInterval) -> String {
        let seconds: Int = Int(totalSeconds) % 60
        let minutes: Int = Int(totalSeconds / 60) % 60
        let hours: Int = Int(totalSeconds / 3600)
        
        // Use the timeFormat to decide the format of the string
        switch timeFormat {
        case .hoursMinutesSeconds:
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        case .minutesSeconds:
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

//struct TimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            TimerView(timeFormat: .hoursMinutesSeconds)
//            TimerView(timeFormat: .minutesSeconds)
//        }
//    }
//}
