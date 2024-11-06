////
////  TestView.swift
////  Croak
////
////  Created by jeong hyein on 5/14/24.
////
//
//import SwiftUI
//
//struct ViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> ViewController {
//        return ViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//        // Update the UIViewController if needed
//    }
//}
//
//struct TestView: View {
//    // Key Point 1: State Variables
//    @State private var startTime: Date?
//    @State private var elapsedTimeWhenPaused: TimeInterval = 0
//    @State private var isTimerRunning = false
//    @State private var currentTime: TimeInterval = 0
//    @State private var timer: Timer?
//
//    // Computes the time formatted as a string (HH:MM:SS) to display in the UI
//    var timeFormatted: String {
//        let totalSeconds = Int(currentTime)
//        let hours = totalSeconds / 3600
//        let minutes = (totalSeconds % 3600) / 60
//        let seconds = totalSeconds % 60
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//
//    // The body property defines the view's user interface
//    var body: some View {
//        VStack {
//            // Displays the formatted time
//            Text(timeFormatted)
//                .font(.largeTitle)
//                .padding()
//
//            // Horizontal stack for Play/Pause and Reset buttons
//            HStack {
//                // Button to toggle the timer's state
//                Button(action: toggleTimer) {
//                    Text(isTimerRunning ? "Pause" : "Play")
//                }
//                .padding()
//                // Button to reset the timer
//                Button(action: resetTimer) {
//                    Text("Reset")
//                }
//                .padding()
//            }
//            ViewControllerRepresentable()
//                           .frame(height: 0) // Adjust the frame as needed
//                           .hidden() // Hide the UIViewController if not needed to be visible
//        }
//    }
//
//    // Key Point 2: Toggle Function
//    func toggleTimer() {
//        if isTimerRunning {
//            // Stops the timer and saves the elapsed time
//            timer?.invalidate()
//            elapsedTimeWhenPaused = currentTime
//            startTime = nil
//        } else {
//            // Starts the timer, accounting for any previously elapsed time
//            startTime = Date().addingTimeInterval(-elapsedTimeWhenPaused)
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                if let startTime = self.startTime {
//                    self.currentTime = Date().timeIntervalSince(startTime)
//                }
//            }
//        }
//        isTimerRunning.toggle() // Toggle the running state of the timer
//    }
//
//    // Function to reset the timer to its initial state.
//    func resetTimer() {
//        timer?.invalidate() // Stops the timer.
//        startTime = nil // Clears the start time.
//        elapsedTimeWhenPaused = 0 // Resets the elapsed time.
//        currentTime = 0 // Resets the current time.
//        isTimerRunning = false // Marks the timer as not running.
//    }
//}
