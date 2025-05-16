import XCTest
@testable import StepUp

final class UserTests: XCTestCase {
    
    // Test data
    private var sampleUser: User!
    
    override func setUp() {
        super.setUp()
        sampleUser = User(id: "user123", email: "test@example.com", name: "Test User", firstName: "Test")
    }
    
    override func tearDown() {
        sampleUser = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        XCTAssertEqual(sampleUser.id, "user123")
        XCTAssertEqual(sampleUser.email, "test@example.com")
        XCTAssertEqual(sampleUser.name, "Test User")
        XCTAssertEqual(sampleUser.firstName, "Test")
    }
    
    // MARK: - Codable Tests
    
    func testCodable() {
        do {
            // Test encoding
            let encoder = JSONEncoder()
            let data = try encoder.encode(sampleUser)
            
            // Test decoding
            let decoder = JSONDecoder()
            let decodedUser = try decoder.decode(User.self, from: data)
            
            // Verify decoded properties
            XCTAssertEqual(decodedUser.id, sampleUser.id)
            XCTAssertEqual(decodedUser.email, sampleUser.email)
            XCTAssertEqual(decodedUser.name, sampleUser.name)
            XCTAssertEqual(decodedUser.firstName, sampleUser.firstName)
        } catch {
            XCTFail("Codable test failed with error: \(error)")
        }
    }
} 