import SwiftUI
import Foundation

// MARK: - Python Syntax Highlighter
/// A comprehensive Python 3 syntax highlighter that produces realistic editor-style highlighting
class PythonSyntaxHighlighter {
    
    // MARK: - Token Types
    enum TokenType {
        case keyword
        case builtin
        case string
        case comment
        case number
        case operatorToken
        case delimiter
        case identifier
        case decorator
        case classname
        case functionname
        case parameter
        case whitespace
        case newline
    }
    
    // MARK: - Token Structure
    struct Token {
        let type: TokenType
        let value: String
        let range: Range<String.Index>
    }
    
    // MARK: - Python Keywords and Builtins
    private static let keywords: Set<String> = [
        "and", "as", "assert", "break", "class", "continue", "def", "del", "elif", "else",
        "except", "finally", "for", "from", "global", "if", "import", "in", "is", "lambda",
        "nonlocal", "not", "or", "pass", "raise", "return", "try", "while", "with", "yield",
        "True", "False", "None"
    ]
    
    private static let builtins: Set<String> = [
        "abs", "all", "any", "ascii", "bin", "bool", "bytearray", "bytes", "callable", "chr",
        "classmethod", "compile", "complex", "delattr", "dict", "dir", "divmod", "enumerate",
        "eval", "exec", "filter", "float", "format", "frozenset", "getattr", "globals", "hasattr",
        "hash", "help", "hex", "id", "input", "int", "isinstance", "issubclass", "iter", "len",
        "list", "locals", "map", "max", "memoryview", "min", "next", "object", "oct", "open",
        "ord", "pow", "print", "property", "range", "repr", "reversed", "round", "set", "setattr",
        "slice", "sorted", "staticmethod", "str", "sum", "super", "tuple", "type", "vars", "zip",
        "__import__", "append", "pop", "remove", "insert", "index", "count", "sort", "reverse",
        "copy", "clear", "extend", "keys", "values", "items", "get", "update"
    ]
    
    private static let operators: Set<String> = [
        "+", "-", "*", "/", "//", "%", "**", "=", "+=", "-=", "*=", "/=", "//=", "%=", "**=",
        "==", "!=", "<", ">", "<=", ">=", "&", "|", "^", "~", "<<", ">>", "&=", "|=", "^=",
        "<<=", ">>="
    ]
    
    private static let delimiters: Set<String> = [
        "(", ")", "[", "]", "{", "}", ",", ":", ";", ".", "->", "..."
    ]
    
    // MARK: - Color Scheme (VS Code Dark+ inspired)
    struct ColorScheme {
        static let keyword = Color(red: 0.31, green: 0.56, blue: 0.84)      // #569cd6 (blue)
        static let builtin = Color(red: 0.86, green: 0.86, blue: 0.51)      // #dcdcaa (yellow)
        static let string = Color(red: 0.81, green: 0.65, blue: 0.47)       // #ce9178 (orange)
        static let comment = Color(red: 0.38, green: 0.70, blue: 0.35)      // #6a9955 (green)
        static let number = Color(red: 0.71, green: 0.84, blue: 0.67)       // #b5cea8 (light green)
        static let operator_ = Color(red: 0.80, green: 0.80, blue: 0.80)    // #cccccc (light gray)
        static let delimiter = Color(red: 0.85, green: 0.85, blue: 0.85)    // #d4d4d4 (lighter gray)
        static let identifier = Color(red: 0.36, green: 0.68, blue: 0.95)   // #5dade2 (light blue)
        static let functionName = Color(red: 0.86, green: 0.86, blue: 0.51) // #dcdcaa (yellow)
        static let className = Color(red: 0.30, green: 0.85, blue: 0.85)    // #4ec9b0 (cyan)
        static let parameter = Color(red: 0.60, green: 0.80, blue: 0.95)    // #9cdcfe (light blue)
        static let decorator = Color(red: 0.86, green: 0.86, blue: 0.51)    // #dcdcaa (yellow)
        static let text = Color.primary
    }
    
