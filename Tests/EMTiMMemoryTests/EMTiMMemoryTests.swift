import XCTest
@testable import EMTiMMemory

final class EMTiMMemoryTests: XCTestCase {
    
    var memorySystem: MemorySystem!
    
    override func setUp() {
        super.setUp()
        memorySystem = MemorySystem.development()
    }
    
    override func tearDown() {
        memorySystem = nil
        super.tearDown()
    }
    
    // MARK: - Basic Functionality Tests
    
    func testMemorySystemInitialization() async {
        XCTAssertNotNil(memorySystem)
        
        let insights = await memorySystem.getMemoryInsights()
        XCTAssertEqual(insights.totalEvents, 0)
        XCTAssertEqual(insights.totalThoughts, 0)
        XCTAssertEqual(insights.memoryUtilization, 0.0)
    }
    
    func testAgentTypeProperties() {
        let cortex = AgentType.cortex
        
        XCTAssertEqual(cortex.rawValue, "Cortex")
        XCTAssertEqual(cortex.defaultTemperature, 0.7)
        XCTAssertTrue(cortex.thoughtCategories.contains("emotional"))
        XCTAssertFalse(cortex.memorySpecialization.isEmpty)
    }
    
    func testMemoryContextCreation() async {
        let context = await memorySystem.getMemoryContext(
            for: .cortex,
            query: "test query",
            maxTokens: 1000
        )
        
        XCTAssertNotNil(context)
        XCTAssertEqual(context.relevantThoughts.count, 0) // Empty initially
        XCTAssertEqual(context.relevantEvents.count, 0) // Empty initially
    }
    
    // MARK: - Memory Storage Tests
    
    func testMemoryStorage() async throws {
        let agentResponses = [
            AgentResponse(agentType: .cortex, content: "This is a thoughtful response about emotions."),
            AgentResponse(agentType: .seer, content: "I see patterns emerging in this conversation.")
        ]
        
        let conversationContext = ConversationContext(recentExchanges: [])
        
        let event = try await memorySystem.processInput(
            "How are you feeling today?",
            systemResponse: "I'm doing well, thank you for asking.",
            agentResponses: agentResponses,
            emotionalState: ["curiosity": 0.8, "empathy": 0.7],
            context: conversationContext
        )
        
        XCTAssertEqual(event.userInput, "How are you feeling today?")
        XCTAssertEqual(event.systemResponse, "I'm doing well, thank you for asking.")
        XCTAssertEqual(event.agentResponses.count, 2)
        XCTAssertEqual(event.emotionalContext["curiosity"], 0.8)
        
        // Check that memory insights reflect the stored data
        let insights = await memorySystem.getMemoryInsights()
        XCTAssertEqual(insights.totalEvents, 1)
        XCTAssertGreaterThan(insights.totalThoughts, 0)
    }
    
    // MARK: - Memory Retrieval Tests
    
    func testMemoryRetrieval() async throws {
        // First, store some memories
        let agentResponses = [
            AgentResponse(agentType: .cortex, content: "The user seems curious about emotional processing."),
            AgentResponse(agentType: .seer, content: "This pattern of questioning suggests learning intent.")
        ]
        
        _ = try await memorySystem.processInput(
            "How do emotions work?",
            systemResponse: "Emotions are complex psychological states.",
            agentResponses: agentResponses,
            emotionalState: [:],
            context: ConversationContext()
        )
        
        // Now retrieve memories
        let context = await memorySystem.getMemoryContext(
            for: .cortex,
            query: "emotions",
            maxTokens: 1000
        )
        
        XCTAssertGreaterThan(context.relevantEvents.count, 0)
        XCTAssertGreaterThan(context.relevantThoughts.count, 0)
        
        // Check that retrieved thoughts are relevant to cortex
        for thought in context.relevantThoughts {
            XCTAssertTrue(
                thought.agentType == .cortex || 
                AgentType.cortex.thoughtCategories.contains(thought.category)
            )
        }
    }
    
    // MARK: - Memory Maintenance Tests
    
    func testMemoryMaintenance() async throws {
        // Store multiple memories
        for i in 0..<5 {
            let agentResponses = [
                AgentResponse(agentType: .cortex, content: "Response \(i) about emotions.")
            ]
            
            _ = try await memorySystem.processInput(
                "Question \(i)",
                systemResponse: "Answer \(i)",
                agentResponses: agentResponses,
                emotionalState: [:],
                context: ConversationContext()
            )
        }
        
        let insightsBefore = await memorySystem.getMemoryInsights()
        XCTAssertEqual(insightsBefore.totalEvents, 5)
        
        // Perform maintenance
        await memorySystem.performMemoryMaintenance()
        
        let insightsAfter = await memorySystem.getMemoryInsights()
        // Memory should still be intact for recent memories
        XCTAssertGreaterThan(insightsAfter.totalEvents, 0)
    }
    
    // MARK: - Configuration Tests
    
    func testDifferentConfigurations() async {
        let lightweightSystem = MemorySystem.lightweight()
        let productionSystem = MemorySystem.production()
        
        XCTAssertNotNil(lightweightSystem)
        XCTAssertNotNil(productionSystem)
        
        // Test that different configurations produce different systems
        let lightweightInsights = await lightweightSystem.getMemoryInsights()
        let productionInsights = await productionSystem.getMemoryInsights()
        
        XCTAssertEqual(lightweightInsights.totalEvents, 0)
        XCTAssertEqual(productionInsights.totalEvents, 0)
    }
    
    // MARK: - Data Structure Tests
    
    func testInductiveThoughtCreation() {
        let thought = InductiveThought(
            content: "This is a test thought",
            category: "test",
            agentType: .cortex,
            confidence: 0.9
        )
        
        XCTAssertEqual(thought.content, "This is a test thought")
        XCTAssertEqual(thought.category, "test")
        XCTAssertEqual(thought.agentType, .cortex)
        XCTAssertEqual(thought.confidence, 0.9)
        XCTAssertNotNil(thought.id)
    }
    
    func testEpisodicEventCreation() {
        let agentResponses = [
            AgentResponse(agentType: .cortex, content: "Test response")
        ]
        
        let event = EpisodicEvent(
            userInput: "Test input",
            systemResponse: "Test response",
            emotionalContext: ["joy": 0.8],
            agentResponses: agentResponses
        )
        
        XCTAssertEqual(event.userInput, "Test input")
        XCTAssertEqual(event.systemResponse, "Test response")
        XCTAssertEqual(event.emotionalContext["joy"], 0.8)
        XCTAssertEqual(event.agentResponses.count, 1)
    }
    
    func testConversationContextCreation() {
        let exchanges = [
            ConversationExchange(
                userInput: "Hello",
                systemResponse: "Hi there!",
                emotionalTone: "friendly"
            )
        ]
        
        let context = ConversationContext(
            recentExchanges: exchanges,
            totalExchanges: 10,
            timeSpan: 3600
        )
        
        XCTAssertEqual(context.recentExchanges.count, 1)
        XCTAssertEqual(context.totalExchanges, 10)
        XCTAssertEqual(context.timeSpan, 3600)
    }
    
    // MARK: - Package Info Tests
    
    func testPackageInfo() {
        let packageInfo = EMTiMMemory.packageInfo
        
        XCTAssertEqual(packageInfo.name, "EMTiMMemory")
        XCTAssertEqual(packageInfo.version, "1.0.0")
        XCTAssertFalse(packageInfo.description.isEmpty)
        XCTAssertFalse(packageInfo.author.isEmpty)
        XCTAssertEqual(packageInfo.license, "MIT")
    }
} 