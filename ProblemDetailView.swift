import SwiftUI

// MARK: - Problem Detail View
/// Detail screen for coding challenges with timer, code editor, and submission
struct ProblemDetailView: View {
    let problem: Problem
    
    // MARK: - State Properties
    @State private var timeRemaining: Int
    @State private var userCode = ""
    @State private var output = ""
    @State private var isSubmitting = false
    @State private var timer: Timer?
    
    // MARK: - Initializer
    init(problem: Problem) {
        self.problem = problem
        self._timeRemaining = State(initialValue: problem.timeLimit)
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                headerSection
                
                // Problem Description
                problemDescriptionSection
                
                // Code Editor
                codeEditorSection
                
                // Submit Button
                submitButtonSection
                
                // Output Section
                if !output.isEmpty {
                    outputSection
                }
            }
            .padding()
        }
        .navigationTitle(problem.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - View Components
    
    /// Header with difficulty and timer
    private var headerSection: some View {
        HStack {
            // Difficulty Badge
            Text(problem.difficulty)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(difficultyColor.opacity(0.2))
                .foregroundColor(difficultyColor)
                .cornerRadius(12)
            
            Spacer()
            
            // Timer
            HStack(spacing: 4) {
                Image(systemName: "timer")
                    .foregroundColor(timerColor)
                Text(formatTime(timeRemaining))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(timerColor)
            }
        }
    }
    
    /// Problem description section
    private var problemDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Problem Description")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(problem.description)
                .font(.body)
                .lineLimit(nil)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    /// Code editor section
    private var codeEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Solution")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextEditor(text: $userCode)
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .frame(minHeight: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .overlay(
                    // Placeholder text
                    VStack {
                        HStack {
                            Text(userCode.isEmpty ? "Enter your code here..." : "")
                                .foregroundColor(.secondary)
                                .font(.system(.body, design: .monospaced))
                                .padding(.leading, 12)
                                .padding(.top, 16)
                            Spacer()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                )
        }
    }
    
    /// Submit button section
    private var submitButtonSection: some View {
        Button(action: submitCode) {
            HStack {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text(isSubmitting ? "Running..." : "Submit Code")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(submitButtonColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(isSubmitDisabled)
    }
    
    /// Output section
    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Output")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(output)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    // MARK: - Computed Properties
    
    /// Color based on difficulty level
    private var difficultyColor: Color {
        switch problem.difficulty.lowercased() {
        case "easy":
            return .green
        case "medium":
            return .orange
        case "hard":
            return .red
        default:
            return .gray
        }
    }
    
    /// Timer color based on remaining time
    private var timerColor: Color {
        if timeRemaining <= 60 {
            return .red
        } else if timeRemaining <= 120 {
            return .orange
        } else {
            return .primary
        }
    }
    
    /// Submit button color and state
    private var submitButtonColor: Color {
        isSubmitDisabled ? .gray : .blue
    }
    
    /// Whether submit button should be disabled
    private var isSubmitDisabled: Bool {
        timeRemaining <= 0 || isSubmitting || userCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Helper Methods
    
    /// Formats time in MM:SS format
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    /// Starts the countdown timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    /// Stops the countdown timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Submits user code for evaluation (mock implementation)
    private func submitCode() {
        guard !isSubmitting && timeRemaining > 0 else { return }
        
        isSubmitting = true
        output = "Running code..."
        
        // Mock evaluation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isSubmitting = false
            
            // Mock output based on code content
            if userCode.lowercased().contains("hello") {
                output = "✅ Correct!\n\nAll test cases passed:\n• Test 1: ✅ Passed\n• Test 2: ✅ Passed\n• Test 3: ✅ Passed"
            } else {
                output = "❌ Incorrect\n\nTest results:\n• Test 1: ❌ Failed - Expected 'olleh', got 'hello'\n• Test 2: ✅ Passed\n• Test 3: ❌ Failed - Time limit exceeded"
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ProblemDetailView(problem: Problem.sampleProblems[0])
    }
}