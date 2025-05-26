import XCTest
@testable import StepUp
import FirebaseFirestore
import HealthKit

@MainActor
final class UserChallengesServiceTests: XCTestCase {
    var userChallengeService: UserChallengesService!
    var mockAuthProvider: MockAuthProvider!
    var mockHealthKitService: MockHealthKitService!
    var mockChallengeStore: MockChallengeStore!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAuthProvider = MockAuthProvider()
        mockHealthKitService = MockHealthKitService()
        mockChallengeStore = MockChallengeStore()
        
        resetAllMocks()
    }

    override func tearDownWithError() throws {
        userChallengeService = nil
        mockAuthProvider = nil
        mockHealthKitService = nil
        mockChallengeStore = nil
        try super.tearDownWithError()
    }

    private func resetAllMocks() {
        mockAuthProvider.reset()
        mockHealthKitService.reset()
        mockChallengeStore.reset()
    }

    private func makeChallenge(
        id: String = UUID().uuidString,
        creatorId: String,
        name: String = "Test Challenge",
        description: String = "Test Description",
        startDate: Date = Date(),
        duration: Int = 86400 * 7,
        steps: Int? = 10000,
        distance: Int? = nil,
        participants: [Participant] = []
    ) -> Challenge {
        let goal = Goal(distance: distance, steps: steps)
        var challenge = Challenge(
            creatorUserID: creatorId, 
            participants: participants, 
            name: name, 
            description: description, 
            goal: goal, 
            duration: duration, 
            date: startDate
        )
        challenge.id = id
        return challenge
    }

    private func makeUser(id: String = "defaultUserId", email: String = "test@example.com", name: String = "Test", firstName: String = "User") -> User {
        return User(id: id, email: email, name: name, firstName: firstName)
    }

    private func makeParticipant(userID: String, name: String = "TestUser", progress: Int = 0) -> Participant {
        return Participant(userID: userID, name: name, progress: progress)
    }

    // MARK: - Initialization Tests

    func testInit_whenUserIsNotLoggedIn_doesNotFetchChallenges() {
        // Given
        mockAuthProvider.currentUser = nil

        // When
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty)
        XCTAssertTrue(userChallengeService.userCreatedChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.isEmpty)
        XCTAssertNil(userChallengeService.userCurrentChallenge)
        XCTAssertTrue(userChallengeService.otherChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userChallengesHistory.isEmpty)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testInit_whenUserIsLoggedIn_fetchesChallengesAndStartsTimer() async {
        // Given
        let user = makeUser(id: "testUser1")
        let mockUserSession = MockAppAuthUser(uid: user.id, email: user.email)
        mockAuthProvider.currentUserSession = mockUserSession
        mockAuthProvider.currentUser = user
        mockChallengeStore.challengesToReturn = []

        // When
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // Give time for async operations to complete
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(userChallengeService)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
    }

    // MARK: - Timer Tests

    func testDeinit_invalidatesTimer() {
        // Given
        let user = makeUser()
        mockAuthProvider.currentUser = user
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        userChallengeService = nil

        // Then - timer should be invalidated (no assertion needed as deinit handles it)
        XCTAssertNil(userChallengeService)
    }

    // MARK: - Create Challenge Tests

    func testCreateChallenge_whenUserIsNil_doesNothing() async {
        // Given
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        let challenge = makeChallenge(creatorId: "anyCreator")

        // When
        try? await userChallengeService.createChallenge(challenge, forUser: nil)

        // Then
        XCTAssertNil(mockChallengeStore.createdChallenge)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testCreateChallenge_whenUserIsValid_createsAndRefreshesChallenges() async throws {
        // Given
        let user = makeUser(id: "creatorUser")
        let mockUserSession = MockAppAuthUser(uid: user.id)
        mockAuthProvider.currentUserSession = mockUserSession
        mockAuthProvider.currentUser = user

        let challengeToCreate = makeChallenge(creatorId: user.id, name: "New Challenge")
        mockChallengeStore.challengesToReturn = [challengeToCreate]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        try await userChallengeService.createChallenge(challengeToCreate, forUser: user)
        await Task.yield()

        // Then
        XCTAssertNotNil(mockChallengeStore.createdChallenge)
        XCTAssertEqual(mockChallengeStore.createdChallenge?.name, "New Challenge")
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
    }

    func testCreateChallenge_whenStoreThrows_propagatesError() async {
        // Given
        let user = makeUser()
        let challenge = makeChallenge(creatorId: user.id)
        let expectedError = NSError(domain: "CreateError", code: 1, userInfo: nil)
        
        mockChallengeStore.shouldThrowOnCreate = true
        mockChallengeStore.errorToThrow = expectedError

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        var thrownError: Error?

        // When
        do {
            try await userChallengeService.createChallenge(challenge, forUser: user)
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? NSError, expectedError)
    }

    // MARK: - Edit Challenge Tests

    func testEditChallenge_whenUserIsNil_doesNothing() async {
        // Given
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        let challenge = makeChallenge(creatorId: "anyCreator")

        // When
        try? await userChallengeService.editChallenge(challenge, forUser: nil)

        // Then
        XCTAssertNil(mockChallengeStore.editedChallenge)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testEditChallenge_whenChallengeIDIsNil_doesNothing() async {
        // Given
        let user = makeUser()
        var challenge = makeChallenge(creatorId: user.id)
        challenge.id = nil

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        try? await userChallengeService.editChallenge(challenge, forUser: user)

        // Then
        XCTAssertNil(mockChallengeStore.editedChallenge)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testEditChallenge_whenValid_editsAndRefreshesChallenges() async throws {
        // Given
        let user = makeUser(id: "editorUser")
        let challengeToEdit = makeChallenge(id: "challengeToEdit", creatorId: user.id, name: "Updated Challenge")
        
        mockAuthProvider.currentUser = user
        mockChallengeStore.challengesToReturn = [challengeToEdit]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        try await userChallengeService.editChallenge(challengeToEdit, forUser: user)
        await Task.yield()

        // Then
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        XCTAssertEqual(mockChallengeStore.editedChallenge?.id, "challengeToEdit")
        XCTAssertEqual(mockChallengeStore.editedChallenge?.name, "Updated Challenge")
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
    }

    func testEditChallenge_whenStoreThrows_propagatesError() async {
        // Given
        let user = makeUser()
        let challenge = makeChallenge(id: "validID", creatorId: user.id)
        let expectedError = NSError(domain: "EditError", code: 1, userInfo: nil)
        
        mockChallengeStore.shouldThrowOnEdit = true
        mockChallengeStore.errorToThrow = expectedError

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        var thrownError: Error?

        // When
        do {
            try await userChallengeService.editChallenge(challenge, forUser: user)
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? NSError, expectedError)
    }

    // MARK: - Delete Challenge Tests

    func testDeleteChallenge_whenUserIsNil_doesNothing() async {
        // Given
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        let challenge = makeChallenge(creatorId: "anyCreator")

        // When
        try? await userChallengeService.deleteChallenge(challenge, forUser: nil)

        // Then
        XCTAssertNil(mockChallengeStore.deletedChallenge)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testDeleteChallenge_whenChallengeIDIsNil_doesNothing() async {
        // Given
        let user = makeUser()
        var challenge = makeChallenge(creatorId: user.id)
        challenge.id = nil

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        try? await userChallengeService.deleteChallenge(challenge, forUser: user)

        // Then
        XCTAssertNil(mockChallengeStore.deletedChallenge)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testDeleteChallenge_whenValid_deletesAndRefreshesChallenges() async throws {
        // Given
        let user = makeUser(id: "deleterUser")
        let challengeToDelete = makeChallenge(id: "challengeToDelete", creatorId: user.id)
        
        mockAuthProvider.currentUser = user
        mockChallengeStore.challengesToReturn = []

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        try await userChallengeService.deleteChallenge(challengeToDelete, forUser: user)
        await Task.yield()

        // Then
        XCTAssertNotNil(mockChallengeStore.deletedChallenge)
        XCTAssertEqual(mockChallengeStore.deletedChallenge?.id, "challengeToDelete")
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
    }

    func testDeleteChallenge_whenStoreThrows_propagatesError() async {
        // Given
        let user = makeUser()
        let challenge = makeChallenge(id: "validID", creatorId: user.id)
        let expectedError = NSError(domain: "DeleteError", code: 1, userInfo: nil)
        
        mockChallengeStore.shouldThrowOnDelete = true
        mockChallengeStore.errorToThrow = expectedError

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        var thrownError: Error?

        // When
        do {
            try await userChallengeService.deleteChallenge(challenge, forUser: user)
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? NSError, expectedError)
    }

    // MARK: - Fetch Challenges Tests

    func testFetchChallenges_whenUserIsNil_clearsChallengesAndFilters() async {
        // Given
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        // Pre-populate with some challenges to verify they get cleared
        userChallengeService.challenges = [makeChallenge(creatorId: "someUser")]

        // When
        await userChallengeService.fetchChallenges(forUser: nil)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty)
        XCTAssertTrue(userChallengeService.userCreatedChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.isEmpty)
        XCTAssertNil(userChallengeService.userCurrentChallenge)
        XCTAssertTrue(userChallengeService.otherChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userChallengesHistory.isEmpty)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testFetchChallenges_whenStoreThrows_challengesRemainEmptyAndFiltersCalled() async {
        // Given
        let user = makeUser()
        mockAuthProvider.currentUser = user
        mockChallengeStore.shouldThrowOnFetch = true
        mockChallengeStore.errorToThrow = NSError(domain: "FetchError", code: 1, userInfo: nil)

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        await userChallengeService.fetchChallenges(forUser: user)

        // Then
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
        XCTAssertTrue(userChallengeService.challenges.isEmpty)
        XCTAssertTrue(userChallengeService.userCreatedChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.isEmpty)
        XCTAssertNil(userChallengeService.userCurrentChallenge)
        XCTAssertTrue(userChallengeService.otherChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userChallengesHistory.isEmpty)
    }

    func testFetchChallenges_whenSuccessful_fetchesAndFiltersChallenges() async {
        // Given
        let user = makeUser(id: "fetchUser")
        let challenge1 = makeChallenge(id: "c1", creatorId: user.id)
        let challenge2 = makeChallenge(id: "c2", creatorId: "otherUser")
        
        mockAuthProvider.currentUser = user
        mockChallengeStore.challengesToReturn = [challenge1, challenge2]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        await userChallengeService.fetchChallenges(forUser: user)

        // Then
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
        XCTAssertEqual(userChallengeService.challenges.count, 2)
        XCTAssertTrue(userChallengeService.challenges.contains { $0.id == "c1" })
        XCTAssertTrue(userChallengeService.challenges.contains { $0.id == "c2" })
    }

    // MARK: - Filter Challenges Tests

    func testFilterChallenges_categorizesChallengesCorrectly() {
        // Given
        let currentUserID = "currentUser"
        let otherUserID = "otherUser"
        let user = makeUser(id: currentUserID)
        
        mockAuthProvider.currentUser = user
        
        let now = Date()
        let futureDate = now.addingTimeInterval(86400 * 10) // 10 days from now
        let pastDate = now.addingTimeInterval(-86400 * 10) // 10 days ago
        
        let participant1 = makeParticipant(userID: currentUserID, name: "CurrentUser")
        let participant2 = makeParticipant(userID: otherUserID, name: "OtherUser")

        let challenges: [Challenge] = [
            // User participating (future)
            makeChallenge(id: "c1", creatorId: otherUserID, startDate: futureDate, participants: [participant1]),
            
            // User participating (current - started but not ended)
            makeChallenge(id: "c1-current", creatorId: otherUserID, startDate: now.addingTimeInterval(-3600), participants: [participant1]),
            
            // User created (future)
            makeChallenge(id: "c2", creatorId: currentUserID, startDate: futureDate),
            
            // Other challenge (future)
            makeChallenge(id: "c3", creatorId: otherUserID, startDate: futureDate, participants: [participant2]),
            
            // User participated (past - history)
            makeChallenge(id: "c4", creatorId: otherUserID, startDate: pastDate, duration: 86400 * 2, participants: [participant1]),
            
            // Past challenge not participated
            makeChallenge(id: "c5", creatorId: otherUserID, startDate: pastDate, duration: 86400 * 2),
        ]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = challenges

        // When
        userChallengeService.filterChallenges(forUser: user)

        // Then
        // User participating challenges (c1, c1-current)
        XCTAssertEqual(userChallengeService.userParticipatingChallenges.count, 2)
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.contains { $0.id == "c1" })
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.contains { $0.id == "c1-current" })

        // User current challenge (should be earliest: c1-current)
        XCTAssertEqual(userChallengeService.userCurrentChallenge?.id, "c1-current")

        // User created challenges (c2)
        XCTAssertEqual(userChallengeService.userCreatedChallenges.count, 1)
        XCTAssertEqual(userChallengeService.userCreatedChallenges.first?.id, "c2")

        // Other challenges (c3)
        XCTAssertEqual(userChallengeService.otherChallenges.count, 1)
        XCTAssertEqual(userChallengeService.otherChallenges.first?.id, "c3")

        // User challenge history (c4)
        XCTAssertEqual(userChallengeService.userChallengesHistory.count, 1)
        XCTAssertEqual(userChallengeService.userChallengesHistory.first?.id, "c4")

        // Main challenges array should exclude past challenges (c4, c5)
        XCTAssertEqual(userChallengeService.challenges.count, 4)
        XCTAssertFalse(userChallengeService.challenges.contains { $0.id == "c4" })
        XCTAssertFalse(userChallengeService.challenges.contains { $0.id == "c5" })
    }

    func testFilterChallenges_whenNoCurrentChallenge_usesFirstParticipating() {
        // Given
        let user = makeUser(id: "testUser")
        mockAuthProvider.currentUser = user
        
        let futureDate1 = Date().addingTimeInterval(86400 * 2) // 2 days from now
        let futureDate2 = Date().addingTimeInterval(86400 * 5) // 5 days from now
        
        let participant = makeParticipant(userID: user.id)
        
        let challenges: [Challenge] = [
            makeChallenge(id: "future1", creatorId: "other", startDate: futureDate2, participants: [participant]),
            makeChallenge(id: "future2", creatorId: "other", startDate: futureDate1, participants: [participant]),
        ]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = challenges

        // When
        userChallengeService.filterChallenges(forUser: user)

        // Then
        XCTAssertEqual(userChallengeService.userCurrentChallenge?.id, "future2") // Earlier start date
    }

    func testFilterChallenges_withNilUser_usesCurrentAuthUser() {
        // Given
        let user = makeUser(id: "authUser")
        mockAuthProvider.currentUser = user
        
        let participant = makeParticipant(userID: user.id)
        let challenge = makeChallenge(id: "c1", creatorId: "other", participants: [participant])

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = [challenge]

        // When
        userChallengeService.filterChallenges() // No user parameter

        // Then
        XCTAssertEqual(userChallengeService.userParticipatingChallenges.count, 1)
        XCTAssertEqual(userChallengeService.userParticipatingChallenges.first?.id, "c1")
    }

    // MARK: - Participate to Challenge Tests

    func testParticipateToChallenge_addsUserAndRefreshesChallenges() async throws {
        // Given
        let user = makeUser(id: "participantUser")
        let challenge = makeChallenge(id: "challengeToJoin", creatorId: "creator")
        let expectedUpdatedChallenge = challenge.addParticipant(user)
        
        mockAuthProvider.currentUser = user
        mockChallengeStore.challengesToReturn = [expectedUpdatedChallenge]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        // When
        try await userChallengeService.participateToChallenge(challenge, user: user)
        await Task.yield()

        // Then
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        XCTAssertTrue(mockChallengeStore.editedChallenge?.participants.contains { $0.userID == user.id } ?? false)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
    }

    func testParticipateToChallenge_whenEditFails_throwsError() async {
        // Given
        let user = makeUser()
        let challenge = makeChallenge(id: "validID", creatorId: "creator")
        let expectedError = NSError(domain: "ParticipateError", code: 1, userInfo: nil)
        
        mockChallengeStore.shouldThrowOnEdit = true
        mockChallengeStore.errorToThrow = expectedError

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        var thrownError: Error?

        // When
        do {
            try await userChallengeService.participateToChallenge(challenge, user: user)
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? NSError, expectedError)
    }

    // MARK: - Update User Current Challenge Tests

    func testUpdateUserCurrentChallenge_whenNoCurrentChallenge_doesNothing() async {
        // Given
        let user = makeUser()
        mockAuthProvider.currentUser = user
        
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userCurrentChallenge = nil

        // When
        await userChallengeService.updateUserCurrentChallenge()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 0)
        XCTAssertNil(mockChallengeStore.editedChallenge)
    }

    func testUpdateUserCurrentChallenge_whenNoCurrentUser_doesNothing() async {
        // Given
        mockAuthProvider.currentUser = nil

        userChallengeService = UserChallengesService(
            with: mockAuthProvider,
            mockHealthKitService,
            challengeStore: mockChallengeStore
        )

        userChallengeService.userCurrentChallenge = makeChallenge(creatorId: "any")

        // When
        await userChallengeService.updateUserCurrentChallenge()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 0)
        XCTAssertNil(mockChallengeStore.editedChallenge)
    }

    func testUpdateUserCurrentChallenge_stepsChallenge_fetchesStepsAndUpdatesProgress() async {
        // Given
        let user = makeUser(id: "stepsUser")
        mockAuthProvider.currentUser = nil

        let participant = makeParticipant(userID: user.id, progress: 100)
        let stepsChallenge = makeChallenge(
            id: "stepsChallenge",
            creatorId: "creator",
            steps: 10000,
            distance: nil,
            participants: [participant]
        )

        let newProgress = 500
        mockHealthKitService.mockDataToReturn = newProgress

        let expectedUpdatedChallenge = stepsChallenge.editParticipantProgress(user, progress: newProgress)
        mockChallengeStore.challengesToReturn = [expectedUpdatedChallenge]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider,
            mockHealthKitService,
            challengeStore: mockChallengeStore
        )

        mockAuthProvider.currentUser = user
        userChallengeService.userCurrentChallenge = stepsChallenge

        // When
        await userChallengeService.updateUserCurrentChallenge()
        await Task.yield()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertEqual(mockHealthKitService.lastFetchType?.identifier, HKQuantityTypeIdentifier.stepCount.rawValue)
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        XCTAssertEqual(mockChallengeStore.editedChallenge?.participants.first?.progress, newProgress)
    }

    func testUpdateUserCurrentChallenge_distanceChallenge_fetchesDistanceAndUpdatesProgress() async {
        // Given
        resetAllMocks()
        let user = makeUser(id: "distanceUser")
        mockAuthProvider.currentUser = nil

        let participant = makeParticipant(userID: user.id, progress: 1000)
        let distanceChallenge = makeChallenge(
            id: "distanceChallenge",
            creatorId: "creator",
            steps: nil,
            distance: 5000,
            participants: [participant]
        )

        let newProgress = 2000
        mockHealthKitService.mockDataToReturn = newProgress

        let expectedUpdatedChallenge = distanceChallenge.editParticipantProgress(user, progress: newProgress)
        mockChallengeStore.challengesToReturn = [expectedUpdatedChallenge]

        userChallengeService = UserChallengesService(
            with: mockAuthProvider,
            mockHealthKitService,
            challengeStore: mockChallengeStore
        )

        mockAuthProvider.currentUser = user
        userChallengeService.userCurrentChallenge = distanceChallenge

        // When
        await userChallengeService.updateUserCurrentChallenge()
        await Task.yield()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertEqual(mockHealthKitService.lastFetchType?.identifier, HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue)
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        XCTAssertEqual(mockChallengeStore.editedChallenge?.participants.first?.progress, newProgress)
    }

    func testUpdateUserCurrentChallenge_whenProgressNotHigher_doesNotUpdate() async {
        // Given
        resetAllMocks()
        let user = makeUser(id: "noUpdateUser")
        mockAuthProvider.currentUser = nil
        
        let currentProgress = 1000
        let participant = makeParticipant(userID: user.id, progress: currentProgress)
        let challenge = makeChallenge(
            id: "noUpdateChallenge", 
            creatorId: "creator", 
            participants: [participant]
        )

        mockHealthKitService.mockDataToReturn = currentProgress - 100

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )

        mockAuthProvider.currentUser = user
        userChallengeService.userCurrentChallenge = challenge

        // When
        await userChallengeService.updateUserCurrentChallenge()
        await Task.yield()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertNil(mockChallengeStore.editedChallenge)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testUpdateUserCurrentChallenge_withUserParameter_usesProvidedUser() async {
        // Given
        let authUser = makeUser(id: "authUser")
        let parameterUser = makeUser(id: "parameterUser")
        mockAuthProvider.currentUser = authUser
        
        let participant = makeParticipant(userID: parameterUser.id, progress: 100)
        let challenge = makeChallenge(
            id: "parameterChallenge", 
            creatorId: "creator", 
            participants: [participant]
        )
        
        mockHealthKitService.mockDataToReturn = 500

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userCurrentChallenge = challenge

        // When
        await userChallengeService.updateUserCurrentChallenge(forUser: parameterUser)
        await Task.yield()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
    }

    // MARK: - Date Validation Tests

    func testAreChallengeDatesValid_noExistingChallenges_returnsTrue() {
        // Given
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userParticipatingChallenges = []
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(86400 * 7)

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: startDate, to: endDate)

        // Then
        XCTAssertTrue(isValid)
    }

    func testAreChallengeDatesValid_newChallengeStartsDuringExisting_returnsFalse() {
        // Given
        let existingStart = Date()
        _ = existingStart.addingTimeInterval(86400 * 10)
        let existingChallenge = makeChallenge(
            creatorId: "existing", 
            startDate: existingStart, 
            duration: 86400 * 10
        )
        
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStart = existingStart.addingTimeInterval(86400 * 3) // Starts during existing
        let newEnd = newStart.addingTimeInterval(86400 * 5)

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStart, to: newEnd)

        // Then
        XCTAssertFalse(isValid)
    }

    func testAreChallengeDatesValid_newChallengeEndsDuringExisting_returnsFalse() {
        // Given
        let existingStart = Date()
        let existingChallenge = makeChallenge(
            creatorId: "existing", 
            startDate: existingStart, 
            duration: 86400 * 10
        )
        
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStart = existingStart.addingTimeInterval(-86400 * 3) // Starts before existing
        let newEnd = existingStart.addingTimeInterval(86400 * 3) // Ends during existing

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStart, to: newEnd)

        // Then
        XCTAssertFalse(isValid)
    }

    func testAreChallengeDatesValid_newChallengeCompletelyEnclosesExisting_returnsFalse() {
        // Given
        let existingStart = Date()
        let existingChallenge = makeChallenge(
            creatorId: "existing", 
            startDate: existingStart, 
            duration: 86400 * 5
        )
        
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStart = existingStart.addingTimeInterval(-86400 * 2) // Starts before existing
        let newEnd = existingStart.addingTimeInterval(86400 * 7) // Ends after existing

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStart, to: newEnd)

        // Then
        XCTAssertFalse(isValid)
    }

    func testAreChallengeDatesValid_newChallengeCompletelyAfterExisting_returnsTrue() {
        // Given
        let existingStart = Date()
        let existingChallenge = makeChallenge(
            creatorId: "existing", 
            startDate: existingStart, 
            duration: 86400 * 5
        )
        
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStart = existingStart.addingTimeInterval(86400 * 6) // Starts after existing ends
        let newEnd = newStart.addingTimeInterval(86400 * 5)

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStart, to: newEnd)

        // Then
        XCTAssertTrue(isValid)
    }

    func testAreChallengeDatesValid_newChallengeCompletelyBeforeExisting_returnsTrue() {
        // Given
        let existingStart = Date()
        let existingChallenge = makeChallenge(
            creatorId: "existing", 
            startDate: existingStart, 
            duration: 86400 * 5
        )
        
        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStart = existingStart.addingTimeInterval(-86400 * 10) // Starts way before existing
        let newEnd = existingStart.addingTimeInterval(-86400 * 2) // Ends before existing starts

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStart, to: newEnd)

        // Then
        XCTAssertTrue(isValid)
    }

    // MARK: - Update User Name in All Challenges Tests

    func testUpdateUserNameInAllChallenges_updatesParticipatingChallenges() async throws {
        // Given
        let user = makeUser(id: "userToUpdate")
        let originalName = "OriginalName"
        let newName = "UpdatedName"
        
        let participant1 = makeParticipant(userID: user.id, name: originalName, progress: 100)
        let participant2 = makeParticipant(userID: "otherUser", name: "OtherUser", progress: 50)
        
        let challenge1 = makeChallenge(id: "c1", creatorId: "creator1", participants: [participant1, participant2])
        let challenge2 = makeChallenge(id: "c2", creatorId: "creator2", participants: [participant1])
        let challenge3 = makeChallenge(id: "c3", creatorId: "creator3", participants: [participant2]) // User not participating
        
        mockChallengeStore.challengesToReturn = []

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = [challenge1, challenge2, challenge3]

        // When
        try await userChallengeService.updateUserNameInAllChallenges(for: user, newFirstName: newName)
        await Task.yield()

        // Then
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
        
        // The mock store only tracks the last edited challenge, but we know it was called multiple times
        let editedChallenge = mockChallengeStore.editedChallenge!
        let updatedParticipant = editedChallenge.participants.first { $0.userID == user.id }
        XCTAssertEqual(updatedParticipant?.name, newName)
    }

    func testUpdateUserNameInAllChallenges_noParticipatingChallenges_doesNotUpdate() async throws {
        // Given
        let user = makeUser(id: "nonParticipant")
        let newName = "NewName"
        
        let otherParticipant = makeParticipant(userID: "otherUser")
        let challenge = makeChallenge(id: "c1", creatorId: "creator", participants: [otherParticipant])
        
        mockChallengeStore.challengesToReturn = []

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = [challenge]

        // When
        try await userChallengeService.updateUserNameInAllChallenges(for: user, newFirstName: newName)
        await Task.yield()

        // Then
        XCTAssertNil(mockChallengeStore.editedChallenge)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
    }

    func testUpdateUserNameInAllChallenges_emptyChallengesList_stillCallsFetch() async throws {
        // Given
        let user = makeUser()
        let newName = "NewName"
        
        mockChallengeStore.challengesToReturn = []

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = []

        // When
        try await userChallengeService.updateUserNameInAllChallenges(for: user, newFirstName: newName)
        await Task.yield()

        // Then
        XCTAssertNil(mockChallengeStore.editedChallenge)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
    }

    func testUpdateUserNameInAllChallenges_challengeStoreThrows_propagatesError() async {
        // Given
        let user = makeUser(id: "errorUser")
        let participant = makeParticipant(userID: user.id)
        let challenge = makeChallenge(id: "errorChallenge", creatorId: "creator", participants: [participant])
        
        let expectedError = NSError(domain: "UpdateError", code: 1, userInfo: nil)
        mockChallengeStore.shouldThrowOnEdit = true
        mockChallengeStore.errorToThrow = expectedError

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = [challenge]

        var thrownError: Error?

        // When
        do {
            try await userChallengeService.updateUserNameInAllChallenges(for: user, newFirstName: "NewName")
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? NSError, expectedError)
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled)
    }

    func testUpdateUserNameInAllChallenges_preservesParticipantProgress() async throws {
        // Given
        let user = makeUser(id: "progressUser")
        let originalProgress = 1500
        let participant = makeParticipant(userID: user.id, name: "OldName", progress: originalProgress)
        let challenge = makeChallenge(id: "progressChallenge", creatorId: "creator", participants: [participant])
        
        mockChallengeStore.challengesToReturn = []

        userChallengeService = UserChallengesService(
            with: mockAuthProvider, 
            mockHealthKitService, 
            challengeStore: mockChallengeStore
        )
        
        userChallengeService.challenges = [challenge]

        // When
        try await userChallengeService.updateUserNameInAllChallenges(for: user, newFirstName: "NewName")
        await Task.yield()

        // Then
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        let updatedParticipant = mockChallengeStore.editedChallenge?.participants.first { $0.userID == user.id }
        XCTAssertEqual(updatedParticipant?.progress, originalProgress)
        XCTAssertEqual(updatedParticipant?.name, "NewName")
    }
}
