import SwiftUI

// MARK: - Problem Detail View
/// Detail screen for multiple choice coding challenges
struct ProblemDetailView: View {
    let problem: Problem
    var onNewQuestion: (() -> Void)?
    var onNewCategory: (() -> Void)?
    
    // MARK: - State Properties
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int?] = []
    @State private var answeredQuestions: [Bool] = []
    @State private var showingResults = false
    @State private var score = 0
    @State private var selectedOption: Int? = nil
    @State private var flashColor: Color? = nil
    @State private var isFlashing = false
    @State private var elapsedTime = 0 // Timer now counts up from 0
    @State private var timer: Timer?
    
    // MARK: - Initializer
    init(problem: Problem, onNewQuestion: (() -> Void)? = nil, onNewCategory: (() -> Void)? = nil) {
        self.problem = problem
        self.onNewQuestion = onNewQuestion
        self.onNewCategory = onNewCategory
        self._selectedAnswers = State(initialValue: Array(repeating: nil, count: problem.questions.count))
        self._answeredQuestions = State(initialValue: Array(repeating: false, count: problem.questions.count))
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
                }
            }
            .padding()
        }
        .navigationTitle(problem.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            startTimer() // Start timer immediately when problem opens
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - View Components
    
    /// Header with difficulty and progress
    private var headerSection: some View {
        VStack(spacing: 12) {
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
                
                // Timer (counting up)
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .foregroundColor(.blue)
                    Text(formatTime(elapsedTime))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .monospacedDigit()
                }
            }
            
            HStack {
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
            
            VStack(alignment: .leading, spacing: 1) {
                ForEach(Array(problem.solution.enumerated()), id: \.offset) { index, line in
                    HStack(spacing: 8) {
                        // Line numbers far left
                        Text("\(index + 1)")
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(.secondary)
                            .frame(width: 15, alignment: .trailing)
                        
                        // Show different content based on question state
                        if shouldHideLineText(for: index) {
                            // Hide text for unanswered questions - show placeholder
                            Text("// Your answer will appear here")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            // Show actual code for answered questions or non-question lines
                            syntaxHighlightedText(line)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(getLineBackgroundColor(for: index))
                    .cornerRadius(3)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
    
    /// Current question section
    private var questionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Question \(currentQuestionIndex + 1)")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(currentQuestion.question)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(spacing: 8) {
                ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                    OptionButton(
                        option: option,
                        isSelected: selectedOption == index,
                        isFlashing: isFlashing && selectedOption == index,
                        flashColor: flashColor,
                        onTap: {
                            handleOptionTap(index)
                        }
                    )
                }
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
                VStack(alignment: .leading) {
                    Text("Score: \(score)/\(problem.questions.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Time: \(formatTime(elapsedTime))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
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
            
            // New buttons row
            HStack(spacing: 12) {
                // New Question button
                Button("New Question") {
                    print("🟢 [ProblemDetailView] New Question button tapped")
                    onNewQuestion?()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                // New Category button
                Button("New Category") {
                    print("🟢 [ProblemDetailView] New Category button tapped")
                    onNewCategory?()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Helper Views
    
    /// Syntax highlighted text for Python code
    private func syntaxHighlightedText(_ line: String) -> some View {
        Text.pythonCode(line.replacingOccurrences(of: "    ", with: "  "))
    }
    
    // MARK: - Helper Methods
    
    /// Handles option tap with yellow-flash-advance behavior
    private func handleOptionTap(_ index: Int) {
        if selectedOption == index && !isFlashing {
            // Second tap - flash and advance
            isFlashing = true
            let isCorrect = index == currentQuestion.correctAnswerIndex
            flashColor = isCorrect ? .green : .red
            selectedAnswers[currentQuestionIndex] = index
            answeredQuestions[currentQuestionIndex] = true
            
            // Flash animation
            withAnimation(.easeInOut(duration: 0.15)) {
                // Flash effect handled by OptionButton
            }
            
            // Advance to next question or results
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFlashing = false
                flashColor = nil
                selectedOption = nil
                
                if currentQuestionIndex < problem.questions.count - 1 {
                    currentQuestionIndex += 1
                    selectedOption = nil // Reset for next question
                } else {
                    calculateScore()
                    showingResults = true
                    stopTimer()
                }
            }
        } else if !isFlashing {
            // First tap - select (yellow)
            selectedOption = index
        }
    }
    
    /// Starts the timer to count up from 0
    private func startTimer() {
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    /// Stops the timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Formats time in MM:SS format
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    /// Checks if a question for a specific line has been answered
    private func isQuestionAnswered(for lineIndex: Int) -> Bool {
        if let questionIndex = problem.questions.firstIndex(where: { $0.lineIndex == lineIndex }) {
            return answeredQuestions[questionIndex]
        }
        return false
    }
    
    /// Gets background color for a code line based on answer correctness and current question
    private func getLineBackgroundColor(for lineIndex: Int) -> Color {
        // Check if this line corresponds to the current question (highlight in yellow)
        if !showingResults && currentQuestion.lineIndex == lineIndex && !answeredQuestions[currentQuestionIndex] {
            return Color.yellow.opacity(0.3)
        }
        
        // Check if this line has been answered (show green/red based on correctness)
        if let questionIndex = problem.questions.firstIndex(where: { $0.lineIndex == lineIndex }),
           answeredQuestions[questionIndex],
           let selectedAnswer = selectedAnswers[questionIndex] {
            let isCorrect = selectedAnswer == problem.questions[questionIndex].correctAnswerIndex
            return isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2)
        }
        
        return Color.clear
    }
    
    /// Determines if the text for a given line should be hidden
    private func shouldHideLineText(for lineIndex: Int) -> Bool {
        // Hide text for lines that correspond to unanswered questions
        if let questionIndex = problem.questions.firstIndex(where: { $0.lineIndex == lineIndex }) {
            return !answeredQuestions[questionIndex]
        }
        return false
    }
    
    /// Current question being displayed
    private var currentQuestion: Problem.MultipleChoiceQuestion {
        problem.questions[currentQuestionIndex]
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
        answeredQuestions = Array(repeating: false, count: problem.questions.count)
        showingResults = false
        score = 0
        selectedOption = nil
        flashColor = nil
        isFlashing = false
        elapsedTime = 0
        startTimer()
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
    
    /// Score percentage as a string
    private var scorePercentage: String {
        let percentage = Double(score) / Double(problem.questions.count) * 100
        return String(format: "%.0f%%", percentage)
    }
    
    /// Color based on score performance
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
}

// MARK: - Option Button Component
struct OptionButton: View {
    let option: String
    let isSelected: Bool
    let isFlashing: Bool
    let flashColor: Color?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(option)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(backgroundColor)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
                    )
                    .scaleEffect(isFlashing ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.15), value: isFlashing)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if isFlashing, let flashColor = flashColor {
            return flashColor.opacity(0.3)
        } else if isSelected {
            return Color.yellow.opacity(0.3)
        } else {
            return Color(.systemGray6)
        }
    }
    
    private var borderColor: Color {
        if isFlashing, let flashColor = flashColor {
            return flashColor
        } else if isSelected {
            return .yellow
        } else {
            return Color(.systemGray4)
        }
    }
}

#Preview {
    NavigationView {
        ProblemDetailView(problem: Problem.sampleProblems[0])
    }
}