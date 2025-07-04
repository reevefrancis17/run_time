# Run Time - iOS Coding Challenge App

A Duolingo-style app for learning programming through multiple choice questions about coding solutions.

## Features

- **Multiple Choice Questions**: Fill-in-the-blank style questions for classic coding problems
- **Algorithm Categories**: Problems tagged with concepts like "Array", "Stack", "Dynamic Programming"
- **Progress Tracking**: See your score and review incorrect answers
- **Clean UI**: SwiftUI interface optimized for learning

## How to Run

1. **Open in Xcode**: 
   - Open `Run Time.xcodeproj` in Xcode
   - Make sure you have Xcode 15.0 or later

2. **Select Simulator**:
   - Choose any iOS simulator (iPhone 14, iPhone 15, etc.)
   - iOS 17.0+ required

3. **Build & Run**:
   - Press `Cmd + R` or click the Run button
   - The app will launch in the simulator

## App Structure

- **Home Screen**: List of coding problems with tags and difficulty
- **Problem Detail**: Shows the solution with blanked-out lines
- **Questions**: Multiple choice questions for each blank line
- **Results**: Score summary with correct/incorrect answers

## Sample Problems

The app includes 5 classic coding problems:

1. **Two Sum** (Easy) - Hash Table, Array
2. **Valid Parentheses** (Easy) - Stack, String  
3. **Maximum Subarray** (Medium) - Dynamic Programming
4. **Binary Tree Inorder Traversal** (Medium) - Tree, Recursion
5. **Reverse Linked List** (Easy) - Linked List

## File Structure

```
Run Time/
├── Run_TimeApp.swift          # App entry point
├── ContentView.swift          # Home screen with problem list
├── Problem.swift              # Data model and sample problems
├── ProblemDetailView.swift    # Quiz interface
└── Assets.xcassets/           # App icons and colors
```

## Next Steps

- Add more problems and categories
- Implement user progress persistence
- Add difficulty progression
- Include code explanations for wrong answers