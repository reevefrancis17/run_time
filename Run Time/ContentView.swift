//
//  ContentView.swift
//  Run Time
//
//  Created by Reeve Francis on 7/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCategory: String? = nil
    @State private var expandedCategory: String? = nil
    @State private var showingProblem = false
    @State private var selectedProblem: Problem? = nil
    @State private var currentCategory: String? = nil // Track current category for "New Question"
    
    // New comprehensive categories list
    private let categories: [String] = [
        "Array", "String", "Hash Table", "Dynamic Programming", "Math", "Sorting", 
        "Greedy", "Depth-First Search", "Binary Search", "Database", "Matrix", "Tree", 
        "Bit Manipulation", "Breadth-First Search", "Two Pointers", "Prefix Sum", 
        "Heap (Priority Queue)", "Simulation", "Binary Tree", "Stack", "Graph", 
        "Counting", "Sliding Window", "Design", "Enumeration", "Backtracking", 
        "Union Find", "Linked List"
    ]
    
    var body: some View {
        NavigationStack {
            mainContent
            .navigationTitle("Topics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: refreshCategories) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingProblem) {
            print("🔵 [ContentView] fullScreenCover onDismiss called")
            selectedProblem = nil
            currentCategory = nil
        } content: {
            FullScreenContentView(
                selectedProblem: selectedProblem, 
                showingProblem: $showingProblem,
                onNewQuestion: handleNewQuestion,
                onNewCategory: handleNewCategory
            )
        }
        .onChange(of: showingProblem) { oldValue, newValue in
            print("🔄 [ContentView] showingProblem changed from \(oldValue) to \(newValue)")
        }
        .onChange(of: selectedProblem) { oldValue, newValue in
            print("🔄 [ContentView] selectedProblem changed from \(oldValue?.title ?? "nil") to \(newValue?.title ?? "nil")")
        }
        .onChange(of: expandedCategory) { oldValue, newValue in
            print("🔄 [ContentView] expandedCategory changed from \(oldValue ?? "nil") to \(newValue ?? "nil")")
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                ForEach(categories, id: \.self) { category in
                    categoryView(for: category)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func categoryView(for category: String) -> some View {
        VStack(spacing: 0) {
            // Main category button - restructured for full area responsiveness
            Button(action: {
                handleCategoryTap(category)
            }) {
                CategoryRowView(category: category, isExpanded: expandedCategory == category)
                    .frame(maxWidth: .infinity) // Ensure full width
                    .contentShape(Rectangle()) // Make entire area tappable
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onLongPressGesture(minimumDuration: 0.5) {
                handleLongPress(category)
            }
            
            // Expanded problems list
            if expandedCategory == category {
                expandedProblemsView(for: category)
            }
        }
    }
    
    @ViewBuilder
    private func expandedProblemsView(for category: String) -> some View {
        let problemsForCategory = getProblems(for: category)
        
        VStack(spacing: 2) {
            ForEach(problemsForCategory, id: \.id) { problem in
                Button(action: {
                    handleProblemTap(problem)
                }) {
                    ProblemRowView(problem: problem)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .onAppear {
            print("🟢 [ContentView] Rendering expanded problems for category: \(category)")
            print("🟢 [ContentView] Number of problems to show: \(problemsForCategory.count)")
        }
    }
    
    // MARK: - New Action Handlers
    
    /// Handles "New Question" button - picks a new question from the same category
    private func handleNewQuestion() {
        guard let category = currentCategory else {
            print("🔴 [ContentView] ERROR: No current category for new question")
            return
        }
        
        print("🟢 [ContentView] New Question requested for category: \(category)")
        
        // Try to get a different problem from the same category
        let problemsInCategory = Problem.sampleProblems.filter { $0.tags.contains(category) }
        let differentProblems = problemsInCategory.filter { $0.id != selectedProblem?.id }
        
        if let newProblem = differentProblems.randomElement() {
            // Found a different problem in the same category
            selectedProblem = newProblem
            print("🟢 [ContentView] New problem selected from same category: \(newProblem.title)")
        } else {
            // No different problems in this category, fall back to any random problem
            print("🟡 [ContentView] No other problems in category \(category), falling back to random problem")
            let allOtherProblems = Problem.sampleProblems.filter { $0.id != selectedProblem?.id }
            
            if let randomProblem = allOtherProblems.randomElement() {
                selectedProblem = randomProblem
                // Update current category to the new problem's first tag
                currentCategory = randomProblem.tags.first
                print("🟢 [ContentView] Random fallback problem selected: \(randomProblem.title)")
            } else {
                print("🔴 [ContentView] ERROR: No other problems available at all")
            }
        }
    }
    
    /// Handles "New Category" button - picks a random question from a random other category
    private func handleNewCategory() {
        print("🟢 [ContentView] New Category requested")
        
        // Try to get a random category different from the current one
        let availableCategories = categories.filter { $0 != currentCategory }
        var attempts = 0
        let maxAttempts = 10 // Prevent infinite loops
        
        while attempts < maxAttempts {
            if let randomCategory = availableCategories.randomElement() {
                print("🟢 [ContentView] Trying category: \(randomCategory)")
                
                if let newProblem = getRandomProblem(for: randomCategory) {
                    selectedProblem = newProblem
                    currentCategory = randomCategory
                    print("🟢 [ContentView] New problem selected from category \(randomCategory): \(newProblem.title)")
                    return
                }
            }
            attempts += 1
        }
        
        // If we get here, we couldn't find a problem in a different category
        // Fall back to any random problem different from the current one
        print("🟡 [ContentView] Could not find problem in different category, falling back to any random problem")
        let allOtherProblems = Problem.sampleProblems.filter { $0.id != selectedProblem?.id }
        
        if let randomProblem = allOtherProblems.randomElement() {
            selectedProblem = randomProblem
            currentCategory = randomProblem.tags.first
            print("🟢 [ContentView] Random fallback problem selected: \(randomProblem.title)")
        } else {
            print("🔴 [ContentView] ERROR: No other problems available at all")
        }
    }
    
    // MARK: - Action Handlers
    
    private func handleCategoryTap(_ category: String) {
        print("🔵 [ContentView] Main category button tapped: \(category)")
        print("🔵 [ContentView] Current expandedCategory: \(expandedCategory ?? "nil")")
        print("🔵 [ContentView] Current showingProblem: \(showingProblem)")
        print("🔵 [ContentView] Current selectedProblem: \(selectedProblem?.title ?? "nil")")
        
        // Add safety check and detailed logging
        let problemsInCategory = Problem.sampleProblems.filter { $0.tags.contains(category) }
        print("🔵 [ContentView] Problems found for category \(category): \(problemsInCategory.count)")
        
        if let randomProblem = getRandomProblem(for: category) {
            print("🔵 [ContentView] Random problem selected: \(randomProblem.title)")
            print("🔵 [ContentView] About to set selectedProblem and showingProblem")
            
            // Set the current category for potential "New Question" requests
            currentCategory = category
            
            // Use a small delay to ensure state is properly set
            DispatchQueue.main.async {
                selectedProblem = randomProblem
                
                // Add a tiny delay to ensure the state is set before showing modal
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showingProblem = true
                }
            }
            
            print("🔵 [ContentView] After setting - selectedProblem: \(selectedProblem?.title ?? "nil")")
            print("🔵 [ContentView] After setting - showingProblem: \(showingProblem)")
        } else {
            print("🔴 [ContentView] ERROR: No random problem found for category: \(category)")
            print("🔴 [ContentView] Available problems: \(problemsInCategory.map { $0.title })")
        }
    }
    
    private func handleLongPress(_ category: String) {
        print("🟡 [ContentView] Long press gesture on category: \(category)")
        print("🟡 [ContentView] Current expandedCategory before: \(expandedCategory ?? "nil")")
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if expandedCategory == category {
                print("🟡 [ContentView] Collapsing category: \(category)")
                expandedCategory = nil
            } else {
                print("🟡 [ContentView] Expanding category: \(category)")
                expandedCategory = category
            }
        }
        
        print("🟡 [ContentView] Current expandedCategory after: \(expandedCategory ?? "nil")")
    }
    
    private func handleProblemTap(_ problem: Problem) {
        print("🟢 [ContentView] Specific problem button tapped: \(problem.title)")
        print("🟢 [ContentView] Current expandedCategory: \(expandedCategory ?? "nil")")
        print("🟢 [ContentView] Current showingProblem: \(showingProblem)")
        print("🟢 [ContentView] About to set selectedProblem and showingProblem")
        
        // Use a small delay to ensure state is properly set
        DispatchQueue.main.async {
            selectedProblem = problem
            
            // Add a tiny delay to ensure the state is set before showing modal
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showingProblem = true
            }
        }
        
        print("🟢 [ContentView] After setting - selectedProblem: \(selectedProblem?.title ?? "nil")")
        print("🟢 [ContentView] After setting - showingProblem: \(showingProblem)")
    }
    
    // MARK: - Helper Methods
    
    private func getRandomProblem(for category: String) -> Problem? {
        print("🔍 [ContentView] getRandomProblem called for category: \(category)")
        let problemsInCategory = Problem.sampleProblems.filter { $0.tags.contains(category) }
        print("🔍 [ContentView] Found \(problemsInCategory.count) problems for category \(category)")
        
        if problemsInCategory.isEmpty {
            print("🔴 [ContentView] No problems found for category: \(category)")
            print("🔴 [ContentView] Available categories in all problems: \(Set(Problem.sampleProblems.flatMap { $0.tags }).sorted())")
            return nil
        }
        
        let randomProblem = problemsInCategory.randomElement()
        print("🔍 [ContentView] Selected random problem: \(randomProblem?.title ?? "nil")")
        return randomProblem
    }
    
    private func getProblems(for category: String) -> [Problem] {
        print("🔍 [ContentView] getProblems called for category: \(category)")
        let problems = Problem.sampleProblems.filter { $0.tags.contains(category) }
        print("🔍 [ContentView] Found \(problems.count) problems for category \(category)")
        return problems
    }
    
    private func refreshCategories() {
        print("🔄 [ContentView] refreshCategories called")
        print("Refresh categories tapped")
    }
}

struct FullScreenContentView: View {
    let selectedProblem: Problem?
    @Binding var showingProblem: Bool
    var onNewQuestion: () -> Void
    var onNewCategory: () -> Void
    
    var body: some View {
        Group {
            if let problem = selectedProblem {
                NavigationView {
                    ProblemDetailView(
                        problem: problem,
                        onNewQuestion: onNewQuestion,
                        onNewCategory: onNewCategory
                    )
                    .id(problem.id) // Force SwiftUI to create a new view instance when problem changes
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Done") {
                                    print("🔵 [ContentView] Done button tapped")
                                    print("🔵 [ContentView] Before dismissing - showingProblem: \(showingProblem)")
                                    print("🔵 [ContentView] Before dismissing - selectedProblem: \(selectedProblem?.title ?? "nil")")
                                    
                                    showingProblem = false
                                    
                                    print("🔵 [ContentView] After dismissing - showingProblem: \(showingProblem)")
                                }
                            }
                        }
                }
                .onAppear {
                    print("🔵 [ContentView] fullScreenCover content building")
                    print("🔵 [ContentView] selectedProblem in fullScreenCover: \(selectedProblem?.title ?? "nil")")
                    print("🔵 [ContentView] Creating NavigationView with problem: \(problem.title)")
                }
            } else {
                VStack {
                    Text("Error: No problem selected")
                        .foregroundColor(.red)
                        .padding()
                    
                    Button("Dismiss") {
                        showingProblem = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .onAppear {
                    print("🔴 [ContentView] ERROR: selectedProblem is nil in fullScreenCover content!")
                }
            }
        }
    }
}

struct CategoryRowView: View {
    let category: String
    let isExpanded: Bool
    
    // Get problems count and difficulty distribution for this category
    private var categoryStats: (count: Int, difficulties: [String]) {
        let problemsInCategory = Problem.sampleProblems.filter { $0.tags.contains(category) }
        let difficulties = problemsInCategory.map { $0.difficulty }
        return (problemsInCategory.count, Array(Set(difficulties)).sorted())
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack {
                    // Problem count
                    HStack(spacing: 2) {
                        Image(systemName: "doc.text")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(categoryStats.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Difficulty levels available
                    if !categoryStats.difficulties.isEmpty {
                        HStack(spacing: 3) {
                            ForEach(categoryStats.difficulties, id: \.self) { difficulty in
                                Circle()
                                    .fill(difficultyColor(for: difficulty))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Expand indicator
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Random problem indicator
            Image(systemName: "shuffle")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // Ensure all areas including Spacers are tappable
    }
    
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty.lowercased() {
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
}

struct ProblemRowView: View {
    let problem: Problem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(problem.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack {
                    Text(problem.difficulty)
                        .font(.caption2)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(difficultyColor(for: problem.difficulty).opacity(0.2))
                        .foregroundColor(difficultyColor(for: problem.difficulty))
                        .cornerRadius(3)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.systemBackground))
        .cornerRadius(4)
    }
    
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty.lowercased() {
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
}

#Preview {
    ContentView()
}

