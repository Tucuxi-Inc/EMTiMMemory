import Foundation

// MARK: - EMTiM Memory Module

/// EMTiM (Episodic Memory with Temporal Integration and Metacognition) Memory System
/// 
/// This package provides a comprehensive memory system for multi-agent AI architectures,
/// featuring episodic memory storage, inductive thought extraction, memory consolidation,
/// and intelligent retrieval based on agent specialization and query relevance.
///
/// ## Key Features
/// - **Episodic Memory**: Store complete conversation exchanges with emotional context
/// - **Inductive Thoughts**: Extract and categorize insights from agent responses
/// - **Memory Consolidation**: Automatically merge similar memories and apply forgetting curves
/// - **Agent-Specific Retrieval**: Retrieve memories relevant to specific cognitive agents
/// - **Memory Analytics**: Comprehensive insights into memory utilization and distribution
/// - **Configurable**: Extensive configuration options for different use cases
///
/// ## Usage
/// ```swift
/// import EMTiMMemory
/// 
/// // Create memory system
/// let memorySystem = MemorySystem(configuration: .default)
/// 
/// // Get memory context for an agent
/// let context = await memorySystem.getMemoryContext(
///     for: .cortex, 
///     query: "user question",
///     maxTokens: 2000
/// )
/// 
/// // Process and store new conversation
/// let event = try await memorySystem.processInput(
///     "user input",
///     systemResponse: "system response",
///     agentResponses: agentResponses,
///     emotionalState: emotionalState,
///     context: conversationContext
/// )
/// ```

public struct EMTiMMemory {
    /// Current version of the EMTiM Memory package
    public static let version = "1.0.0"
    
    /// Package information
    public static let packageInfo = PackageInfo(
        name: "EMTiMMemory",
        version: version,
        description: "Episodic Memory with Temporal Integration and Metacognition for Multi-Agent AI Systems",
        author: "EMTiM Development Team",
        license: "MIT"
    )
}

// MARK: - Package Information

public struct PackageInfo {
    public let name: String
    public let version: String
    public let description: String
    public let author: String
    public let license: String
    
    public init(name: String, version: String, description: String, author: String, license: String) {
        self.name = name
        self.version = version
        self.description = description
        self.author = author
        self.license = license
    }
}

// MARK: - Public Exports

// Core Types
public typealias EMTiMMemorySystem = MemorySystem
public typealias EMTiMConfiguration = MemorySystemConfiguration

// Memory Types
public typealias EMTiMMemoryInsights = MemoryInsights
public typealias EMTiMMemoryContext = MemoryContext
public typealias EMTiMInductiveThought = InductiveThought
public typealias EMTiMEpisodicEvent = EpisodicEvent
public typealias EMTiMAgentResponse = AgentResponse
public typealias EMTiMAgentState = AgentState
public typealias EMTiMConversationContext = ConversationContext
public typealias EMTiMConversationExchange = ConversationExchange
public typealias EMTiMIntegratedResponse = IntegratedResponse
public typealias EMTiMProcessingMetadata = ProcessingMetadata

// Agent Types
public typealias EMTiMAgentType = AgentType

// MARK: - Convenience Factory Methods

extension MemorySystem {
    /// Creates a memory system optimized for development and testing
    nonisolated public static func development() -> MemorySystem {
        let config = MemorySystemConfiguration(
            maxEventsInMemory: 1000,
            maxThoughtsInMemory: 2000,
            thoughtSimilarityThreshold: 0.8,
            forgettingCurveDecay: 0.05,
            boundaryRefinementEnabled: true,
            memoryConsolidationInterval: 12 * 3600, // 12 hours
            semanticSearchEnabled: false
        )
        return MemorySystem(configuration: config)
    }
    
    /// Creates a memory system optimized for production use
    nonisolated public static func production() -> MemorySystem {
        let config = MemorySystemConfiguration(
            maxEventsInMemory: 50000,
            maxThoughtsInMemory: 100000,
            thoughtSimilarityThreshold: 0.85,
            forgettingCurveDecay: 0.1,
            boundaryRefinementEnabled: true,
            memoryConsolidationInterval: 24 * 3600, // 24 hours
            semanticSearchEnabled: true
        )
        return MemorySystem(configuration: config)
    }
    
    /// Creates a memory system with minimal memory usage
    nonisolated public static func lightweight() -> MemorySystem {
        let config = MemorySystemConfiguration(
            maxEventsInMemory: 100,
            maxThoughtsInMemory: 200,
            thoughtSimilarityThreshold: 0.9,
            forgettingCurveDecay: 0.2,
            boundaryRefinementEnabled: false,
            memoryConsolidationInterval: 6 * 3600, // 6 hours
            semanticSearchEnabled: false
        )
        return MemorySystem(configuration: config)
    }
} 