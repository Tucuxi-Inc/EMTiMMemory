import Foundation

// MARK: - Memory System Protocol

/// Protocol defining the interface for memory systems
public protocol MemorySystemProtocol: AnyObject {
    func getMemoryContext(for agentType: AgentType, query: String, maxTokens: Int) async -> MemoryContext
    func processInput(_ input: String, systemResponse: String, agentResponses: [AgentResponse], emotionalState: [String: Double], context: ConversationContext) async throws -> EpisodicEvent
    func performMemoryMaintenance() async
    func getMemoryInsights() async -> MemoryInsights
}

// MARK: - Memory System Configuration

/// Configuration options for the memory system
public struct MemorySystemConfiguration {
    public let maxEventsInMemory: Int
    public let maxThoughtsInMemory: Int
    public let thoughtSimilarityThreshold: Double
    public let forgettingCurveDecay: Double
    public let boundaryRefinementEnabled: Bool
    public let memoryConsolidationInterval: TimeInterval
    public let semanticSearchEnabled: Bool
    
    public init(
        maxEventsInMemory: Int = 10000,
        maxThoughtsInMemory: Int = 20000,
        thoughtSimilarityThreshold: Double = 0.85,
        forgettingCurveDecay: Double = 0.1,
        boundaryRefinementEnabled: Bool = true,
        memoryConsolidationInterval: TimeInterval = 24 * 3600, // 24 hours
        semanticSearchEnabled: Bool = false
    ) {
        self.maxEventsInMemory = maxEventsInMemory
        self.maxThoughtsInMemory = maxThoughtsInMemory
        self.thoughtSimilarityThreshold = thoughtSimilarityThreshold
        self.forgettingCurveDecay = forgettingCurveDecay
        self.boundaryRefinementEnabled = boundaryRefinementEnabled
        self.memoryConsolidationInterval = memoryConsolidationInterval
        self.semanticSearchEnabled = semanticSearchEnabled
    }
    
    public static let `default` = MemorySystemConfiguration()
}

// MARK: - Memory System Implementation

/// Core memory system for EMTiM cognitive architecture
@MainActor
public class MemorySystem: ObservableObject, MemorySystemProtocol {
    
    // MARK: - Properties
    
    private let configuration: MemorySystemConfiguration
    private var storedEvents: [EpisodicEvent] = []
    private var storedThoughts: [InductiveThought] = []
    private var lastMaintenanceTime: Date = Date()
    
    // MARK: - Initialization
    
    public init(configuration: MemorySystemConfiguration = .default) {
        self.configuration = configuration
        loadStoredMemories()
    }
    
    // MARK: - Memory Retrieval
    
    /// Retrieves relevant memory context for a specific agent and query
    public func getMemoryContext(for agentType: AgentType, query: String, maxTokens: Int = 2000) async -> MemoryContext {
        let startTime = Date()
        
        // Get relevant events (recent and semantically similar)
        let relevantEvents = getRelevantEvents(for: query, agentType: agentType, limit: 5)
        
        // Get relevant thoughts for this agent type
        let relevantThoughts = getRelevantThoughts(for: agentType, query: query, limit: 10)
        
        let processingTime = Date().timeIntervalSince(startTime)
        print("🧠 Memory retrieval for \(agentType.rawValue): \(relevantEvents.count) events, \(relevantThoughts.count) thoughts (\(String(format: "%.3f", processingTime))s)")
        
        return MemoryContext(
            relevantThoughts: relevantThoughts,
            relevantEvents: relevantEvents,
            timeWindow: configuration.memoryConsolidationInterval
        )
    }
    
    // MARK: - Memory Storage
    
    /// Processes and stores new input with agent responses
    public func processInput(
        _ input: String,
        systemResponse: String,
        agentResponses: [AgentResponse],
        emotionalState: [String: Double],
        context: ConversationContext
    ) async throws -> EpisodicEvent {
        let startTime = Date()
        
        // Create episodic event
        let event = EpisodicEvent(
            userInput: input,
            systemResponse: systemResponse,
            emotionalContext: emotionalState,
            agentResponses: agentResponses
        )
        
        // Store the event
        storedEvents.append(event)
        
        // Extract and store thoughts from agent responses
        for response in agentResponses {
            let thoughts = extractThoughts(from: response)
            storedThoughts.append(contentsOf: thoughts)
        }
        
        // Maintain memory limits
        await maintainMemoryLimits()
        
        let processingTime = Date().timeIntervalSince(startTime)
        print("💾 Stored memory: \(storedEvents.count) events, \(storedThoughts.count) thoughts (\(String(format: "%.3f", processingTime))s)")
        
        return event
    }
    
    // MARK: - Memory Maintenance
    
