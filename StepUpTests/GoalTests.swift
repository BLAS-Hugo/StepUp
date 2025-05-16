import XCTest
@testable import StepUp

final class GoalTests: XCTestCase {
    
    // Test data
    private var distanceGoal: Goal!
    private var stepsGoal: Goal!
    
    override func setUp() {
        super.setUp()
        distanceGoal = Goal(distance: 5000, steps: nil)
        stepsGoal = Goal(distance: nil, steps: 10000)
    }
    
    override func tearDown() {
        distanceGoal = nil
        stepsGoal = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDistanceGoalInitialization() {
        XCTAssertEqual(distanceGoal.distance, 5000)
        XCTAssertNil(distanceGoal.steps)
    }
    
    func testStepsGoalInitialization() {
        XCTAssertNil(stepsGoal.distance)
        XCTAssertEqual(stepsGoal.steps, 10000)
    }
    
    // MARK: - getGoal Tests
    
    func testGetGoalWithDistance() {
        XCTAssertEqual(distanceGoal.getGoal(), 5000)
    }
    
    func testGetGoalWithSteps() {
        XCTAssertEqual(stepsGoal.getGoal(), 10000)
    }
    
    // MARK: - getGoalForDisplay Tests
    
    func testGetGoalForDisplayWithDistance() {
        XCTAssertEqual(distanceGoal.getGoalForDisplay(), "5 KM")
    }
    
    func testGetGoalForDisplayWithSteps() {
        XCTAssertEqual(stepsGoal.getGoalForDisplay(), "10000 steps")
    }
    
    // MARK: - Codable Tests
    
    func testDistanceGoalCodable() {
        do {
            // Test encoding
            let encoder = JSONEncoder()
            let data = try encoder.encode(distanceGoal)
            
            // Test decoding
            let decoder = JSONDecoder()
            let decodedGoal = try decoder.decode(Goal.self, from: data)
            
            // Verify decoded properties
            XCTAssertEqual(decodedGoal.distance, distanceGoal.distance)
            XCTAssertNil(decodedGoal.steps)
        } catch {
            XCTFail("Codable test failed with error: \(error)")
        }
    }
    
    func testStepsGoalCodable() {
        do {
            // Test encoding
            let encoder = JSONEncoder()
            let data = try encoder.encode(stepsGoal)
            
            // Test decoding
            let decoder = JSONDecoder()
            let decodedGoal = try decoder.decode(Goal.self, from: data)
            
            // Verify decoded properties
            XCTAssertNil(decodedGoal.distance)
            XCTAssertEqual(decodedGoal.steps, stepsGoal.steps)
        } catch {
            XCTFail("Codable test failed with error: \(error)")
        }
    }
} 