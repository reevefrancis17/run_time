# Run Time - iOS Coding Challenge App

A Duolingo-style app for learning programming through multiple choice questions about coding solutions.

## Features

- **Category-Based Learning**: Browse by algorithm concepts (Array, Stack, Dynamic Programming, etc.)
- **Random Problem Selection**: Get a random problem from your chosen category
- **Interactive Code Completion**: Fill-in-the-blank style questions with real Python syntax highlighting
- **Real-Time Timer**: 5-minute countdown starts when you begin answering
- **Visual Feedback**: Code lines turn green/red based on correct/incorrect answers
- **Fast Animations**: Quick tap-twice interaction for smooth progression
- **Variable Question Count**: Each problem can have different numbers of questions

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

- **Category Screen**: List of learning categories (Array, Stack, Functions, etc.)
- **Random Problem**: Launches a random problem from selected category
- **Problem Detail**: Shows Python code solution with syntax highlighting
- **Interactive Questions**: Tap once to select, tap twice to submit and advance
- **Timer**: 5-minute countdown that starts when you begin
- **Results**: Score summary with green/red highlighted code lines

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