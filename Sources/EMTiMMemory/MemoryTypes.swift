import Foundation

// MARK: - Memory Insights

/// Provides analytics and insights about the current state of the memory system
public struct MemoryInsights {
    public let totalThoughts: Int
    public let totalEvents: Int
    public let memoryUtilization: Double
    public let agentMemoryDistribution: [String: Int]
    public let recentActivitySummary: String
    
    public init(
        totalThoughts: Int = 0,
        totalEvents: Int = 0,
        memoryUtilization: Double = 0.0,
        agentMemoryDistribution: [String: Int] = [:],
        recentActivitySummary: String = "No recent activity"
    ) {
        self.totalThoughts = totalThoughts
        self.totalEvents = totalEvents
        self.memoryUtilization = memoryUtilization
        self.agentMemoryDistribution = agentMemoryDistribution
        self.recentActivitySummary = recentActivitySummary
    }
}

// MARK: - Memory Context

/// Contains relevant memories retrieved for a specific query or agent
public struct MemoryContext {
    public let relevantThoughts: [InductiveThought]
    public let relevantEvents: [EpisodicEvent]
    public let timeWindow: TimeInterval?
    
    public init(
        relevantThoughts: [InductiveThought] = [],
        relevantEvents: [EpisodicEvent] = [],
        timeWindow: TimeInterval? = nil
    ) {
        self.relevantThoughts = relevantThoughts
        self.relevantEvents = relevantEvents
        self.timeWindow = timeWindow
    }
}

// MARK: - Inductive Thought

/// Represents a processed thought or insight extracted from agent responses
public struct InductiveThought: Identifiable, Codable {
    public let id: UUID
    public let timestamp: Date
    public let content: String
    public let category: String
    public let agentType: AgentType?
    public let confidence: Double
    
    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        content: String,
        category: String,
        agentType: AgentType? = nil,
        confidence: Double = 1.0
    ) {
        self.id = id
        self.timestamp = timestamp
        self.content = content
        self.category = category
        self.agentType = agentType
        self.confidence = confidence
    }
}

// MARK: - Episodic Event

/// Represents a complete conversation exchange stored in episodic memory
public struct EpisodicEvent: Identifiable, Codable {
    public let id: UUID
    public let timestamp: Date
    public let userInput: String
    public let systemResponse: String
    public let emotionalContext: [String: Double]
    public let agentResponses: [AgentResponse]
    
    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        userInput: String,
        systemResponse: String,
        emotionalContext: [String: Double] = [:],
        agentResponses: [AgentResponse] = []
    ) {
        self.id = id
        self.timestamp = timestamp
        self.userInput = userInput
        self.systemResponse = systemResponse
        self.emotionalContext = emotionalContext
        self.agentResponses = agentResponses
    }
}

// MARK: - Agent Response

/// Represents a response from a specific cognitive agent
public struct AgentResponse: Identifiable, Codable {
    public let id: UUID
    public let agentType: AgentType
    public let content: String
    public let timestamp: Date
    public let processingTime: TimeInterval?
    public let temperature: Double?
    
    public init(
        id: UUID = UUID(),
        agentType: AgentType,
        content: String,
        timestamp: Date = Date(),
        processingTime: TimeInterval? = nil,
        temperature: Double? = nil
    ) {
        self.id = id
        self.agentType = agentType
        self.content = content
        self.timestamp = timestamp
        self.processingTime = processingTime
        self.temperature = temperature
    }
}

// MARK: - Agent State

/// Represents the current state of a cognitive agent
public struct AgentState {
    public let agentType: AgentType
    public let isActive: Bool
    public let currentTemperature: Double
    public let lastActivityTime: Date?
    public let memoryAccessCount: Int
    public let averageResponseTime: TimeInterval?
    
    public init(
        agentType: AgentType,
        isActive: Bool = true,
        currentTemperature: Double = 0.7,
        lastActivityTime: Date? = nil,
        memoryAccessCount: Int = 0,
        averageResponseTime: TimeInterval? = nil
    ) {
        self.agentType = agentType
        self.isActive = isActive
        self.currentTemperature = currentTemperature
        self.lastActivityTime = lastActivityTime
        self.memoryAccessCount = memoryAccessCount
        self.averageResponseTime = averageResponseTime
    }
}

// MARK: - Conversation Context

/// Provides context from recent conversation history
public struct ConversationContext {
    public let recentExchanges: [ConversationExchange]
    public let totalExchanges: Int
    public let timeSpan: TimeInterval?
    
    public init(
        recentExchanges: [ConversationExchange] = [],
        totalExchanges: Int = 0,
        timeSpan: TimeInterval? = nil
    ) {
        self.recentExchanges = recentExchanges
        self.totalExchanges = totalExchanges
        self.timeSpan = timeSpan
    }
}

// MARK: - Conversation Exchange

/// Represents a single user-system exchange
public struct ConversationExchange: Identifiable, Codable {
    public let id: UUID
    public let userInput: String
    public let systemResponse: String
    public let timestamp: Date
    public let emotionalTone: String?
    
    public init(
        id: UUID = UUID(),
        userInput: String,
        systemResponse: String,
        timestamp: Date = Date(),
        emotionalTone: String? = nil
    ) {
        self.id = id
        self.userInput = userInput
        self.systemResponse = systemResponse
        self.timestamp = timestamp
        self.emotionalTone = emotionalTone
    }
}

// MARK: - Integrated Response

/// Represents the final integrated response from all agents with memory context
public struct IntegratedResponse {
    public let content: String
    public let agentResponses: [AgentResponse]
    public let emotionalState: String
    public let memoryInsights: MemoryInsights?
    public let episodicEvent: EpisodicEvent?
    public let processingMetadata: ProcessingMetadata?
    
    public init(
        content: String,
        agentResponses: [AgentResponse] = [],
        emotionalState: String = "",
        memoryInsights: MemoryInsights? = nil,
        episodicEvent: EpisodicEvent? = nil,
        processingMetadata: ProcessingMetadata? = nil
    ) {
        self.content = content
        self.agentResponses = agentResponses
        self.emotionalState = emotionalState
        self.memoryInsights = memoryInsights
        self.episodicEvent = episodicEvent
        self.processingMetadata = processingMetadata
    }
}

// MARK: - Processing Metadata

/// Contains metadata about the processing pipeline
public struct ProcessingMetadata {
    public let totalProcessingTime: TimeInterval
    public let agentProcessingTimes: [AgentType: TimeInterval]
    public let memoryRetrievalTime: TimeInterval
    public let integrationTime: TimeInterval
    public let memoryStorageTime: TimeInterval
    
    public init(
        totalProcessingTime: TimeInterval,
        agentProcessingTimes: [AgentType: TimeInterval] = [:],
        memoryRetrievalTime: TimeInterval = 0,
        integrationTime: TimeInterval = 0,
        memoryStorageTime: TimeInterval = 0
    ) {
        self.totalProcessingTime = totalProcessingTime
        self.agentProcessingTimes = agentProcessingTimes
        self.memoryRetrievalTime = memoryRetrievalTime
        self.integrationTime = integrationTime
        self.memoryStorageTime = memoryStorageTime
    }
} 