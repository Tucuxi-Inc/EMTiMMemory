import Foundation

/// Represents the different types of cognitive agents in the EMTiM system
public enum AgentType: String, CaseIterable, Codable, Identifiable, Comparable {
    case cortex = "Cortex"
    case seer = "Seer"
    case oracle = "Oracle"
    case house = "House"
    case prudence = "Prudence"
    case dayDream = "Day-Dream"
    case conscience = "Conscience"
    
    public var id: String { rawValue }
    
    public static func < (lhs: AgentType, rhs: AgentType) -> Bool {
        let order: [AgentType] = [
            .cortex,
            .seer,
            .oracle,
            .house,
            .prudence,
            .dayDream,
            .conscience
        ]
        
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        
        return lhsIndex < rhsIndex
    }
    
    public var name: String { rawValue }
    
    public var icon: String {
        switch self {
        case .cortex: return "🧠"
        case .seer: return "👁️"
        case .oracle: return "🔮"
        case .house: return "🏛️"
        case .prudence: return "⚖️"
        case .dayDream: return "💭"
        case .conscience: return "🤔"
        }
    }
    
    public var description: String {
        switch self {
        case .cortex: return "Analytical and creative processing capacity"
        case .seer: return "Pattern recognition and intuitive understanding"
        case .oracle: return "Strategic thinking and future planning"
        case .house: return "Implementation and practical execution"
        case .prudence: return "Risk assessment and caution level"
        case .dayDream: return "Creative associations and memory exploration"
        case .conscience: return "Ethical consideration and moral awareness"
        }
    }
    
    public var defaultTemperature: Double {
        switch self {
        case .cortex: return 0.7
        case .seer: return 0.4
        case .oracle: return 0.3
        case .house: return 0.4
        case .prudence: return 0.3
        case .dayDream: return 0.8
        case .conscience: return 0.6
        }
    }
    
    /// Thought categories for memory system
    public var thoughtCategories: [String] {
        switch self {
        case .cortex:
            return ["emotional", "meaning", "interpretation", "context"]
        case .seer:
            return ["pattern", "prediction", "trend", "future", "insight"]
        case .oracle:
            return ["strategy", "planning", "probability", "decision", "outcome"]
        case .house:
            return ["implementation", "practical", "resource", "constraint", "execution"]
        case .prudence:
            return ["risk", "caution", "safety", "boundary", "limitation"]
        case .dayDream:
            return ["creative", "association", "metaphor", "connection", "inspiration"]
        case .conscience:
            return ["ethical", "moral", "responsibility", "value", "principle"]
        }
    }
    
    /// Agent specialization for memory retrieval
    public var memorySpecialization: String {
        switch self {
        case .cortex:
            return "Emotional processing and basic meaning analysis"
        case .seer:
            return "Pattern recognition and predictive analysis"
        case .oracle:
            return "Strategic planning and probability assessment"
        case .house:
            return "Practical implementation and resource management"
        case .prudence:
            return "Risk assessment and constraint identification"
        case .dayDream:
            return "Creative connections and associative thinking"
        case .conscience:
            return "Ethical evaluation and moral guidance"
        }
    }
} 