import Foundation

// MARK: - Problem Model
/// Represents a coding challenge with time-based constraints
struct Problem: Identifiable, Codable {
    let id: UUID
    let title: String
    let difficulty: String
    let timeLimit: Int // Time limit in seconds
    let description: String
    let testCases: [TestCase]
    
    // MARK: - Test Case Model
    struct TestCase: Codable {
        let input: String
        let expectedOutput: String
    }
    
    // MARK: - Initializer
    init(title: String, difficulty: String, timeLimit: Int, description: String, testCases: [TestCase]) {
        self.id = UUID()
        self.title = title
        self.difficulty = difficulty
        self.timeLimit = max(60, timeLimit) // Minimum 1 minute
        self.description = description
        self.testCases = testCases.isEmpty ? [TestCase(input: "", expectedOutput: "")] : testCases
    }
}

// MARK: - Sample Data
extension Problem {
    static let sampleProblems: [Problem] = [
        Problem(
            title: "Reverse a String",
            difficulty: "Easy",
            timeLimit: 300, // 5 minutes
            description: "Write a function that takes a string as input and returns the string reversed. For example, 'hello' should return 'olleh'.",
            testCases: [
                TestCase(input: "hello", expectedOutput: "olleh"),
                TestCase(input: "world", expectedOutput: "dlrow"),
                TestCase(input: "a", expectedOutput: "a")
            ]
        ),
        
        Problem(
            title: "Two Sum",
            difficulty: "Easy",
            timeLimit: 450, // 7.5 minutes
            description: "Given an array of integers and a target sum, return the indices of two numbers that add up to the target. You may assume that each input would have exactly one solution.",
            testCases: [
                TestCase(input: "[2, 7, 11, 15], target: 9", expectedOutput: "[0, 1]"),
                TestCase(input: "[3, 2, 4], target: 6", expectedOutput: "[1, 2]"),
                TestCase(input: "[3, 3], target: 6", expectedOutput: "[0, 1]")
            ]
        ),
        
        Problem(
            title: "Valid Parentheses",
            difficulty: "Medium",
            timeLimit: 480, // 8 minutes
            description: "Given a string containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid. An input string is valid if: Open brackets must be closed by the same type of brackets and in the correct order.",
            testCases: [
                TestCase(input: "()", expectedOutput: "true"),
                TestCase(input: "()[]{}", expectedOutput: "true"),
                TestCase(input: "(]", expectedOutput: "false")
            ]
        ),
        
        Problem(
            title: "Maximum Subarray",
            difficulty: "Medium",
            timeLimit: 600, // 10 minutes
            description: "Given an integer array, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.",
            testCases: [
                TestCase(input: "[-2,1,-3,4,-1,2,1,-5,4]", expectedOutput: "6"),
                TestCase(input: "[1]", expectedOutput: "1"),
                TestCase(input: "[5,4,-1,7,8]", expectedOutput: "23")
            ]
        ),
        
        Problem(
            title: "Binary Tree Inorder Traversal",
            difficulty: "Hard",
            timeLimit: 720, // 12 minutes
            description: "Given the root of a binary tree, return the inorder traversal of its nodes' values. The inorder traversal visits nodes in the order: left subtree, root, right subtree.",
            testCases: [
                TestCase(input: "[1,null,2,3]", expectedOutput: "[1,3,2]"),
                TestCase(input: "[]", expectedOutput: "[]"),
                TestCase(input: "[1]", expectedOutput: "[1]")
            ]
        )
    ]
}