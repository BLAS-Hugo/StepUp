import XCTest
@testable import StepUp

final class ObjectivesViewModelTests: XCTestCase {
    
    // Test data
    private var viewModel: ObjectivesViewModel!
    private let testUserDefaults = UserDefaults(suiteName: "test_objectives")!
    
    override func setUp() {
        super.setUp()
        // Clear any existing values
        testUserDefaults.removeObject(forKey: "steps")
        testUserDefaults.removeObject(forKey: "distance")
        
        // Set initial test values
        testUserDefaults.set(5000, forKey: "steps")
        testUserDefaults.set(2000, forKey: "distance")
        
        // Initialize with our test defaults
        viewModel = ObjectivesViewModel(numberOfSteps: 0, distance: 0)
        viewModel.defaults = testUserDefaults
        
        // Fetch data from our test defaults
        viewModel.fetchData()
    }
    
    override func tearDown() {
        // Clean up
        testUserDefaults.removeObject(forKey: "steps")
        testUserDefaults.removeObject(forKey: "distance")
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Initialization and Fetch Tests
    
    func testFetchData() {
        // Verify initial fetch from setUp worked correctly
        XCTAssertEqual(viewModel.numberOfSteps, 5000)
        XCTAssertEqual(viewModel.distance, 2000)
        
        // Change values in UserDefaults and fetch again
        testUserDefaults.set(7500, forKey: "steps")
        testUserDefaults.set(3500, forKey: "distance")
        viewModel.fetchData()
        
        // Verify the new values were fetched
        XCTAssertEqual(viewModel.numberOfSteps, 7500)
        XCTAssertEqual(viewModel.distance, 3500)
    }
    
    // MARK: - Save Data Tests
    
    func testSaveData() {
        // Save new values
        viewModel.saveData(for: "steps", data: 10000)
        viewModel.saveData(for: "distance", data: 5000)
        
        // Verify the values were stored in UserDefaults
        XCTAssertEqual(testUserDefaults.integer(forKey: "steps"), 10000)
        XCTAssertEqual(testUserDefaults.integer(forKey: "distance"), 5000)
        
        // Verify the viewModel properties were not directly changed by saveData
        // (since saveData only updates UserDefaults, not the @Published properties)
        XCTAssertEqual(viewModel.numberOfSteps, 5000)
        XCTAssertEqual(viewModel.distance, 2000)
        
        // After fetching, the properties should be updated
        viewModel.fetchData()
        XCTAssertEqual(viewModel.numberOfSteps, 10000)
        XCTAssertEqual(viewModel.distance, 5000)
    }
    
    // MARK: - Increment Data Tests
    
    func testIncrementSteps() {
        // Test normal increment
        viewModel.incrementData(for: "steps")
        XCTAssertEqual(viewModel.numberOfSteps, 5500) // 5000 + 500
        
        // Test behavior near upper boundary
        // Current implementation adds 500 if steps < 50000 (doesn't cap at 50000)
        viewModel.numberOfSteps = 49800
        viewModel.incrementData(for: "steps")
        XCTAssertEqual(viewModel.numberOfSteps, 50300) // 49800 + 500, no capping
        
        // Steps already >= 50000, should not increment
        viewModel.numberOfSteps = 50300
        viewModel.incrementData(for: "steps")
        XCTAssertEqual(viewModel.numberOfSteps, 50300) // No change
    }
    
    func testIncrementDistance() {
        // Test normal increment
        viewModel.incrementData(for: "distance")
        XCTAssertEqual(viewModel.distance, 2500) // 2000 + 500
        
        // Test behavior near upper boundary
        // Current implementation adds 500 if distance < 50000 (doesn't cap at 50000)
        viewModel.distance = 49800
        viewModel.incrementData(for: "distance")
        XCTAssertEqual(viewModel.distance, 50300) // 49800 + 500, no capping
        
        // Distance already >= 50000, should not increment
        viewModel.distance = 50300
        viewModel.incrementData(for: "distance")
        XCTAssertEqual(viewModel.distance, 50300) // No change
    }
    
    // MARK: - Decrement Data Tests
    
    func testDecrementSteps() {
        // Test normal decrement
        viewModel.decrementData(for: "steps")
        XCTAssertEqual(viewModel.numberOfSteps, 4500) // 5000 - 500
        
        // Test behavior near lower boundary
        // Current implementation subtracts 500 if steps > 0 (doesn't floor at 0)
        viewModel.numberOfSteps = 300
        viewModel.decrementData(for: "steps")
        XCTAssertEqual(viewModel.numberOfSteps, -200) // 300 - 500, no flooring
        
        // Steps already <= 0, should not decrement
        viewModel.numberOfSteps = -200
        viewModel.decrementData(for: "steps")
        XCTAssertEqual(viewModel.numberOfSteps, -200) // No change
    }
    
    func testDecrementDistance() {
        // Test normal decrement
        viewModel.decrementData(for: "distance")
        XCTAssertEqual(viewModel.distance, 1500) // 2000 - 500
        
        // Test behavior near lower boundary
        // Current implementation subtracts 500 if distance > 0 (doesn't floor at 0)
        viewModel.distance = 300
        viewModel.decrementData(for: "distance")
        XCTAssertEqual(viewModel.distance, -200) // 300 - 500, no flooring
        
        // Distance already <= 0, should not decrement
        viewModel.distance = -200
        viewModel.decrementData(for: "distance")
        XCTAssertEqual(viewModel.distance, -200) // No change
    }
    
    // MARK: - Invalid Key Tests
    
    func testInvalidKeyIncrement() {
        // Store original values
        let originalSteps = viewModel.numberOfSteps
        let originalDistance = viewModel.distance
        
        // Increment with invalid key
        viewModel.incrementData(for: "invalidKey")
        
        // Verify no change
        XCTAssertEqual(viewModel.numberOfSteps, originalSteps)
        XCTAssertEqual(viewModel.distance, originalDistance)
    }
    
    func testInvalidKeyDecrement() {
        // Store original values
        let originalSteps = viewModel.numberOfSteps
        let originalDistance = viewModel.distance
        
        // Decrement with invalid key
        viewModel.decrementData(for: "invalidKey")
        
        // Verify no change
        XCTAssertEqual(viewModel.numberOfSteps, originalSteps)
        XCTAssertEqual(viewModel.distance, originalDistance)
    }
} 
