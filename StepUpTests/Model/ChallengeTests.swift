import XCTest
@testable import StepUp

final class ChallengeTests: XCTestCase {
    private var sampleUser: User!
    private var sampleParticipant: Participant!
    private var sampleGoal: Goal!
    private var sampleChallenge: Challenge!
    private let testDate = Date()

    override func setUp() {
        super.setUp()
        sampleUser = User(id: "user1", email: "test@example.com", name: "Test User", firstName: "Test")
        sampleParticipant = Participant(userID: "user1", name: "Test", progress: 50)
        sampleGoal = Goal(distance: 5000, steps: nil)
        sampleChallenge = Challenge(
            creatorUserID: "creator1",
            participants: [sampleParticipant],
            name: "Test Challenge",
            description: "This is a test challenge",
            goal: sampleGoal,
            duration: 604800, // 7 days in seconds
            date: testDate,
            id: "challenge1"
        )
    }

    override func tearDown() {
        sampleUser = nil
        sampleParticipant = nil
        sampleGoal = nil
        sampleChallenge = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(sampleChallenge.creatorUserID, "creator1")
        XCTAssertEqual(sampleChallenge.participants.count, 1)
        XCTAssertEqual(sampleChallenge.name, "Test Challenge")
        XCTAssertEqual(sampleChallenge.description, "This is a test challenge")
        XCTAssertEqual(sampleChallenge.goal.distance, 5000)
        XCTAssertEqual(sampleChallenge.duration, 604800)
        XCTAssertEqual(sampleChallenge.date, testDate)
        XCTAssertEqual(sampleChallenge.id, "challenge1")
    }

    func testGetParticipantProgress() {
        XCTAssertEqual(sampleChallenge.getParticipantProgress(userID: "user1"), 50)
    }

    func testEndDate() {
        let expectedEndDate = testDate.addingTimeInterval(TimeInterval(604800))
        XCTAssertEqual(sampleChallenge.endDate, expectedEndDate)
    }

    func testAddParticipant() {
        let newUser = User(id: "user2", email: "test2@example.com", name: "Test User 2", firstName: "Test2")
        let updatedChallenge = sampleChallenge.addParticipant(newUser)

        XCTAssertEqual(updatedChallenge.participants.count, 2)
        XCTAssertEqual(updatedChallenge.participants[1].userID, "user2")
        XCTAssertEqual(updatedChallenge.participants[1].name, "Test2")
        XCTAssertEqual(updatedChallenge.participants[1].progress, 0)

        XCTAssertEqual(sampleChallenge.participants.count, 1)
    }

    func testEditParticipantProgress() {
        let updatedChallenge = sampleChallenge.editParticipantProgress(sampleUser, progress: 75)

        XCTAssertEqual(updatedChallenge.getParticipantProgress(userID: "user1"), 75)

        XCTAssertEqual(sampleChallenge.getParticipantProgress(userID: "user1"), 50)
    }

    func testCodable() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(sampleChallenge)

            let decoder = JSONDecoder()
            let decodedChallenge = try decoder.decode(Challenge.self, from: data)

            XCTAssertEqual(decodedChallenge.creatorUserID, sampleChallenge.creatorUserID)
            XCTAssertEqual(decodedChallenge.name, sampleChallenge.name)
            XCTAssertEqual(decodedChallenge.description, sampleChallenge.description)
            XCTAssertEqual(decodedChallenge.duration, sampleChallenge.duration)
            XCTAssertEqual(decodedChallenge.id, sampleChallenge.id)

            XCTAssertEqual(decodedChallenge.participants.count, sampleChallenge.participants.count)
            XCTAssertEqual(decodedChallenge.participants[0].userID, sampleChallenge.participants[0].userID)
            XCTAssertEqual(decodedChallenge.participants[0].progress, sampleChallenge.participants[0].progress)

            XCTAssertEqual(decodedChallenge.goal.distance, sampleChallenge.goal.distance)
            XCTAssertEqual(decodedChallenge.goal.steps, sampleChallenge.goal.steps)
        } catch {
            XCTFail("Codable test failed with error: \(error)")
        }
    }
}
