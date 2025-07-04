import Foundation

// MARK: - Problem Model
/// Represents a coding challenge with multiple-choice questions
struct Problem: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let tags: [String] // Categories like "Array", "String", "Hash Table", etc.
    let difficulty: String
    let description: String
    let solution: [String] // Array of solution lines
    let questions: [MultipleChoiceQuestion] // Questions for blanked out lines
    
    // MARK: - Equatable implementation
    static func == (lhs: Problem, rhs: Problem) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Multiple Choice Question Model
    struct MultipleChoiceQuestion: Codable, Identifiable, Equatable {
        let id: UUID
        let lineIndex: Int // Which line in the solution this question replaces
        let question: String // The question prompt
        let options: [String] // 4 multiple-choice options
        let correctAnswerIndex: Int // Index of correct answer (0-3)
        
        init(lineIndex: Int, question: String, options: [String], correctAnswerIndex: Int) {
            self.id = UUID()
            self.lineIndex = lineIndex
            self.question = question
            self.options = options
            self.correctAnswerIndex = correctAnswerIndex
        }
        
        // MARK: - Equatable implementation
        static func == (lhs: MultipleChoiceQuestion, rhs: MultipleChoiceQuestion) -> Bool {
            return lhs.id == rhs.id
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
        // MARK: - Two Sum
        Problem(
            title: "Two Sum",
            tags: ["Array", "Hash Table"],
            difficulty: "Easy",
            description: """
                Given an array of integers `nums` and an integer `target`, return the indices of two numbers such that they add up to `target`. 
                You may assume that each input has exactly one solution, and you may not use the same element twice.
                Example: Input: nums = [2, 7, 11, 15], target = 9, Output: [0, 1]
                """,
            solution: [
                "def two_sum(nums, target):",
                "    # Initialize a dictionary to store number-index pairs",
                "    num_map = {}",
                "    # Iterate through the array with index",
                "    for i, num in enumerate(nums):",
                "        # Calculate the complement needed to reach target",
                "        complement = target - num",
                "        # Check if complement exists in dictionary",
                "        if complement in num_map:",
                "            # Return indices of complement and current number",
                "            return [num_map[complement], i]",
                "        # Store current number and its index",
                "        num_map[num] = i",
                "    # Return empty list if no solution is found",
                "    return []"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 2,
                    question: "Which data structure is used to store numbers and their indices for O(1) lookup?",
                    options: [
                        "    num_list = []",
                        "    num_set = set()",
                        "    num_map = {}",
                        "    num_array = []"
                    ],
                    correctAnswerIndex: 2
                ),
                MultipleChoiceQuestion(
                    lineIndex: 6,
                    question: "How do we calculate the number needed to reach the target?",
                    options: [
                        "        complement = target + num",
                        "        complement = target - num",
                        "        complement = target * num",
                        "        complement = num - target"
                    ],
                    correctAnswerIndex: 1
                )
            ]
        ),
        
        // MARK: - Valid Parentheses
        Problem(
            title: "Valid Parentheses",
            tags: ["String", "Stack"],
            difficulty: "Easy",
            description: """
                Given a string `s` containing only the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.
                A string is valid if open brackets are closed by the same type of brackets in the correct order.
                Example: Input: s = "()", Output: true; Input: s = "([)]", Output: false
                """,
            solution: [
                "def is_valid(s):",
                "    # Initialize a stack to track opening brackets",
                "    stack = []",
                "    # Dictionary mapping closing brackets to opening brackets",
                "    mapping = {')': '(', '}': '{', ']': '['}",
                "    # Iterate through each character in the string",
                "    for char in s:",
                "        # If character is a closing bracket",
                "        if char in mapping:",
                "            # Check if stack is empty or top doesn't match",
                "            if not stack or stack.pop() != mapping[char]:",
                "                return False",
                "        # If character is an opening bracket",
                "        else:",
                "            stack.append(char)",
                "    # String is valid if stack is empty",
                "    return len(stack) == 0"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 2,
                    question: "Which data structure is used to track the order of opening brackets?",
                    options: [
                        "    queue = []",
                        "    stack = []",
                        "    brackets_set = set()",
                        "    brackets_dict = {}"
                    ],
                    correctAnswerIndex: 1
                ),
                MultipleChoiceQuestion(
                    lineIndex: 4,
                    question: "What does the mapping dictionary store?",
                    options: [
                        "    mapping = {')': '(', '}': '{', ']': '['}",
                        "    mapping = {'(': ')', '{': '}', '[': ']'}",
                        "    mapping = {')': 1, '}': 2, ']': 3}",
                        "    mapping = {'(': 1, '{': 2, '[': 3}"
                    ],
                    correctAnswerIndex: 0
                )
            ]
        ),
        
        // MARK: - Maximum Subarray
        Problem(
            title: "Maximum Subarray",
            tags: ["Array", "Dynamic Programming"],
            difficulty: "Medium",
            description: """
                Given an integer array `nums`, find the contiguous subarray with the largest sum and return its sum.
                Example: Input: nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4], Output: 6 (subarray [4, -1, 2, 1])
                """,
            solution: [
                "def max_subarray(nums):",
                "    # Initialize max_sum and current_sum with first element",
                "    max_sum = nums[0]",
                "    current_sum = nums[0]",
                "    # Iterate through array starting from second element",
                "    for i in range(1, len(nums)):",
                "        # Decide to start new subarray or extend existing one",
                "        current_sum = max(nums[i], current_sum + nums[i])",
                "        # Update maximum sum if current sum is larger",
                "        max_sum = max(max_sum, current_sum)",
                "    # Return the maximum sum found",
                "    return max_sum"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 6,
                    question: "How do we decide whether to start a new subarray or extend the current one?",
                    options: [
                        "        current_sum = nums[i]",
                        "        current_sum = current_sum + nums[i]",
                        "        current_sum = max(nums[i], current_sum + nums[i])",
                        "        current_sum = min(nums[i], current_sum + nums[i])"
                    ],
                    correctAnswerIndex: 2
                ),
                MultipleChoiceQuestion(
                    lineIndex: 8,
                    question: "How do we update the maximum sum found so far?",
                    options: [
                        "        max_sum = current_sum",
                        "        max_sum = max(max_sum, current_sum)",
                        "        max_sum = min(max_sum, current_sum)",
                        "        max_sum += current_sum"
                    ],
                    correctAnswerIndex: 1
                )
            ]
        ),
        
        // MARK: - Calculate Area of a Rectangle
        Problem(
            title: "Calculate Rectangle Area",
            tags: ["Math", "Functions"],
            difficulty: "Easy",
            description: """
                Write a function `calculate_area` that takes two parameters, `length` and `width`, and returns the area of a rectangle.
                Example: Input: length = 10, width = 5, Output: 50
                """,
            solution: [
                "def calculate_area(length, width):",
                "    # Calculate area by multiplying length and width",
                "    return length * width",
                "",
                "# Example usage",
                "area = calculate_area(10, 5)",
                "print('The area is:', area)"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 2,
                    question: "What is the correct way to calculate the area in the function?",
                    options: [
                        "    return length + width",
                        "    return length - width",
                        "    return length * width",
                        "    return length / width"
                    ],
                    correctAnswerIndex: 2
                ),
                MultipleChoiceQuestion(
                    lineIndex: 5,
                    question: "How do you call the function with length=10 and width=5?",
                    options: [
                        "area = calculate_area(10, 5)",
                        "area = calculate_area(length=10, width=5)",
                        "calculate_area(10, 5)",
                        "area = 10 * 5"
                    ],
                    correctAnswerIndex: 0
                )
            ]
        ),
        
        // MARK: - Reverse Linked List
        Problem(
            title: "Reverse Linked List",
            tags: ["Linked List", "Iteration"],
            difficulty: "Easy",
            description: """
                Given the head of a singly linked list, reverse the list and return the new head.
                Example: Input: 1->2->3->4->5->NULL, Output: 5->4->3->2->1->NULL
                """,
            solution: [
                "def reverse_list(head):",
                "    # Initialize previous node as None",
                "    prev = None",
                "    # Current node starts at head",
                "    current = head",
                "    # Iterate until current is None",
                "    while current:",
                "        # Store next node before changing links",
                "        next_temp = current.next",
                "        # Reverse the link to point to previous node",
                "        current.next = prev",
                "        # Move prev and current one step forward",
                "        prev = current",
                "        current = next_temp",
                "    # Return new head of reversed list",
                "    return prev"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 9,
                    question: "How do we reverse the link for the current node?",
                    options: [
                        "        current.next = current",
                        "        current.next = next_temp",
                        "        current.next = prev",
                        "        current.next = head"
                    ],
                    correctAnswerIndex: 2
                ),
                MultipleChoiceQuestion(
                    lineIndex: 12,
                    question: "What should be returned as the new head of the reversed list?",
                    options: [
                        "    return head",
                        "    return current",
                        "    return prev",
                        "    return next_temp"
                    ],
                    correctAnswerIndex: 2
                )
            ]
        ),
        
        // MARK: - Factorial
        Problem(
            title: "Factorial",
            tags: ["Recursion", "Math"],
            difficulty: "Easy",
            description: """
                Write a recursive function `factorial` that calculates the factorial of a non-negative integer `n`.
                Example: Input: n = 5, Output: 120 (since 5! = 5 * 4 * 3 * 2 * 1)
                """,
            solution: [
                "def factorial(n):",
                "    # Base case: factorial of 0 or 1 is 1",
                "    if n <= 1:",
                "        return 1",
                "    # Recursive case: n! = n * (n-1)!",
                "    return n * factorial(n - 1)",
                "",
                "# Example usage",
                "print(factorial(5))"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 2,
                    question: "What is the base case for the factorial function?",
                    options: [
                        "    if n <= 1:",
                        "    if n == 0:",
                        "    if n > 1:",
                        "    if n < 0:"
                    ],
                    correctAnswerIndex: 0
                ),
                MultipleChoiceQuestion(
                    lineIndex: 4,
                    question: "What is the recursive case for calculating factorial?",
                    options: [
                        "    return n * factorial(n - 1)",
                        "    return factorial(n - 1)",
                        "    return n + factorial(n - 1)",
                        "    return factorial(n + 1)"
                    ],
                    correctAnswerIndex: 0
                )
            ]
        ),
        
        // MARK: - Sum of List
        Problem(
            title: "Sum of List",
            tags: ["Array", "Iteration"],
            difficulty: "Easy",
            description: """
                Write a function `sum_list` that takes a list of integers and returns their sum.
                Example: Input: nums = [1, 2, 3], Output: 6
                """,
            solution: [
                "def sum_list(nums):",
                "    # Initialize total to 0",
                "    total = 0",
                "    # Iterate through each number in the list",
                "    for num in nums:",
                "        # Add current number to total",
                "        total += num",
                "    # Return the final sum",
                "    return total",
                "",
                "# Example usage",
                "print(sum_list([1, 2, 3]))"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 4,
                    question: "How do you iterate through the list to sum its elements?",
                    options: [
                        "    for num in range(nums):",
                        "    for num in nums:",
                        "    for num = nums:",
                        "    for num in [1, 2, 3]:"
                    ],
                    correctAnswerIndex: 1
                ),
                MultipleChoiceQuestion(
                    lineIndex: 5,
                    question: "How do you accumulate the sum of the numbers?",
                    options: [
                        "        total += num",
                        "        total = num",
                        "        total + num",
                        "        total = total + num"
                    ],
                    correctAnswerIndex: 0
                )
            ]
        ),
        
        // MARK: - Replace Character
        Problem(
            title: "Replace Character",
            tags: ["String"],
            difficulty: "Easy",
            description: """
                Write a function `replace_char` that takes a string, an old character, and a new character, and returns the string with all occurrences of the old character replaced by the new character.
                Example: Input: text = "banana", old = "a", new = "o", Output: "bonono"
                """,
            solution: [
                "def replace_char(text, old, new):",
                "    # Replace all occurrences of old character with new",
                "    result = text.replace(old, new)",
                "    # Return the modified string",
                "    return result",
                "",
                "# Example usage",
                "print(replace_char('banana', 'a', 'o'))"
            ],
            questions: [
                MultipleChoiceQuestion(
                    lineIndex: 2,
                    question: "How do you replace all occurrences of a character in the string?",
                    options: [
                        "    result = text.replace('a', 'o')",
                        "    result = text.replace(old, new)",
                        "    result = text.sub(old, new)",
                        "    result = text.swap(old, new)"
                    ],
                    correctAnswerIndex: 1
                ),
                MultipleChoiceQuestion(
                    lineIndex: 4,
                    question: "What should the function return?",
                    options: [
                        "    return text",
                        "    return old",
                        "    return new",
                        "    return result"
                    ],
                    correctAnswerIndex: 3
                )
            ]
        )
    ]
}
