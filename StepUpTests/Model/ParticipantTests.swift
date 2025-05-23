import XCTest
@testable import StepUp

final class ParticipantTests: XCTestCase {
    private var sampleParticipant: Participant!
    
    override func setUp() {
        super.setUp()
        sampleParticipant = Participant(userID: "user1", name: "Test User", progress: 75)
    }
    
    override func tearDown() {
        sampleParticipant = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(sampleParticipant.userID, "user1")
        XCTAssertEqual(sampleParticipant.name, "Test User")
        XCTAssertEqual(sampleParticipant.progress, 75)
    }

    func testCodable() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(sampleParticipant)
            
            let decoder = JSONDecoder()
            let decodedParticipant = try decoder.decode(Participant.self, from: data)
            
            XCTAssertEqual(decodedParticipant.userID, sampleParticipant.userID)
            XCTAssertEqual(decodedParticipant.name, sampleParticipant.name)
            XCTAssertEqual(decodedParticipant.progress, sampleParticipant.progress)
        } catch {
            XCTFail("Codable test failed with error: \(error)")
        }
    }

    func testEquatable() {
        let identicalParticipant = Participant(userID: "user1", name: "Test User", progress: 75)
        XCTAssertEqual(sampleParticipant, identicalParticipant)
        
        let differentIDParticipant = Participant(userID: "user2", name: "Test User", progress: 75)
        XCTAssertNotEqual(sampleParticipant, differentIDParticipant)
        
        let differentNameParticipant = Participant(userID: "user1", name: "Different Name", progress: 75)
        XCTAssertNotEqual(sampleParticipant, differentNameParticipant)
        
        let differentProgressParticipant = Participant(userID: "user1", name: "Test User", progress: 50)
        XCTAssertNotEqual(sampleParticipant, differentProgressParticipant)
    }
} 