    /// Performs memory maintenance including forgetting and consolidation
    public func performMemoryMaintenance() async {
        let startTime = Date()
        print("🧹 Starting memory maintenance...")
        
        let initialEvents = storedEvents.count
        let initialThoughts = storedThoughts.count
        
        // Apply forgetting curve
        await applyForgettingCurve()
        
        // Consolidate similar memories
        if configuration.boundaryRefinementEnabled {
            await consolidateMemories()
        }
        
        // Update maintenance time
        lastMaintenanceTime = Date()
        
        let finalEvents = storedEvents.count
        let finalThoughts = storedThoughts.count
        let processingTime = Date().timeIntervalSince(startTime)
        
        print("🧹 Memory maintenance complete:")
        print("   Events: \(initialEvents) → \(finalEvents) (\(initialEvents - finalEvents) removed)")
        print("   Thoughts: \(initialThoughts) → \(finalThoughts) (\(initialThoughts - finalThoughts) removed)")
        print("   Time: \(String(format: "%.3f", processingTime))s")
    }
    
    // MARK: - Memory Analytics
    
    /// Returns insights about the current memory state
    public func getMemoryInsights() async -> MemoryInsights {
        let totalEvents = storedEvents.count
        let totalThoughts = storedThoughts.count
        let memoryUtilization = Double(totalEvents) / Double(configuration.maxEventsInMemory) * 100.0
        
        // Calculate agent distribution
        var agentDistribution: [String: Int] = [:]
        for thought in storedThoughts {
            if let agentType = thought.agentType {
                agentDistribution[agentType.rawValue, default: 0] += 1
            } else {
                agentDistribution["Unknown", default: 0] += 1
            }
        }
        
        let recentActivity = generateActivitySummary()
        
        return MemoryInsights(
            totalThoughts: totalThoughts,
            totalEvents: totalEvents,
            memoryUtilization: memoryUtilization,
            agentMemoryDistribution: agentDistribution,
            recentActivitySummary: recentActivity
        )
    }
    
    // MARK: - Private Methods
    
    private func loadStoredMemories() {
        // In a real implementation, this would load from persistent storage
        print("📚 Loading stored memories from persistent storage...")
        // For now, start with empty memory
    }
    
    private func getRelevantEvents(for query: String, agentType: AgentType, limit: Int) -> [EpisodicEvent] {
        // Simple relevance scoring based on keyword matching and recency
        let queryWords = query.lowercased().components(separatedBy: .whitespacesAndNewlines)
        
        let scoredEvents = storedEvents.map { event -> (event: EpisodicEvent, score: Double) in
            var score = 0.0
            
            // Recency score (more recent = higher score)
            let daysSinceEvent = Date().timeIntervalSince(event.timestamp) / (24 * 3600)
            score += max(0, 1.0 - (daysSinceEvent / 30.0)) * 0.3
            
            // Content relevance score
            let eventText = (event.userInput + " " + event.systemResponse).lowercased()
            let matchingWords = queryWords.filter { eventText.contains($0) }
            score += Double(matchingWords.count) / Double(queryWords.count) * 0.7
            
            return (event, score)
        }
        
        return scoredEvents
            .sorted { $0.score > $1.score }
            .prefix(limit)
            .map { $0.event }
    }
    
    private func getRelevantThoughts(for agentType: AgentType, query: String, limit: Int) -> [InductiveThought] {
        let queryWords = query.lowercased().components(separatedBy: .whitespacesAndNewlines)
        
        // Filter thoughts by agent type and categories
        let agentThoughts = storedThoughts.filter { thought in
            if let thoughtAgentType = thought.agentType {
                return thoughtAgentType == agentType
            } else {
                return agentType.thoughtCategories.contains(thought.category)
            }
        }
        
        // Score thoughts by relevance
        let scoredThoughts = agentThoughts.map { thought -> (thought: InductiveThought, score: Double) in
            var score = 0.0
            
            // Recency score
            let daysSinceThought = Date().timeIntervalSince(thought.timestamp) / (24 * 3600)
            score += max(0, 1.0 - (daysSinceThought / 30.0)) * 0.2
            
            // Content relevance
            let thoughtText = thought.content.lowercased()
            let matchingWords = queryWords.filter { thoughtText.contains($0) }
            score += Double(matchingWords.count) / Double(queryWords.count) * 0.6
            
            // Confidence score
            score += thought.confidence * 0.2
            
            return (thought, score)
        }
        
        return scoredThoughts
            .sorted { $0.score > $1.score }
            .prefix(limit)
            .map { $0.thought }
    }
    
    private func extractThoughts(from response: AgentResponse) -> [InductiveThought] {
        // Simple thought extraction - in a real implementation, this could use NLP
        let sentences = response.content.components(separatedBy: ". ")
        let category = response.agentType.thoughtCategories.first ?? "general"
        
        return sentences.compactMap { sentence in
            let trimmed = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.count > 10 else { return nil } // Skip very short sentences
            
            return InductiveThought(
                content: trimmed,
                category: category,
                agentType: response.agentType,
                confidence: 0.8
            )
        }
    }
    
