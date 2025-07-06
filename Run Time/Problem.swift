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

// MARK: - Sample Data (Loading from embedded JSON data)
extension Problem {
    /// Sample problems created from JSON data (for testing without bundle modifications)
    static let sampleProblems: [Problem] = [
        // Array problems
        Problem.fromJSONString("""
        {
          "title": "First List Element",
          "tags": ["Array"],
          "difficulty": "Easy",
          "description": "Write a function that returns the first element of a list. Example: Input: nums = [1, 2, 3], Output: 1",
          "solution": [
            "def first_element(nums):",
            "    return nums[0]",
            "print(first_element([1, 2, 3]))"
          ],
          "questions": [
            {
              "lineIndex": 1,
              "question": "How do you access the first element of a list?",
              "options": ["    return nums[0]", "    return nums[1]", "    return nums[-1]", "    return nums.first()"],
              "correctAnswerIndex": 0
            }
          ]
        }
        """)!,
        Problem.fromJSONString("""
        {
          "title": "Contains Duplicate",
          "tags": ["Array", "Hash Table"],
          "difficulty": "Easy",
          "description": "Given an integer array nums, return true if any value appears at least twice in the array, and return false if every element is distinct. Example: Input: nums = [1,2,3,1], Output: true",
          "solution": [
            "def contains_duplicate(nums):",
            "    seen = set()",
            "    for num in nums:",
            "        if num in seen:",
            "            return True",
            "        seen.add(num)",
            "    return False"
          ],
          "questions": [
            {
              "lineIndex": 1,
              "question": "Which data structure efficiently tracks seen numbers?",
              "options": ["    seen = []", "    seen = set()", "    seen = {}", "    seen = tuple()"],
              "correctAnswerIndex": 1
            },
            {
              "lineIndex": 3,
              "question": "How do you check if a number was seen before?",
              "options": ["    if num in seen:", "    if num == seen:", "    if seen.contains(num):", "    if num not in seen:"],
              "correctAnswerIndex": 0
            }
          ]
        }
        """)!,
        // String problems  
        Problem.fromJSONString("""
        {
          "title": "String Length",
          "tags": ["String"],
          "difficulty": "Easy",
          "description": "Write a function that returns the length of a given string. Example: Input: text = 'hello', Output: 5",
          "solution": [
            "def get_length(text):",
            "    return len(text)",
            "print(get_length('hello'))"
          ],
          "questions": [
            {
              "lineIndex": 1,
              "question": "How do you get the length of a string?",
              "options": ["    return len(text)", "    return text.length()", "    return text.size()", "    return count(text)"],
              "correctAnswerIndex": 0
            }
          ]
        }
        """)!,
        Problem.fromJSONString("""
        {
          "title": "Valid Anagram",
          "tags": ["String", "Hash Table"],
          "difficulty": "Easy",
          "description": "Given two strings s and t, return true if t is an anagram of s, and false otherwise. Example: Input: s = 'anagram', t = 'nagaram', Output: true",
          "solution": [
            "def is_anagram(s, t):",
            "    return sorted(s) == sorted(t)"
          ],
          "questions": [
            {
              "lineIndex": 1,
              "question": "How do you check if two strings are anagrams?",
              "options": ["    return sorted(s) == sorted(t)", "    return s == t", "    return len(s) == len(t)", "    return s.reverse() == t"],
              "correctAnswerIndex": 0
            }
          ]
        }
        """)!,
        // Math problems
        Problem.fromJSONString("""
        {
          "title": "Sum of Two Numbers",
          "tags": ["Math", "Functions"],
          "difficulty": "Easy",
          "description": "Write a function that takes two integers and returns their sum. Example: Input: a = 3, b = 4, Output: 7",
          "solution": [
            "def sum_two(a, b):",
            "    return a + b",
            "print(sum_two(3, 4))"
          ],
          "questions": [
            {
              "lineIndex": 1,
              "question": "What returns the sum of two numbers?",
              "options": ["    return a + b", "    return a * b", "    return a - b", "    print(a + b)"],
              "correctAnswerIndex": 0
            }
          ]
        }
        """)!,
        Problem.fromJSONString("""
        {
          "title": "FizzBuzz",
          "tags": ["Math", "String"],
          "difficulty": "Easy",
          "description": "Given an integer n, return a string array answer where answer[i] == 'FizzBuzz' if i is divisible by 3 and 5, 'Fizz' if i is divisible by 3, 'Buzz' if i is divisible by 5, or str(i) otherwise.",
          "solution": [
            "def fizz_buzz(n):",
            "    result = []",
            "    for i in range(1, n + 1):",
            "        if i % 15 == 0:",
            "            result.append('FizzBuzz')",
            "        elif i % 3 == 0:",
            "            result.append('Fizz')",
            "        elif i % 5 == 0:",
            "            result.append('Buzz')",
            "        else:",
            "            result.append(str(i))",
            "    return result"
          ],
          "questions": [
            {
              "lineIndex": 3,
              "question": "How do you check if a number is divisible by both 3 and 5?",
              "options": ["    if i % 3 == 0 and i % 5 == 0:", "    if i % 15 == 0:", "    if i % 8 == 0:", "    if i % 3 == 0 or i % 5 == 0:"],
              "correctAnswerIndex": 1
            },
            {
              "lineIndex": 5,
              "question": "How do you check if a number is divisible by 3 only?",
              "options": ["    elif i % 3 == 0:", "    elif i % 3 != 0:", "    elif i / 3 == 0:", "    elif i == 3:"],
              "correctAnswerIndex": 0
            }
          ]
        }
        """)!,
        // Medium complexity problems
        Problem.fromJSONString("""
        {
          "title": "Two Sum",
          "tags": ["Array", "Hash Table"],
          "difficulty": "Medium",
          "description": "Write a function that takes an array of integers and a target sum, returning indices of two numbers that add to the target. Example: Input: nums = [3, 4, 5], target = 9, Output: [1, 2]",
          "solution": [
            "def two_sum(nums, target):",
            "    num_map = {}",
            "    for i, num in enumerate(nums):",
            "        complement = target - num",
            "        if complement in num_map:",
            "            return [num_map[complement], i]",
            "        num_map[num] = i",
            "    return []"
          ],
          "questions": [
            {
              "lineIndex": 1,
              "question": "Which data structure allows fast lookup of numbers?",
              "options": ["    num_list = []", "    num_set = set()", "    num_map = {}", "    num_array = []"],
              "correctAnswerIndex": 2
            },
            {
              "lineIndex": 3,
              "question": "How do you compute the number needed to reach the target?",
              "options": ["    complement = target + num", "    complement = target - num", "    complement = num - target", "    complement = target * num"],
              "correctAnswerIndex": 1
            },
            {
              "lineIndex": 4,
              "question": "How do you check if the complement exists?",
              "options": ["    if complement in nums:", "    if complement in num_map:", "    if num in num_map:", "    if complement == num:"],
              "correctAnswerIndex": 1
            }
          ]
        }
        """)!
    ].compactMap { $0 }
    
