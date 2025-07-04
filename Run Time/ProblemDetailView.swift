import SwiftUI

// MARK: - Problem Detail View
/// Detail screen for multiple choice coding challenges
struct ProblemDetailView: View {
    let problem: Problem
    
    // MARK: - State Properties
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int?] = []
    @State private var showingResults = false
    @State private var score = 0
    
    // MARK: - Initializer
    init(problem: Problem) {
        self.problem = problem
        self._selectedAnswers = State(initialValue: Array(repeating: nil, count: problem.questions.count))
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if showingResults {
                    resultsSection
                } else {
                    // Header Section
                    headerSection
                    
                    // Problem Description
                    problemDescriptionSection
                    
                    // Code Solution with Blanks
                    solutionSection
                    
                    // Current Question
                    questionSection
                    
                    // Navigation Buttons
                    navigationButtonsSection
                }
            }
            .padding()
        }
        .navigationTitle(problem.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - View Components
    
    /// Header with difficulty and progress
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
            
            // Tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(problem.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                    }
                }
            }
            
            Spacer()
            
            // Progress
            Text("\(currentQuestionIndex + 1)/\(problem.questions.count)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
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
    
    /// Code solution with blanks
    private var solutionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Solution")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(problem.solution.enumerated()), id: \.offset) { index, line in
                    HStack {
                        Text("\(index + 1)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                            .frame(width: 20, alignment: .trailing)
                        
                        if isBlankLine(index) {
                            Text("    _______________")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        } else {
                            Text(line)
                                .font(.system(.body, design: .monospaced))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 2)
                    .background(isBlankLine(index) ? Color.red.opacity(0.1) : Color.clear)
                    .cornerRadius(4)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
    
    /// Current question section
    private var questionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Question \(currentQuestionIndex + 1)")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(currentQuestion.question)
                .font(.body)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(spacing: 12) {
                ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                    Button(action: {
                        selectedAnswers[currentQuestionIndex] = index
                    }) {
                        HStack {
                            Text(option)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            if selectedAnswers[currentQuestionIndex] == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(selectedAnswers[currentQuestionIndex] == index ? Color.blue.opacity(0.1) : Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedAnswers[currentQuestionIndex] == index ? Color.blue : Color.clear, lineWidth: 2)
                        )
                    }
                }
            }
        }
    }
    
    /// Navigation buttons section
    private var navigationButtonsSection: some View {
        HStack {
            if currentQuestionIndex > 0 {
                Button("Previous") {
                    currentQuestionIndex -= 1
                }
                .foregroundColor(.blue)
            }
            
            Spacer()
            
            if currentQuestionIndex < problem.questions.count - 1 {
                Button("Next") {
                    currentQuestionIndex += 1
                }
                .foregroundColor(.blue)
                .disabled(selectedAnswers[currentQuestionIndex] == nil)
            } else {
                Button("Submit") {
                    calculateScore()
                    showingResults = true
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(allQuestionsAnswered ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!allQuestionsAnswered)
            }
        }
    }
    
    /// Results section
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Results")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack {
                Text("Score: \(score)/\(problem.questions.count)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(scorePercentage)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(scoreColor)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            ForEach(Array(problem.questions.enumerated()), id: \.offset) { index, question in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Question \(index + 1)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(question.question)
                        .font(.body)
                    
                    let userAnswer = selectedAnswers[index] ?? -1
                    let isCorrect = userAnswer == question.correctAnswerIndex
                    
                    HStack {
                        Text("Your answer:")
                            .fontWeight(.medium)
                        Text(userAnswer >= 0 ? question.options[userAnswer] : "Not answered")
                            .foregroundColor(isCorrect ? .green : .red)
                            .fontWeight(.semibold)
                        
                        if isCorrect {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                    if !isCorrect {
                        HStack {
                            Text("Correct answer:")
                                .fontWeight(.medium)
                            Text(question.options[question.correctAnswerIndex])
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            Button("Try Again") {
                resetQuiz()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
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
    
    /// Current question being displayed
    private var currentQuestion: Problem.MultipleChoiceQuestion {
        problem.questions[currentQuestionIndex]
    }
    
    /// Whether all questions have been answered
    private var allQuestionsAnswered: Bool {
        !selectedAnswers.contains(nil)
    }
    
    /// Score percentage as a string
    private var scorePercentage: String {
        let percentage = Double(score) / Double(problem.questions.count) * 100
        return String(format: "%.0f%%", percentage)
    }
    
    /// Color for score display
    private var scoreColor: Color {
        let percentage = Double(score) / Double(problem.questions.count)
        if percentage >= 0.8 {
            return .green
        } else if percentage >= 0.6 {
            return .orange
        } else {
            return .red
        }
    }
    
    // MARK: - Helper Methods
    
    /// Checks if a line should be blanked out (has a question)
    private func isBlankLine(_ lineIndex: Int) -> Bool {
        return problem.questions.contains { $0.lineIndex == lineIndex }
    }
    
    /// Calculates the final score
    private func calculateScore() {
        score = 0
        for (index, question) in problem.questions.enumerated() {
            if let selectedAnswer = selectedAnswers[index],
               selectedAnswer == question.correctAnswerIndex {
                score += 1
            }
        }
    }
    
    /// Resets the quiz to start over
    private func resetQuiz() {
        currentQuestionIndex = 0
        selectedAnswers = Array(repeating: nil, count: problem.questions.count)
        showingResults = false
        score = 0
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ProblemDetailView(problem: Problem.sampleProblems[0])
    }
}