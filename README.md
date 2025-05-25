# EMTiM Memory

**Episodic Memory with Temporal Integration and Metacognition for Multi-Agent AI Systems**

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20watchOS%2010%2B%20%7C%20tvOS%2017%2B-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Detailed Integration Guide](#detailed-integration-guide)
- [API Reference](#api-reference)
- [Configuration](#configuration)
- [Memory System Concepts](#memory-system-concepts)
- [Performance Considerations](#performance-considerations)
- [Examples](#examples)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Overview

EMTiM Memory is a sophisticated memory system designed specifically for multi-agent AI architectures. It provides episodic memory storage, inductive thought extraction, memory consolidation, and intelligent retrieval based on agent specialization and query relevance.

### What Makes EMTiM Memory Special?

- **Agent-Aware Memory**: Each cognitive agent type has specialized memory categories and retrieval patterns
- **Temporal Integration**: Memories are organized and retrieved with temporal context
- **Metacognitive Insights**: The system provides analytics about its own memory state
- **Forgetting Curves**: Implements realistic memory decay and consolidation
- **Scalable Architecture**: Supports everything from lightweight mobile apps to production AI systems

### Key Features

- **🧠 Episodic Memory**: Store complete conversation exchanges with emotional context
- **💭 Inductive Thoughts**: Extract and categorize insights from agent responses  
- **🔄 Memory Consolidation**: Automatically merge similar memories and apply forgetting curves
- **🎯 Agent-Specific Retrieval**: Retrieve memories relevant to specific cognitive agents
- **📊 Memory Analytics**: Comprehensive insights into memory utilization and distribution
- **⚙️ Configurable**: Extensive configuration options for different use cases
- **🚀 Performance Optimized**: Efficient memory management and retrieval algorithms
- **🧪 Well Tested**: Comprehensive unit test suite ensuring reliability

## Architecture

### Cognitive Agent Types

EMTiM Memory supports seven distinct cognitive agent types, each with specialized memory handling:

| Agent | Icon | Role | Memory Specialization | Default Temp |
|-------|------|------|----------------------|--------------|
| **Cortex** | 🧠 | Emotional processing and basic meaning analysis | Emotional, meaning, interpretation, context | 0.7 |
| **Seer** | 👁️ | Pattern recognition and predictive analysis | Pattern, prediction, trend, future, insight | 0.4 |
| **Oracle** | 🔮 | Strategic planning and probability assessment | Strategy, planning, probability, decision, outcome | 0.3 |
| **House** | 🏛️ | Practical implementation and resource management | Implementation, practical, resource, constraint, execution | 0.4 |
| **Prudence** | ⚖️ | Risk assessment and constraint identification | Risk, caution, safety, boundary, limitation | 0.3 |
| **Day-Dream** | 💭 | Creative connections and associative thinking | Creative, association, metaphor, connection, inspiration | 0.8 |
| **Conscience** | 🤔 | Ethical evaluation and moral guidance | Ethical, moral, responsibility, value, principle | 0.6 |

### Memory Types

#### Episodic Events
Complete conversation exchanges containing:
- User input and system response
- Emotional context (key-value pairs)
- Agent responses with metadata
- Timestamp and unique identifier
- Processing metadata (optional)

#### Inductive Thoughts
Extracted insights containing:
- Content and category classification
- Associated agent type
- Confidence score (0.0 - 1.0)
- Temporal information
- Unique identifier

#### Memory Context
Retrieved memory sets containing:
- Relevant thoughts filtered by agent type
- Relevant events based on query similarity
- Time window constraints
- Relevance scoring

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                    EMTiM Memory System                      │
├─────────────────────────────────────────────────────────────┤
│  Memory Storage     │  Memory Retrieval  │  Memory Analytics│
│  ┌─────────────┐   │  ┌──────────────┐  │  ┌─────────────┐ │
│  │ Episodic    │   │  │ Agent-Aware  │  │  │ Utilization │ │
│  │ Events      │   │  │ Filtering    │  │  │ Tracking    │ │
│  └─────────────┘   │  └──────────────┘  │  └─────────────┘ │
│  ┌─────────────┐   │  ┌──────────────┐  │  ┌─────────────┐ │
│  │ Inductive   │   │  │ Relevance    │  │  │ Distribution│ │
│  │ Thoughts    │   │  │ Scoring      │  │  │ Analysis    │ │
│  └─────────────┘   │  └──────────────┘  │  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                Memory Maintenance                           │
│  ┌─────────────┐   ┌──────────────┐   ┌─────────────────┐  │
│  │ Forgetting  │   │ Consolidation│   │ Limit           │  │
│  │ Curves      │   │ Algorithm    │   │ Management      │  │
│  └─────────────┘   └──────────────┘   └─────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Installation

### Swift Package Manager

Add EMTiM Memory to your project using Swift Package Manager. In Xcode:

1. Go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/Tucuxi-Inc/EMTiMMemory.git`
3. Select the version range or branch
4. Add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Tucuxi-Inc/EMTiMMemory.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["EMTiMMemory"]
    )
]
```

### Import in Your Code

```swift
import EMTiMMemory
```

## Quick Start

### Basic Setup

```swift
import EMTiMMemory

// Create a memory system (choose configuration based on your needs)
let memorySystem = MemorySystem.production()

// Alternative configurations:
// let memorySystem = MemorySystem.development()  // For testing
// let memorySystem = MemorySystem.lightweight()  // For resource-constrained environments
```

### Processing a Conversation

```swift
// 1. Get memory context for relevant agents
let cortexContext = await memorySystem.getMemoryContext(
    for: .cortex,
    query: "user's emotional question",
    maxTokens: 2000
)

// 2. Process with your AI agents (using the memory context)
let agentResponses = [
    AgentResponse(agentType: .cortex, content: "Emotional analysis based on memory..."),
    AgentResponse(agentType: .seer, content: "Pattern recognition with historical context...")
]

// 3. Store the conversation in memory
let episodicEvent = try await memorySystem.processInput(
    "How are you feeling today?",
    systemResponse: "I'm doing well, thank you for asking.",
    agentResponses: agentResponses,
    emotionalState: ["curiosity": 0.8, "empathy": 0.7],
    context: ConversationContext()
)

// 4. Get memory insights
let insights = await memorySystem.getMemoryInsights()
print("Memory utilization: \(insights.memoryUtilization)%")
```

## Detailed Integration Guide

### Step 1: Initialize Memory System in Your AI Architecture

```swift
@MainActor
class YourAIMindSystem {
    private let memorySystem: MemorySystem
    private let openAIService: OpenAIService // Your existing AI service
    
    init() {
        // Choose configuration based on your needs
        self.memorySystem = MemorySystem.production()
        self.openAIService = OpenAIService()
    }
}
```

### Step 2: Enhance Agent Processing with Memory

```swift
private func processAgentWithMemory(
    _ agentType: AgentType,
    input: String,
    previousResponses: [AgentResponse] = []
) async throws -> AgentResponse {
    
    // Get relevant memories for this agent
    let memoryContext = await memorySystem.getMemoryContext(
        for: agentType,
        query: input,
        maxTokens: 2000
    )
    
    // Build enhanced prompt with memory context
    let prompt = buildPromptWithMemory(
        agentType: agentType,
        input: input,
        memoryContext: memoryContext,
        previousResponses: previousResponses
    )
    
    // Call your AI service
    let response = try await openAIService.generateCompletion(
        prompt: prompt,
        temperature: agentType.defaultTemperature
    )
    
    return AgentResponse(
        agentType: agentType,
        content: response,
        temperature: agentType.defaultTemperature
    )
}

private func buildPromptWithMemory(
    agentType: AgentType,
    input: String,
    memoryContext: MemoryContext,
    previousResponses: [AgentResponse]
) -> String {
    var prompt = """
    You are the \(agentType.rawValue) agent.
    Role: \(agentType.description)
    Specialization: \(agentType.memorySpecialization)
    
    Current user input: \(input)
    """
    
    // Add memory context
    if !memoryContext.relevantThoughts.isEmpty {
        prompt += "\n\nRelevant memories from past conversations:"
        for thought in memoryContext.relevantThoughts.prefix(3) {
            prompt += "\n- \(thought.content)"
        }
    }
    
    if !memoryContext.relevantEvents.isEmpty {
        prompt += "\n\nRecent conversation patterns:"
        for event in memoryContext.relevantEvents.prefix(2) {
            prompt += "\n- User asked: \(event.userInput)"
            prompt += "\n- System responded: \(event.systemResponse)"
        }
    }
    
    // Add previous agent responses in this conversation
    if !previousResponses.isEmpty {
        prompt += "\n\nOther agents' analysis:"
        for response in previousResponses {
            prompt += "\n\(response.agentType.rawValue): \(response.content)"
        }
    }
    
    prompt += "\n\nProvide your analysis considering both current input and relevant memories:"
    
    return prompt
}
```

### Step 3: Complete Processing Pipeline

```swift
func processUserInput(_ input: String) async throws -> String {
    var agentResponses: [AgentResponse] = []
    
    // Process agents in sequence, each building on previous responses
    let cortexResponse = try await processAgentWithMemory(.cortex, input: input)
    agentResponses.append(cortexResponse)
    
    let seerResponse = try await processAgentWithMemory(.seer, input: input, previousResponses: agentResponses)
    agentResponses.append(seerResponse)
    
    let oracleResponse = try await processAgentWithMemory(.oracle, input: input, previousResponses: agentResponses)
    agentResponses.append(oracleResponse)
    
    // Integrate responses
    let finalResponse = try await integrateResponses(agentResponses)
    
    // Store in memory
    let conversationContext = ConversationContext(
        recentExchanges: getRecentExchanges(), // Your implementation
        totalExchanges: getTotalExchangeCount(),
        timeSpan: getConversationTimeSpan()
    )
    
    _ = try await memorySystem.processInput(
        input,
        systemResponse: finalResponse,
        agentResponses: agentResponses,
        emotionalState: extractEmotionalState(from: agentResponses),
        context: conversationContext
    )
    
    return finalResponse
}
```

### Step 4: Memory Maintenance

```swift
// Schedule periodic memory maintenance
func scheduleMemoryMaintenance() {
    Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
        Task {
            await self.memorySystem.performMemoryMaintenance()
            
            let insights = await self.memorySystem.getMemoryInsights()
            print("Memory maintenance complete. Utilization: \(insights.memoryUtilization)%")
        }
    }
}
```

## API Reference

### Core Classes

#### `MemorySystem`

The main memory system class implementing `MemorySystemProtocol`.

```swift
@MainActor
public class MemorySystem: ObservableObject, MemorySystemProtocol
```

**Factory Methods:**
```swift
nonisolated public static func development() -> MemorySystem
nonisolated public static func production() -> MemorySystem  
nonisolated public static func lightweight() -> MemorySystem
public init(configuration: MemorySystemConfiguration)
```

**Core Methods:**
```swift
// Memory retrieval
func getMemoryContext(for agentType: AgentType, query: String, maxTokens: Int) async -> MemoryContext

// Memory storage
func processInput(
    _ input: String,
    systemResponse: String,
    agentResponses: [AgentResponse],
    emotionalState: [String: Double],
    context: ConversationContext
) async throws -> EpisodicEvent

// Memory maintenance
func performMemoryMaintenance() async

// Memory analytics
func getMemoryInsights() async -> MemoryInsights
```

#### `MemorySystemConfiguration`

Configuration options for memory system behavior.

```swift
public struct MemorySystemConfiguration {
    public let maxEventsInMemory: Int              // Default: 10,000
    public let maxThoughtsInMemory: Int            // Default: 20,000
    public let thoughtSimilarityThreshold: Double  // Default: 0.85
    public let forgettingCurveDecay: Double        // Default: 0.1
    public let boundaryRefinementEnabled: Bool     // Default: true
    public let memoryConsolidationInterval: TimeInterval // Default: 24 hours
    public let semanticSearchEnabled: Bool         // Default: false
}
```

### Data Structures

#### `AgentType`

Enumeration of cognitive agent types with specialized properties.

```swift
public enum AgentType: String, CaseIterable, Codable, Identifiable, Comparable {
    case cortex, seer, oracle, house, prudence, dayDream, conscience
    
    public var thoughtCategories: [String] { get }
    public var memorySpecialization: String { get }
    public var defaultTemperature: Double { get }
    public var description: String { get }
    public var icon: String { get }
}
```

#### `MemoryContext`

Container for retrieved memories relevant to a query.

```swift
public struct MemoryContext {
    public let relevantThoughts: [InductiveThought]
    public let relevantEvents: [EpisodicEvent]
    public let timeWindow: TimeInterval?
}
```

#### `EpisodicEvent`

Complete conversation exchange with metadata.

```swift
public struct EpisodicEvent: Identifiable, Codable {
    public let id: UUID
    public let timestamp: Date
    public let userInput: String
    public let systemResponse: String
    public let emotionalContext: [String: Double]
    public let agentResponses: [AgentResponse]
}
```

#### `InductiveThought`

Extracted insight with categorization and confidence.

```swift
public struct InductiveThought: Identifiable, Codable {
    public let id: UUID
    public let timestamp: Date
    public let content: String
    public let category: String
    public let agentType: AgentType?
    public let confidence: Double
}
```

#### `AgentResponse`

Response from a specific cognitive agent.

```swift
public struct AgentResponse: Identifiable, Codable {
    public let id: UUID
    public let agentType: AgentType
    public let content: String
    public let timestamp: Date
    public let processingTime: TimeInterval?
    public let temperature: Double?
}
```

#### `MemoryInsights`

Analytics about the current memory state.

```swift
public struct MemoryInsights {
    public let totalThoughts: Int
    public let totalEvents: Int
    public let memoryUtilization: Double
    public let agentMemoryDistribution: [String: Int]
    public let recentActivitySummary: String
}
```

## Configuration

### Pre-configured Options

#### Development Configuration
```swift
let memorySystem = MemorySystem.development()
```
- **Events**: 1,000 max
- **Thoughts**: 2,000 max
- **Similarity Threshold**: 0.8
- **Forgetting Decay**: 0.05 (slower forgetting)
- **Consolidation Interval**: 12 hours
- **Use Case**: Testing, debugging, development

#### Production Configuration
```swift
let memorySystem = MemorySystem.production()
```
- **Events**: 50,000 max
- **Thoughts**: 100,000 max
- **Similarity Threshold**: 0.85
- **Forgetting Decay**: 0.1
- **Consolidation Interval**: 24 hours
- **Use Case**: Production applications, full-scale deployment

#### Lightweight Configuration
```swift
let memorySystem = MemorySystem.lightweight()
```
- **Events**: 100 max
- **Thoughts**: 200 max
- **Similarity Threshold**: 0.9 (stricter consolidation)
- **Forgetting Decay**: 0.2 (faster forgetting)
- **Consolidation Interval**: 6 hours
- **Use Case**: Mobile apps, resource-constrained environments

### Custom Configuration

```swift
let customConfig = MemorySystemConfiguration(
    maxEventsInMemory: 5000,
    maxThoughtsInMemory: 10000,
    thoughtSimilarityThreshold: 0.85,
    forgettingCurveDecay: 0.1,
    boundaryRefinementEnabled: true,
    memoryConsolidationInterval: 24 * 3600, // 24 hours
    semanticSearchEnabled: true
)
let memorySystem = MemorySystem(configuration: customConfig)
```

## Memory System Concepts

### Episodic vs. Semantic Memory

**Episodic Memory** (Events):
- Complete conversation exchanges
- Temporal context preserved
- Emotional state captured
- Agent responses included

**Semantic Memory** (Thoughts):
- Extracted insights and patterns
- Categorized by agent specialization
- Confidence-weighted
- Consolidated over time

### Memory Retrieval Algorithm

1. **Agent Filtering**: Filter thoughts by agent type and categories
2. **Query Matching**: Score relevance using keyword matching
3. **Recency Weighting**: Boost recent memories
4. **Confidence Scoring**: Prioritize high-confidence thoughts
5. **Limit Application**: Return top N results within token limits

### Forgetting Curve Implementation

The system implements a probabilistic forgetting curve:

```
P(forget) = decay_rate × (days_since_creation / 30) - confidence_bonus
```

- Older memories are more likely to be forgotten
- High-confidence thoughts have retention bonus
- Configurable decay rate per use case

### Memory Consolidation

Similar thoughts are automatically consolidated:

1. **Similarity Detection**: Compare content using word overlap
2. **Category Matching**: Only consolidate within same categories
3. **Content Merging**: Combine similar thoughts with separator
4. **Confidence Averaging**: Average confidence scores
5. **Timestamp Updating**: Use most recent timestamp

## Performance Considerations

### Memory Usage

| Configuration | Events | Thoughts | Estimated RAM |
|---------------|--------|----------|---------------|
| Lightweight   | 100    | 200      | ~50 KB        |
| Development   | 1,000  | 2,000    | ~500 KB       |
| Production    | 50,000 | 100,000  | ~25 MB        |

### Processing Performance

- **Memory Retrieval**: O(n log n) where n = stored memories
- **Storage**: O(1) for adding new memories
- **Consolidation**: O(n²) for similarity checking (runs during maintenance)
- **Maintenance**: Scheduled background operation

### Optimization Tips

1. **Choose Appropriate Configuration**: Don't over-provision memory limits
2. **Regular Maintenance**: Schedule maintenance during low-usage periods
3. **Monitor Utilization**: Use `getMemoryInsights()` to track usage
4. **Adjust Thresholds**: Fine-tune similarity thresholds for your use case

## Examples

### Complete Integration Example

See `Examples/BasicIntegration.swift` for a complete example showing:
- Memory system initialization
- Agent processing with memory context
- Memory storage and retrieval
- Analytics and maintenance

### SwiftUI Integration

```swift
import SwiftUI
import EMTiMMemory

@MainActor
class ChatViewModel: ObservableObject {
    private let memorySystem = MemorySystem.production()
    @Published var memoryInsights: MemoryInsights?
    
    func processMessage(_ message: String) async {
        // Your processing logic here
        
        // Update memory insights
        self.memoryInsights = await memorySystem.getMemoryInsights()
    }
}

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            // Your chat UI
            
            if let insights = viewModel.memoryInsights {
                Text("Memory: \(insights.totalEvents) events, \(insights.totalThoughts) thoughts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

## Testing

### Running Tests

```bash
# Run all tests
swift test

# Run specific test
swift test --filter EMTiMMemoryTests.testMemoryStorage

# Run tests with verbose output
swift test --verbose
```

### Test Coverage

The package includes comprehensive tests for:
- ✅ Memory system initialization
- ✅ Agent type properties and behavior
- ✅ Memory storage and retrieval
- ✅ Memory maintenance and consolidation
- ✅ Configuration options
- ✅ Data structure creation and validation
- ✅ Package metadata

### Writing Your Own Tests

```swift
import XCTest
@testable import EMTiMMemory

class YourIntegrationTests: XCTestCase {
    var memorySystem: MemorySystem!
    
    override func setUp() async throws {
        memorySystem = MemorySystem.development()
    }
    
    func testYourIntegration() async throws {
        // Your test implementation
    }
}
```

## Troubleshooting

### Common Issues

#### Actor Isolation Warnings
If you see actor isolation warnings, ensure you're calling memory system methods from the main actor:

```swift
@MainActor
func yourFunction() async {
    let insights = await memorySystem.getMemoryInsights()
}
```

#### Memory Growth
Monitor memory usage and adjust configuration:

```swift
let insights = await memorySystem.getMemoryInsights()
if insights.memoryUtilization > 80 {
    await memorySystem.performMemoryMaintenance()
}
```

#### Performance Issues
For large memory systems, consider:
- Reducing `maxEventsInMemory` and `maxThoughtsInMemory`
- Increasing `forgettingCurveDecay` for faster forgetting
- More frequent maintenance cycles

### Debug Logging

Enable debug logging to understand memory system behavior:

```swift
// The system prints debug information to console
// Look for messages starting with 🧠, 💾, 🧹
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository
2. Open in Xcode or your preferred Swift IDE
3. Run tests: `swift test`
4. Build: `swift build`

### Areas for Contribution

- **Semantic Search**: Implement vector-based similarity search
- **Persistence**: Add SwiftData/CoreData integration
- **Performance**: Optimize memory retrieval algorithms
- **Documentation**: Improve examples and guides
- **Testing**: Add more comprehensive test scenarios

## Roadmap

### Version 1.1 (Planned)
- [ ] Persistent storage integration
- [ ] Vector-based semantic search
- [ ] Memory export/import functionality
- [ ] Enhanced analytics dashboard

### Version 1.2 (Future)
- [ ] Distributed memory systems
- [ ] Machine learning-based memory prioritization
- [ ] Real-time memory streaming
- [ ] Advanced visualization tools

## License

EMTiM Memory is released under the MIT License. See [LICENSE](LICENSE) for details.

## Support

For questions, issues, or feature requests:

1. **Documentation**: Check this README and the API reference
2. **Examples**: Review the `Examples/` directory
3. **Issues**: Search [existing issues](https://github.com/Tucuxi-Inc/EMTiMMemory/issues)
4. **New Issue**: Create a [new issue](https://github.com/Tucuxi-Inc/EMTiMMemory/issues/new)
5. **Discussions**: Join [GitHub Discussions](https://github.com/Tucuxi-Inc/EMTiMMemory/discussions)

## Acknowledgments

- Inspired by cognitive science research on episodic and semantic memory
- Built with Swift's modern concurrency features
- Designed for the multi-agent AI architecture paradigm

---

**EMTiM Memory** - Bringing sophisticated memory capabilities to multi-agent AI systems.

*"Memory is the treasury and guardian of all things." - Cicero* 