    /// Creates a Problem from a JSON string  
    static func fromJSONString(_ jsonString: String) -> Problem? {
        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return fromJSON(json)
    }
    
    /// Creates a Problem from a JSON dictionary
    static func fromJSON(_ json: [String: Any]) -> Problem? {
        guard let title = json["title"] as? String,
              let tags = json["tags"] as? [String],
              let difficulty = json["difficulty"] as? String,
              let description = json["description"] as? String,
              let solution = json["solution"] as? [String],
              let questionsData = json["questions"] as? [[String: Any]] else {
            return nil
        }
        
        var questions: [Problem.MultipleChoiceQuestion] = []
        for questionData in questionsData {
            if let question = Problem.MultipleChoiceQuestion.fromJSON(questionData) {
                questions.append(question)
            }
        }
        
        return Problem(title: title, tags: tags, difficulty: difficulty, description: description, solution: solution, questions: questions)
    }
}

// MARK: - MultipleChoiceQuestion JSON Loading
extension Problem.MultipleChoiceQuestion {
    /// Creates a MultipleChoiceQuestion from a JSON dictionary
    static func fromJSON(_ json: [String: Any]) -> Problem.MultipleChoiceQuestion? {
        guard let lineIndex = json["lineIndex"] as? Int,
              let question = json["question"] as? String,
              let options = json["options"] as? [String],
              let correctAnswerIndex = json["correctAnswerIndex"] as? Int else {
            return nil
        }
        
        return Problem.MultipleChoiceQuestion(lineIndex: lineIndex, question: question, options: options, correctAnswerIndex: correctAnswerIndex)
    }
}
