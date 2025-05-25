import Foundation
import EMTiMMemory

// MARK: - Example Integration
// This file demonstrates how to integrate EMTiM Memory into your existing AI mind system

/// Example AI Mind System that integrates EMTiM Memory
@MainActor
class ExampleAIMindSystem {
    
    // MARK: - Properties
    
    private let memorySystem: MemorySystem
    private let configuration: Configuration
    
    // MARK: - Configuration
    
    struct Configuration {
        let maxProcessingTime: TimeInterval
        let enableMemoryEnhancement: Bool
        let memoryRetrievalLimit: Int
        
        static let `default` = Configuration(
            maxProcessingTime: 30.0,
            enableMemoryEnhancement: true,
            memoryRetrievalLimit: 15
        )
    }
    
    // MARK: - Initialization
    
    init(configuration: Configuration = .default) {
        self.configuration = configuration
        
        // Initialize EMTiM Memory system
        self.memorySystem = MemorySystem.production()
        
        print("🧠 AI Mind System initialized with EMTiM Memory")
    }
    
    // MARK: - Main Processing Pipeline
    
    /// Process user input with memory-enhanced agents
    func processInput(
        _ input: String,
        emotionalState: [String: Double] = [:]
    ) async throws -> IntegratedResponse {
        
        print("\n🔄 Processing input with memory enhancement")
        print("📝 User input: \"\(input)\"")
        
        // Step 1: Build conversation context
        let conversationContext = ConversationContext(
            recentExchanges: [], // In real implementation, get from your chat history
            totalExchanges: 0,
            timeSpan: nil
        )
        
        // Step 2: Process each agent with memory context
        var agentResponses: [AgentResponse] = []
        
        // Process Cortex with memory
        let cortexMemoryContext = await memorySystem.getMemoryContext(
            for: .cortex,
            query: input,
            maxTokens: 2000
        )
        let cortexResponse = try await processCortexWithMemory(
            input,
            memoryContext: cortexMemoryContext
        )
        agentResponses.append(cortexResponse)
        
        // Process Seer with memory
        let seerMemoryContext = await memorySystem.getMemoryContext(
            for: .seer,
            query: input,
            maxTokens: 2000
        )
        let seerResponse = try await processSeerWithMemory(
            input,
            cortexResponse: cortexResponse.content,
            memoryContext: seerMemoryContext
        )
        agentResponses.append(seerResponse)
        
        // Process Oracle with memory
        let oracleMemoryContext = await memorySystem.getMemoryContext(
            for: .oracle,
            query: input,
            maxTokens: 2000
        )
        let oracleResponse = try await processOracleWithMemory(
            input,
            seerResponse: seerResponse.content,
            memoryContext: oracleMemoryContext
        )
        agentResponses.append(oracleResponse)
        
        // Step 3: Integrate responses
        let integratedContent = try await integrateResponses(agentResponses)
        
        // Step 4: Store in memory system
        let episodicEvent = try await memorySystem.processInput(
            input,
            systemResponse: integratedContent,
            agentResponses: agentResponses,
            emotionalState: emotionalState,
            context: conversationContext
        )
        
        // Step 5: Get memory insights
        let memoryInsights = memorySystem.getMemoryInsights()
        
        // Step 6: Create integrated response
        let response = IntegratedResponse(
            content: integratedContent,
            agentResponses: agentResponses,
            emotionalState: formatEmotionalState(emotionalState),
            memoryInsights: memoryInsights,
            episodicEvent: episodicEvent
        )
        
        print("✅ Processing complete with \(agentResponses.count) agent responses")
        return response
    }
    
    // MARK: - Memory-Enhanced Agent Processing
    
    private func processCortexWithMemory(
        _ input: String,
        memoryContext: MemoryContext
    ) async throws -> AgentResponse {
        
        let memoryInsights = formatMemoryInsights(memoryContext)
        
        // In a real implementation, this would call your AI service (OpenAI, etc.)
        let prompt = """
        You are the Cortex agent, responsible for emotional processing and basic meaning analysis.
        
        Current user input: \(input)
        
        Memory Context:
        \(memoryInsights)
        
        Analyze the emotional content and basic meaning of the input, considering both the immediate input and relevant memories.
        """
        
        // Simulate AI response (replace with actual AI service call)
        let content = await simulateAIResponse(prompt: prompt, agentType: .cortex)
        
        return AgentResponse(
            agentType: .cortex,
            content: content,
            temperature: 0.7
        )
    }
    
    private func processSeerWithMemory(
        _ input: String,
        cortexResponse: String,
        memoryContext: MemoryContext
    ) async throws -> AgentResponse {
        
        let memoryInsights = formatMemoryInsights(memoryContext)
        
        let prompt = """
        You are the Seer agent, focused on pattern recognition and prediction.
        
        Current user input: \(input)
        Cortex analysis: \(cortexResponse)
        
        Memory Context:
        \(memoryInsights)
        
        Look for patterns across current input and stored memories. Identify trends and make predictions.
        """
        
        let content = await simulateAIResponse(prompt: prompt, agentType: .seer)
        
        return AgentResponse(
            agentType: .seer,
            content: content,
            temperature: 0.4
        )
    }
    