    private func maintainMemoryLimits() async {
        // Remove oldest events if over limit
        if storedEvents.count > configuration.maxEventsInMemory {
            let excessCount = storedEvents.count - configuration.maxEventsInMemory
            storedEvents.removeFirst(excessCount)
        }
        
        // Remove oldest thoughts if over limit
        if storedThoughts.count > configuration.maxThoughtsInMemory {
            let excessCount = storedThoughts.count - configuration.maxThoughtsInMemory
            storedThoughts.removeFirst(excessCount)
        }
    }
    
    private func applyForgettingCurve() async {
        let cutoffDate = Date().addingTimeInterval(-30 * 24 * 3600) // 30 days ago
        
        // Apply forgetting curve based on time and importance
        storedEvents = storedEvents.filter { event in
            if event.timestamp < cutoffDate {
                // Apply probabilistic forgetting
                let daysSince = Date().timeIntervalSince(event.timestamp) / (24 * 3600)
                let forgettingProbability = configuration.forgettingCurveDecay * daysSince / 30.0
                return Double.random(in: 0...1) > forgettingProbability
            }
            return true
        }
        
        storedThoughts = storedThoughts.filter { thought in
            if thought.timestamp < cutoffDate {
                let daysSince = Date().timeIntervalSince(thought.timestamp) / (24 * 3600)
                let forgettingProbability = configuration.forgettingCurveDecay * daysSince / 30.0
                let importanceBonus = thought.confidence * 0.3 // High confidence thoughts are more likely to be retained
                return Double.random(in: 0...1) > (forgettingProbability - importanceBonus)
            }
            return true
        }
    }
    
    private func consolidateMemories() async {
        // Consolidate similar thoughts to reduce redundancy
        var consolidatedThoughts: [InductiveThought] = []
        var processedIndices: Set<Int> = []
        
        for (index, thought) in storedThoughts.enumerated() {
            guard !processedIndices.contains(index) else { continue }
            
            var similarThoughts: [InductiveThought] = [thought]
            processedIndices.insert(index)
            
            // Find similar thoughts
            for (otherIndex, otherThought) in storedThoughts.enumerated() {
                guard otherIndex != index && !processedIndices.contains(otherIndex) else { continue }
                
                if areSimilarThoughts(thought, otherThought) {
                    similarThoughts.append(otherThought)
                    processedIndices.insert(otherIndex)
                }
            }
            
            // If we found similar thoughts, consolidate them
            if similarThoughts.count > 1 {
                let consolidatedThought = consolidateThoughts(similarThoughts)
                consolidatedThoughts.append(consolidatedThought)
            } else {
                consolidatedThoughts.append(thought)
            }
        }
        
        storedThoughts = consolidatedThoughts
    }
    
    private func areSimilarThoughts(_ thought1: InductiveThought, _ thought2: InductiveThought) -> Bool {
        // Simple similarity check - could be enhanced with semantic similarity
        guard thought1.category == thought2.category else { return false }
        
        let words1 = Set(thought1.content.lowercased().components(separatedBy: .whitespacesAndNewlines))
        let words2 = Set(thought2.content.lowercased().components(separatedBy: .whitespacesAndNewlines))
        
        let intersection = words1.intersection(words2)
        let union = words1.union(words2)
        
        let similarity = Double(intersection.count) / Double(union.count)
        return similarity >= configuration.thoughtSimilarityThreshold
    }
    
    private func consolidateThoughts(_ thoughts: [InductiveThought]) -> InductiveThought {
        // Create a consolidated thought from multiple similar thoughts
        let combinedContent = thoughts.map { $0.content }.joined(separator: " | ")
        let averageConfidence = thoughts.map { $0.confidence }.reduce(0, +) / Double(thoughts.count)
        let mostRecentTimestamp = thoughts.map { $0.timestamp }.max() ?? Date()
        
        return InductiveThought(
            timestamp: mostRecentTimestamp,
            content: combinedContent,
            category: thoughts.first?.category ?? "general",
            agentType: thoughts.first?.agentType,
            confidence: min(1.0, averageConfidence * 1.1) // Slight boost for consolidated thoughts
        )
    }
    
    private func generateActivitySummary() -> String {
        let recentEvents = storedEvents.filter { 
            Date().timeIntervalSince($0.timestamp) < 24 * 3600 // Last 24 hours
        }
        
        let recentThoughts = storedThoughts.filter {
            Date().timeIntervalSince($0.timestamp) < 24 * 3600
        }
        
        if recentEvents.isEmpty && recentThoughts.isEmpty {
            return "No recent memory activity in the last 24 hours."
        }
        
        var summary = "Recent activity: "
        
        if !recentEvents.isEmpty {
            summary += "\(recentEvents.count) conversation(s) processed"
        }
        
        if !recentThoughts.isEmpty {
            if !recentEvents.isEmpty { summary += ", " }
            summary += "\(recentThoughts.count) insight(s) extracted"
        }
        
        summary += " in the last 24 hours."
        
        return summary
    }
} 