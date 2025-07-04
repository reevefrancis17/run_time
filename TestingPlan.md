# Run Time App Testing Plan

## Manual Testing Checklist

### Setup Instructions
1. **Create new iOS project in Xcode**:
   - File → New → Project → iOS → App
   - Product Name: "RunTime"
   - Interface: SwiftUI
   - Language: Swift

2. **Add our files**:
   - Drag `Problem.swift`, `ContentView.swift`, `ProblemDetailView.swift` into project
   - Replace default `ContentView.swift` with our version

3. **Update App.swift** (if needed):
   ```swift
   import SwiftUI
   
   @main
   struct RunTimeApp: App {
       var body: some Scene {
           WindowGroup {
               ContentView()
           }
       }
   }
   ```

### Test Cases to Execute

#### ✅ Home Screen Tests
- [ ] **App Launch**: App opens without crashes
- [ ] **Problem List**: Shows 5 problems with titles
- [ ] **Difficulty Badges**: Green (Easy), Orange (Medium), Red (Hard)
- [ ] **Time Display**: Shows formatted time (e.g., "5 min", "7:30")
- [ ] **Navigation**: Tap problem → navigates to detail
- [ ] **Plus Button**: Tap "+" → prints to console

#### ✅ Problem Detail Tests
- [ ] **Screen Load**: Detail screen displays problem title
- [ ] **Timer Start**: Timer starts counting down from timeLimit
- [ ] **Timer Display**: Shows MM:SS format (e.g., "05:00")
- [ ] **Timer Colors**: 
  - Normal: Black/Primary
  - < 2 min: Orange
  - < 1 min: Red
- [ ] **Code Editor**: 
  - Shows placeholder text
  - Allows typing
  - Uses monospaced font
- [ ] **Submit Button**:
  - Disabled when code is empty
  - Disabled when timer = 0
  - Shows loading state when submitting
- [ ] **Mock Evaluation**: 
  - Type "hello" → Shows "✅ Correct!"
  - Type other text → Shows "❌ Incorrect"

#### ✅ Edge Cases
- [ ] **Timer Zero**: Submit button disabled at 00:00
- [ ] **Empty Code**: Submit button disabled for empty input
- [ ] **Navigation Back**: Back button works correctly
- [ ] **Screen Rotation**: UI adapts to landscape/portrait
- [ ] **Long Problem Text**: Scrolling works properly

### Performance Tests
- [ ] **Memory Usage**: No significant memory leaks
- [ ] **Timer Accuracy**: Timer counts down correctly
- [ ] **Smooth Navigation**: No lag between screens
- [ ] **Code Editor Performance**: Smooth typing in TextEditor

## Automated Testing (Optional)

If you want to add unit tests, I can create:
1. **ProblemTests.swift** - Model validation
2. **ContentViewTests.swift** - UI component tests
3. **TimerTests.swift** - Timer functionality tests

## How to Test Together

### Option 1: You Test, I Guide
1. **You**: Follow checklist above, run tests in simulator
2. **You**: Report results: "✅ Working" or "❌ Error: [description]"
3. **Me**: Help debug any issues you find

### Option 2: Collaborative Debugging
1. **You**: Share specific errors/screenshots
2. **Me**: Provide fixes or improvements
3. **We**: Iterate until everything works

### Option 3: Add Automated Tests
1. **Me**: Create unit test files
2. **You**: Run tests in Xcode (⌘+U)
3. **We**: Review test results together

## Expected Results
- **Home Screen**: Clean list of 5 problems with proper styling
- **Detail Screen**: Functional timer, code editor, and submit button
- **Navigation**: Smooth transitions between screens
- **No Crashes**: App runs stably throughout testing

## Common Issues to Watch For
- **Timer not starting**: Check `onAppear` in ProblemDetailView
- **Navigation errors**: Verify NavigationLink setup
- **UI layout issues**: Check constraints and spacing
- **Build errors**: Ensure all files are added to project target

---

**Ready to start?** Let me know which testing approach you prefer!