    // MARK: - Main Highlighting Function
    static func highlight(_ code: String) -> AttributedString {
        let tokens = tokenize(code)
        var attributedString = AttributedString()
        
        for token in tokens {
            var tokenString = AttributedString(token.value)
            
            // Apply color based on token type
            switch token.type {
            case .keyword:
                tokenString.foregroundColor = ColorScheme.keyword
                tokenString.font = .system(.caption, design: .monospaced, weight: .medium)
            case .builtin:
                tokenString.foregroundColor = ColorScheme.builtin
                tokenString.font = .system(.caption, design: .monospaced)
            case .string:
                tokenString.foregroundColor = ColorScheme.string
                tokenString.font = .system(.caption, design: .monospaced)
            case .comment:
                tokenString.foregroundColor = ColorScheme.comment
                tokenString.font = .system(.caption, design: .monospaced, weight: .light)
            case .number:
                tokenString.foregroundColor = ColorScheme.number
                tokenString.font = .system(.caption, design: .monospaced)
            case .operatorToken:
                tokenString.foregroundColor = ColorScheme.operator_
                tokenString.font = .system(.caption, design: .monospaced, weight: .medium)
            case .delimiter:
                tokenString.foregroundColor = ColorScheme.delimiter
                tokenString.font = .system(.caption, design: .monospaced)
            case .functionname:
                tokenString.foregroundColor = ColorScheme.functionName
                tokenString.font = .system(.caption, design: .monospaced, weight: .medium)
            case .classname:
                tokenString.foregroundColor = ColorScheme.className
                tokenString.font = .system(.caption, design: .monospaced, weight: .medium)
            case .parameter:
                tokenString.foregroundColor = ColorScheme.parameter
                tokenString.font = .system(.caption, design: .monospaced)
            case .decorator:
                tokenString.foregroundColor = ColorScheme.decorator
                tokenString.font = .system(.caption, design: .monospaced)
            case .identifier:
                tokenString.foregroundColor = ColorScheme.identifier
                tokenString.font = .system(.caption, design: .monospaced)
            default:
                tokenString.foregroundColor = ColorScheme.text
                tokenString.font = .system(.caption, design: .monospaced)
            }
            
            attributedString.append(tokenString)
        }
        
        return attributedString
    }
    
