import XCTest
@testable import StepUp

final class GoalTests: XCTestCase {
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

    func testDistanceGoalInitialization() {
        XCTAssertEqual(distanceGoal.distance, 5000)
        XCTAssertNil(distanceGoal.steps)
    }
    
    func testStepsGoalInitialization() {
        XCTAssertNil(stepsGoal.distance)
        XCTAssertEqual(stepsGoal.steps, 10000)
    }

    func testGetGoalWithDistance() {
        XCTAssertEqual(distanceGoal.getGoal(), 5000)
    }
    
    func testGetGoalWithSteps() {
        XCTAssertEqual(stepsGoal.getGoal(), 10000)
    }

    func testGetGoalForDisplayWithDistance() {
        XCTAssertEqual(distanceGoal.getGoalForDisplay(), "5 KM")
    }
    
    func testGetGoalForDisplayWithSteps() {
        XCTAssertEqual(stepsGoal.getGoalForDisplay(), "10000 steps")
    }

    func testDistanceGoalCodable() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(distanceGoal)
            
            let decoder = JSONDecoder()
            let decodedGoal = try decoder.decode(Goal.self, from: data)
            
            XCTAssertEqual(decodedGoal.distance, distanceGoal.distance)
            XCTAssertNil(decodedGoal.steps)
        } catch {
            XCTFail("Codable test failed with error: \(error)")
        }
    }
    
    func testStepsGoalCodable() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stepsGoal)
            
            let decoder = JSONDecoder()
            let decodedGoal = try decoder.decode(Goal.self, from: data)
            
            XCTAssertNil(decodedGoal.distance)
            XCTAssertEqual(decodedGoal.steps, stepsGoal.steps)
        } catch {
            XCTFail("Codable test failed with error: \(error)")
        }
    }
} 