    private func processOracleWithMemory(
        _ input: String,
        seerResponse: String,
        memoryContext: MemoryContext
    ) async throws -> AgentResponse {
        
        let memoryInsights = formatMemoryInsights(memoryContext)
        
        let prompt = """
        You are the Oracle agent, responsible for strategic planning and probability analysis.
        
        Current user input: \(input)
        Seer insights: \(seerResponse)
        
        Memory Context:
        \(memoryInsights)
        
        Use both current insights and historical patterns from memory to develop strategic recommendations.
        """
        
        let content = await simulateAIResponse(prompt: prompt, agentType: .oracle)
        
        return AgentResponse(
            agentType: .oracle,
            content: content,
            temperature: 0.3
        )
    }
    
    // MARK: - Helper Methods
    
    private func formatMemoryInsights(_ memoryContext: MemoryContext) -> String {
        var insights = ""
        
        if !memoryContext.relevantThoughts.isEmpty {
            insights += "Relevant Thoughts:\n"
            for thought in memoryContext.relevantThoughts.prefix(3) {
                insights += "- \(thought.content)\n"
            }
        }
        
        if !memoryContext.relevantEvents.isEmpty {
            insights += "\nRecent Events:\n"
            for event in memoryContext.relevantEvents.prefix(2) {
                insights += "- User: \(event.userInput)\n- System: \(event.systemResponse)\n"
            }
        }
        
        return insights.isEmpty ? "No relevant memories found." : insights
    }
    
    private func integrateResponses(_ responses: [AgentResponse]) async throws -> String {
        let responseMap = responses.reduce(into: [String: String]()) { result, response in
            result[response.agentType.rawValue] = response.content
        }
        
        // In a real implementation, this would use AI to integrate responses
        let prompt = """
        Integrate these agent responses into a coherent, thoughtful response:
        
        \(responseMap.map { "\($0.key): \($0.value)" }.joined(separator: "\n\n"))
        
        Create a unified response that synthesizes the key insights from each agent.
        """
        
        return await simulateAIResponse(prompt: prompt, agentType: .cortex)
    }
    
    private func formatEmotionalState(_ emotionalState: [String: Double]) -> String {
        if emotionalState.isEmpty {
            return "Neutral emotional state"
        }
        
        let emotions = emotionalState.map { "\($0.key): \(String(format: "%.1f", $0.value * 100))%" }
        return "Emotional state: " + emotions.joined(separator: ", ")
    }
    
    // MARK: - AI Service Simulation
    
    private func simulateAIResponse(prompt: String, agentType: AgentType) async -> String {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Return simulated response based on agent type
        switch agentType {
        case .cortex:
            return "I sense curiosity and engagement in your question. The emotional undertone suggests genuine interest in learning."
        case .seer:
            return "This pattern of questioning indicates a learning mindset. I predict follow-up questions about implementation details."
        case .oracle:
            return "Strategic recommendation: Provide comprehensive yet accessible information, building foundation for deeper exploration."
        case .house:
            return "Implementation consideration: Structure response with clear examples and practical applications."
        case .prudence:
            return "Risk assessment: Ensure accuracy and avoid overwhelming with too much technical detail."
        case .dayDream:
            return "Creative connection: This reminds me of how knowledge builds like layers in a pearl, each question adding depth."
        case .conscience:
            return "Ethical consideration: Maintain honesty about limitations while encouraging continued learning."
        }
    }
    
    // MARK: - Memory Analytics
    
    func getMemoryInsights() async -> MemoryInsights {
        return await memorySystem.getMemoryInsights()
    }
    
    func performMemoryMaintenance() async {
        await memorySystem.performMemoryMaintenance()
    }
}

// MARK: - Usage Example

/// Example of how to use the integrated system
func exampleUsage() async {
    let aiSystem = ExampleAIMindSystem()
    
    do {
        // Process a user question
        let response = try await aiSystem.processInput(
            "How does machine learning work?",
            emotionalState: ["curiosity": 0.8, "analytical": 0.6]
        )
        
        print("System Response: \(response.content)")
        print("Memory Insights: \(response.memoryInsights?.recentActivitySummary ?? "None")")
        
        // Get memory analytics
        let insights = await aiSystem.getMemoryInsights()
        print("Total memories: \(insights.totalEvents) events, \(insights.totalThoughts) thoughts")
        
        // Perform maintenance
        await aiSystem.performMemoryMaintenance()
        
    } catch {
        print("Error: \(error)")
    }
}

// MARK: - Integration Notes

/*
 Integration Steps for Your Existing AI System:
 
 1. Add EMTiM Memory Package:
    - Add to Package.swift dependencies
    - Import EMTiMMemory in your files
 
 2. Initialize Memory System:
    - Create MemorySystem instance in your main AI class
    - Choose appropriate configuration (development/production/lightweight)
 
 3. Enhance Agent Processing:
    - Get memory context before processing each agent
    - Include memory insights in agent prompts
    - Store agent responses in memory system
 
 4. Memory Maintenance:
    - Schedule periodic memory maintenance
    - Monitor memory utilization through insights
    - Adjust configuration based on usage patterns
 
 5. Analytics and Monitoring:
    - Use getMemoryInsights() for system monitoring
    - Track memory distribution across agents
    - Monitor processing performance
 
 Key Benefits:
 - Agents have access to relevant conversation history
 - System learns from past interactions
 - Memory consolidation prevents information overload
 - Agent-specific memory retrieval improves relevance
 - Configurable forgetting curves maintain system performance
 */ 