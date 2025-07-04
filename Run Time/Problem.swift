import Foundation

// MARK: - Problem Model
/// Represents a coding challenge with multiple choice questions
struct Problem: Identifiable, Codable {
    let id: UUID
    let title: String
    let tags: [String] // Categories like "stack", "binary tree", "dynamic programming"
    let difficulty: String
    let description: String
    let solution: [String] // Array of solution lines
    let questions: [MultipleChoiceQuestion] // Questions for blanked out lines
    
    // MARK: - Multiple Choice Question Model
    struct MultipleChoiceQuestion: Codable, Identifiable {
        let id: UUID
        let lineIndex: Int // Which line in the solution this question replaces
        let question: String // The question prompt
        let options: [String] // 4 multiple choice options
        let correctAnswerIndex: Int // Index of correct answer (0-3)
        
        init(lineIndex: Int, question: String, options: [String], correctAnswerIndex: Int) {
            self.id = UUID()
            self.lineIndex = lineIndex
            self.question = question
            self.options = options
            self.correctAnswerIndex = correctAnswerIndex
        }
    }
    
    // MARK: - Initializer
    init(title: String, tags: [String], difficulty: String, description: String, solution: [String], questions: [MultipleChoiceQuestion]) {
        self.id = UUID()
        self.title = title
        self.tags = tags
        self.difficulty = difficulty
        self.description = description
        self.solution = solution
        self.questions = questions
    }
}

// MARK: - Sample Data
extension Problem {
    static let sampleProblems: [Problem] = [
        Problem(
            title: "Two Sum",
            tags: ["Array", "Hash Table", "Two Pointers"],
            difficulty: "Easy",
            description: "Given an array of integers and a target sum, return the indices of two numbers that add up to the target.",
            solution: [
                "def two_sum(nums, target):",
                "    num_map = {}",
                "    for i, num in enumerate(nums):",
                "        complement = target - num",
                "        if complement in num_map:",
                "            return [num_map[complement], i]",
                "        num_map[num] = i",
                "    return []"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 1,
                    question: "What data structure should we use to store numbers we've seen?",
                    options: ["list", "set", "dict", "tuple"],
                    correctAnswerIndex: 2
                ),
                MultipleChoiceQuestion(
                    lineIndex: 3,
                    question: "What value should we calculate to check if we've seen its pair?",
                    options: ["target + num", "target - num", "target * num", "target / num"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        
        Problem(
            title: "Valid Parentheses",
            tags: ["String", "Stack"],
            difficulty: "Easy",
            description: "Given a string containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.",
            solution: [
                "def is_valid(s):",
                "    stack = []",
                "    mapping = {')': '(', '}': '{', ']': '['}",
                "    for char in s:",
                "        if char in mapping:",
                "            if not stack or stack.pop() != mapping[char]:",
                "                return False",
                "        else:",
                "            stack.append(char)",
                "    return len(stack) == 0"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 1,
                    question: "What data structure is best for tracking opening brackets?",
                    options: ["queue", "stack", "set", "dict"],
                    correctAnswerIndex: 1
                ),
                MultipleChoiceQuestion(
                    lineIndex: 8,
                    question: "What should we return if the string is valid?",
                    options: ["True", "len(stack) == 0", "stack.empty()", "not stack"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        
        Problem(
            title: "Maximum Subarray",
            tags: ["Array", "Dynamic Programming", "Kadane's Algorithm"],
            difficulty: "Medium",
            description: "Given an integer array, find the contiguous subarray with the largest sum and return its sum.",
            solution: [
                "def max_subarray(nums):",
                "    max_sum = nums[0]",
                "    current_sum = nums[0]",
                "    for i in range(1, len(nums)):",
                "        current_sum = max(nums[i], current_sum + nums[i])",
                "        max_sum = max(max_sum, current_sum)",
                "    return max_sum"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 4,
                    question: "What should current_sum be at each step?",
                    options: ["nums[i]", "current_sum + nums[i]", "max(nums[i], current_sum + nums[i])", "min(nums[i], current_sum + nums[i])"],
                    correctAnswerIndex: 2
                ),
                MultipleChoiceQuestion(
                    lineIndex: 5,
                    question: "How do we update the maximum sum found so far?",
                    options: ["max_sum = current_sum", "max_sum = max(max_sum, current_sum)", "max_sum = min(max_sum, current_sum)", "max_sum += current_sum"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        
        Problem(
            title: "Binary Tree Inorder Traversal",
            tags: ["Binary Tree", "Stack", "Recursion", "Depth-First Search"],
            difficulty: "Medium",
            description: "Given the root of a binary tree, return the inorder traversal of its nodes' values.",
            solution: [
                "def inorder_traversal(root):",
                "    result = []",
                "    def inorder(node):",
                "        if node:",
                "            inorder(node.left)",
                "            result.append(node.val)",
                "            inorder(node.right)",
                "    inorder(root)",
                "    return result"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 4,
                    question: "In inorder traversal, when do we visit the left subtree?",
                    options: ["After visiting the node", "Before visiting the node", "After visiting the right subtree", "Never"],
                    correctAnswerIndex: 1
                ),
                MultipleChoiceQuestion(
                    lineIndex: 5,
                    question: "What do we do when we visit a node in inorder traversal?",
                    options: ["result.append(node)", "result.append(node.val)", "result.append(node.left)", "result.append(node.right)"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        
        Problem(
            title: "Reverse Linked List",
            tags: ["Linked List", "Recursion", "Iterative"],
            difficulty: "Easy",
            description: "Given the head of a singly linked list, reverse the list and return the reversed list.",
            solution: [
                "def reverse_list(head):",
                "    prev = None",
                "    current = head",
                "    while current:",
                "        next_temp = current.next",
                "        current.next = prev",
                "        prev = current",
                "        current = next_temp",
                "    return prev"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 5,
                    question: "What should current.next point to in order to reverse the link?",
                    options: ["current", "next_temp", "prev", "head"],
                    correctAnswerIndex: 2
                ),
                MultipleChoiceQuestion(
                    lineIndex: 8,
                    question: "What should we return as the new head of the reversed list?",
                    options: ["head", "current", "prev", "next_temp"],
                    correctAnswerIndex: 2
                )
            ]
        )
    ]
}