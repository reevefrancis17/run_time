import SwiftUI

// MARK: - Content View
/// Main home screen displaying a list of coding challenges
struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(Problem.sampleProblems) { problem in
                NavigationLink(destination: ProblemDetailView(problem: problem)) {
                    ProblemRowView(problem: problem)
                }
            }
            .navigationTitle("Run Time Challenges")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addNewProblem) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    /// Placeholder action for adding new problems
    private func addNewProblem() {
        print("Add new problem tapped")
    }
}

// MARK: - Problem Row View
/// Individual row view for displaying problem information
struct ProblemRowView: View {
    let problem: Problem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Problem title
            Text(problem.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Difficulty and time limit
            HStack {
                // Difficulty badge
                Text(problem.difficulty)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(difficultyColor.opacity(0.2))
                    .foregroundColor(difficultyColor)
                    .cornerRadius(8)
                
                Spacer()
                
                // Time limit
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .foregroundColor(.secondary)
                    Text(formatTimeLimit(problem.timeLimit))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Computed Properties
    /// Returns color based on difficulty level
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
    
    // MARK: - Helper Methods
    /// Formats time limit from seconds to readable format
    private func formatTimeLimit(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        if remainingSeconds == 0 {
            return "\(minutes) min"
        } else {
            return "\(minutes):\(String(format: "%02d", remainingSeconds))"
        }
    }
}


// MARK: - Preview
#Preview {
    ContentView()
}