    // MARK: - Tokenization
    private static func tokenize(_ code: String) -> [Token] {
        var tokens: [Token] = []
        var currentIndex = code.startIndex
        
        while currentIndex < code.endIndex {
            let char = code[currentIndex]
            
            // Skip whitespace (preserve it but don't highlight)
            if char.isWhitespace {
                let start = currentIndex
                while currentIndex < code.endIndex && code[currentIndex].isWhitespace {
                    currentIndex = code.index(after: currentIndex)
                }
                let value = String(code[start..<currentIndex])
                tokens.append(Token(type: .whitespace, value: value, range: start..<currentIndex))
                continue
            }
            
            // Comments
            if char == "#" {
                let start = currentIndex
                while currentIndex < code.endIndex && code[currentIndex] != "\n" {
                    currentIndex = code.index(after: currentIndex)
                }
                let value = String(code[start..<currentIndex])
                tokens.append(Token(type: .comment, value: value, range: start..<currentIndex))
                continue
            }
            
            // Strings
            if char == "\"" || char == "'" {
                let quote = char
                let start = currentIndex
                currentIndex = code.index(after: currentIndex) // Skip opening quote
                
                while currentIndex < code.endIndex {
                    let currentChar = code[currentIndex]
                    if currentChar == quote {
                        currentIndex = code.index(after: currentIndex) // Include closing quote
                        break
                    }
                    if currentChar == "\\" && code.index(after: currentIndex) < code.endIndex {
                        currentIndex = code.index(after: currentIndex) // Skip escaped char
                    }
                    currentIndex = code.index(after: currentIndex)
                }
                
                let value = String(code[start..<currentIndex])
                tokens.append(Token(type: .string, value: value, range: start..<currentIndex))
                continue
            }
            
            // Numbers
            if char.isNumber {
                let start = currentIndex
                while currentIndex < code.endIndex && (code[currentIndex].isNumber || code[currentIndex] == ".") {
                    currentIndex = code.index(after: currentIndex)
                }
                let value = String(code[start..<currentIndex])
                tokens.append(Token(type: .number, value: value, range: start..<currentIndex))
                continue
            }
            
            // Multi-character operators
            if let multiCharOp = checkMultiCharOperator(code, at: currentIndex) {
                let start = currentIndex
                let endIndex = code.index(currentIndex, offsetBy: multiCharOp.count)
                tokens.append(Token(type: .operatorToken, value: multiCharOp, range: start..<endIndex))
                currentIndex = endIndex
                continue
            }
            
            // Single character operators and delimiters
            let charString = String(char)
            if operators.contains(charString) {
                let start = currentIndex
                currentIndex = code.index(after: currentIndex)
                tokens.append(Token(type: .operatorToken, value: charString, range: start..<currentIndex))
                continue
            }
            
            if delimiters.contains(charString) {
                let start = currentIndex
                currentIndex = code.index(after: currentIndex)
                tokens.append(Token(type: .delimiter, value: charString, range: start..<currentIndex))
                continue
            }
            
            // Identifiers, keywords, and function names
            if char.isLetter || char == "_" {
                let start = currentIndex
                while currentIndex < code.endIndex && (code[currentIndex].isLetter || code[currentIndex].isNumber || code[currentIndex] == "_") {
                    currentIndex = code.index(after: currentIndex)
                }
                
                let value = String(code[start..<currentIndex])
                let tokenType = classifyIdentifier(value, context: getContext(tokens))
                tokens.append(Token(type: tokenType, value: value, range: start..<currentIndex))
                continue
            }
            
            // Unknown character, treat as text
            let start = currentIndex
            currentIndex = code.index(after: currentIndex)
            let value = String(code[start..<currentIndex])
            tokens.append(Token(type: .identifier, value: value, range: start..<currentIndex))
        }
        
        return tokens
    }
    
    // MARK: - Helper Functions
    private static func checkMultiCharOperator(_ code: String, at index: String.Index) -> String? {
        let remainingCode = String(code[index...])
        
        // Check for 3-character operators first
        for op in ["//=", "**=", ">>=", "<<="] {
            if remainingCode.hasPrefix(op) {
                return op
            }
        }
        
        // Check for 2-character operators
        for op in ["//", "**", "==", "!=", "<=", ">=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<", ">>", "->"] {
            if remainingCode.hasPrefix(op) {
                return op
            }
        }
        
        return nil
    }
    
    private static func classifyIdentifier(_ value: String, context: TokenContext) -> TokenType {
        if keywords.contains(value) {
            return .keyword
        }
        
        if builtins.contains(value) {
            return .builtin
        }
        
        // Function definition
        if context.afterDef {
            return .functionname
        }
        
        // Class definition
        if context.afterClass {
            return .classname
        }
        
        // Function call
        if context.beforeParenthesis {
            return .functionname
        }
        
        return .identifier
    }
    
    private static func getContext(_ tokens: [Token]) -> TokenContext {
        let lastFewTokens = tokens.suffix(5).map { $0.value.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        return TokenContext(
            afterDef: lastFewTokens.contains("def"),
            afterClass: lastFewTokens.contains("class"),
            beforeParenthesis: false // This would need more complex lookahead
        )
    }
    
    private struct TokenContext {
        let afterDef: Bool
        let afterClass: Bool
        let beforeParenthesis: Bool
    }
}

// MARK: - SwiftUI Text Extension
extension Text {
    /// Creates a Text view with Python syntax highlighting
    static func pythonCode(_ code: String) -> Text {
        Text(PythonSyntaxHighlighter.highlight(code))
    }
}