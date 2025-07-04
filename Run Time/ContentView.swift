//
//  ContentView.swift
//  Run Time
//
//  Created by Reeve Francis on 7/4/25.
//

import SwiftUI

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
    
    private func addNewProblem() {
        print("Add new problem tapped")
    }
}

struct ProblemRowView: View {
    let problem: Problem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(problem.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(problem.difficulty)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(difficultyColor)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.secondary)
                        Text("\(problem.questions.count) questions")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(problem.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
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
}

#Preview {
    ContentView()
}
