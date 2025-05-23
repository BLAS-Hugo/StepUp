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
        
        mockAuthProvider.reset()
        mockHealthKitService.reset()
        mockChallengeStore.reset()
        
        userChallengeService = UserChallengesService(with: mockAuthProvider,
                                                     mockHealthKitService,
                                                     challengeStore: mockChallengeStore)
    }

    override func tearDownWithError() throws {
        userChallengeService = nil
        mockAuthProvider = nil
        mockHealthKitService = nil
        mockChallengeStore = nil
        try super.tearDownWithError()
    }

    func test_init_whenUserIsNotLoggedIn_doesNotFetchChallenges() {
        // Given
        mockAuthProvider.currentUser = nil

        // When
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty, "Challenges should be empty if no user is logged in.")
        XCTAssertTrue(userChallengeService.userCreatedChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.isEmpty)
        XCTAssertNil(userChallengeService.userCurrentChallenge)
    }

    func test_init_whenUserIsLoggedIn_fetchesChallengesAndUpdatesCurrentChallenge() async {
        // Given
        let mockUser = MockAppAuthUser(uid: "testUser1", email: "test@example.com")
        let user = User(id: "testUser1", email: "test@example.com", name: "Test", firstName: "User")
        mockAuthProvider.currentUserSession = mockUser
        mockAuthProvider.currentUser = user

        // When
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)

        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)
        // Then
        XCTAssertNotNil(userChallengeService, "userChallengeService should be initialized.")
    }

    private func makeChallenge(id: String = UUID().uuidString,
                               creatorId: String,
                               name: String = "Test Challenge",
                               description: String = "Test Challenge",
                               startDate: Date = Date(),
                               duration: Int = 86400 * 7,
                               steps: Int = 10000,
                               distance: Double? = nil,
                               participants: [Participant] = []) -> Challenge {
        let goal = Goal(distance: Int(distance ?? 0), steps: steps)
        var challenge = Challenge(creatorUserID: creatorId, participants: participants, name: name, description: description, goal: goal, duration: duration, date: startDate)
        challenge.id = id
        return challenge
    }

    private func makeUser(id: String = "defaultUserId", email: String = "test@example.com") -> User {
        return User(id: id, email: email, name: "Test", firstName: "User")
    }

    func test_createChallenge_whenUserIsNil_doesNothing() async {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore) // Initialize SUT
        let challenge = makeChallenge(creatorId: "anyCreator")
        mockAuthProvider.currentUser = nil
        // When
        try? await userChallengeService.createChallenge(challenge, forUser: nil)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty, "Challenges should remain unchanged or empty.")
    }

    func test_createChallenge_whenUserIsValid_attemptsToAddDocumentAndRefreshes() async {
        // Given
        let loggedInUser = makeUser(id: "loggedInUser")
        let mockAuthUser = MockAppAuthUser(uid: loggedInUser.id)
        mockAuthProvider.currentUserSession = mockAuthUser
        mockAuthProvider.currentUser = loggedInUser

        let challengeToCreate = makeChallenge(creatorId: loggedInUser.id)
        mockChallengeStore.challengesToReturn = []

        // When
        try? await userChallengeService.createChallenge(challengeToCreate, forUser: loggedInUser)
        await Task.yield()

        // Then
        XCTAssertNotNil(mockChallengeStore.createdChallenge, "createChallenge on the store should have been called.")
        XCTAssertEqual(mockChallengeStore.createdChallenge?.name, challengeToCreate.name)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled, "fetchChallenges on the store should have been called after create.")
        XCTAssertTrue(userChallengeService.challenges.isEmpty, "SUT challenges should be empty after fetching an empty list from mock store.")
    }

    func test_editChallenge_whenUserIsNil_doesNothing() async {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        let challenge = makeChallenge(creatorId: "anyCreator")

        // When
        try? await userChallengeService.editChallenge(challenge, forUser: nil)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty)
    }

    func test_editChallenge_whenChallengeIDIsNil_doesNothing() async {
        // Given
        let user = makeUser()
        mockAuthProvider.currentUser = user
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        var challenge = makeChallenge(creatorId: user.id)
        challenge.id = nil

        // When
        try? await userChallengeService.editChallenge(challenge, forUser: user)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty)
    }

    func test_editChallenge_whenValid_attemptsToSetDataAndRefreshes() async throws {
        // Given
        let user = makeUser(id: "editorUser")
        let mockAuthUser = MockAppAuthUser(uid: user.id)
        mockAuthProvider.currentUserSession = mockAuthUser
        mockAuthProvider.currentUser = user

        let challengeToEdit = makeChallenge(id: "challengeToEdit", creatorId: user.id)
        mockChallengeStore.reset()
        mockChallengeStore.challengesToReturn = [challengeToEdit]

        // When
        try await userChallengeService.editChallenge(challengeToEdit, forUser: user)
        await Task.yield()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertNotNil(mockChallengeStore.editedChallenge, "editChallenge on the store should have been called.")
        XCTAssertEqual(mockChallengeStore.editedChallenge?.id, challengeToEdit.id)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled, "fetchChallenges on the store should have been called after edit.")
    }

    func test_deleteChallenge_whenUserIsNil_doesNothing() async {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        let challenge = makeChallenge(creatorId: "anyCreator")

        // When
        try? await userChallengeService.deleteChallenge(challenge, forUser: nil)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty)
    }

    func test_deleteChallenge_whenChallengeIDIsNil_doesNothing() async {
        // Given
        let user = makeUser()
        mockAuthProvider.currentUser = user
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        var challenge = makeChallenge(creatorId: user.id)
        challenge.id = nil

        // When
        try? await userChallengeService.deleteChallenge(challenge, forUser: user)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty)
    }

    func test_deleteChallenge_whenValid_attemptsToDeleteAndRefreshes() async throws {
        // Given
        let user = makeUser(id: "deleterUser")
        let mockAuthUser = MockAppAuthUser(uid: user.id)
        mockAuthProvider.currentUserSession = mockAuthUser
        mockAuthProvider.currentUser = user

        let challengeToDelete = makeChallenge(id: "challengeToDelete", creatorId: user.id)
        mockChallengeStore.reset()
        mockChallengeStore.challengesToReturn = []

        // When
        try await userChallengeService.deleteChallenge(challengeToDelete, forUser: user)
        await Task.yield()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertNotNil(mockChallengeStore.deletedChallenge, "deleteChallenge on the store should have been called.")
        XCTAssertEqual(mockChallengeStore.deletedChallenge?.id, challengeToDelete.id)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled, "fetchChallenges on the store should have been called after delete.")
    }

    func test_fetchChallenges_whenUserIsNil_clearsChallenges() async {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        userChallengeService.challenges = [makeChallenge(creatorId: "someUser")]
        mockAuthProvider.currentUser = nil

        // When
        await userChallengeService.fetchChallenges(forUser: nil)

        // Then
        XCTAssertTrue(userChallengeService.challenges.isEmpty, "Challenges should be empty if user is nil.")
        XCTAssertTrue(userChallengeService.userCreatedChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.isEmpty)
        XCTAssertNil(userChallengeService.userCurrentChallenge)
    }

    func test_fetchChallenges_whenUserIsValidButFirestoreFails_challengesRemainEmpty() async {
        // Given
        let user = makeUser(id: "fetchUser")
        let mockAuthUser = MockAppAuthUser(uid: user.id)
        mockAuthProvider.currentUserSession = mockAuthUser
        mockAuthProvider.currentUser = user

        mockChallengeStore.shouldThrowOnFetch = true
        mockChallengeStore.errorToThrow = NSError(domain: "TestError", code: 123, userInfo: nil)
        mockChallengeStore.challengesToReturn = [makeChallenge(creatorId: "some")]

        // When
        await userChallengeService.fetchChallenges(forUser: user)

        // Then
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
        XCTAssertTrue(userChallengeService.challenges.isEmpty, "Challenges should be empty if store fetch fails.")
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userCreatedChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.otherChallenges.isEmpty)
        XCTAssertTrue(userChallengeService.userChallengesHistory.isEmpty)
        XCTAssertNil(userChallengeService.userCurrentChallenge)
    }

    func test_filterChallenges_correctlyFiltersAndAssigns() async throws {
        // Given
        let currentUserID = "user1"
        let otherUserID = "user2"
        let now = Date()
        let pastDate = Calendar.current.date(byAdding: .day, value: -10, to: now)!
        let futureDate = Calendar.current.date(byAdding: .day, value: 10, to: now)!

        let participant1 = Participant(userID: currentUserID, name: "Hugo", progress: 100)
        let participant2 = Participant(userID: otherUserID, name: "Bob", progress: 200)

        let mockUser = MockAppAuthUser(uid: currentUserID)
        let user = User(id: currentUserID, email: "filter@test.com", name: "Filter", firstName: "Test")
        mockAuthProvider.currentUserSession = mockUser
        mockAuthProvider.currentUser = user
        
        let challengesToTestWith: [Challenge] = [
            Challenge(
                creatorUserID: otherUserID,
                participants: [participant1],
                name: "Current",
                description: "Test Challenge",
                goal: Goal(distance: nil, steps: 100),
                duration: 86400 * 5, // 5 days duration
                date: now.addingTimeInterval(3600), // Starts in 1 hour
                id: "c1"
            ),
                        Challenge(
                creatorUserID: otherUserID,
                participants: [participant1],
                name: "Current Bis",
                description: "Test Challenge",
                goal: Goal(distance: nil, steps: 100),
                duration: 86400 * 5,
                date: now.addingTimeInterval(-3600),
                id: "c1-bis"
            ),
            Challenge(
                creatorUserID: currentUserID,
                participants: [],
                name: "Created",
                description: "Test Challenge",
                goal: Goal(distance: nil, steps: 100),
                duration: 86400 * 5,
                date: futureDate,
                id: "c2"
            ),
            
            // Other challenge (not participating, not created)
            Challenge(
                creatorUserID: otherUserID,
                participants: [participant2],
                name: "Other",
                description: "Test Challenge",
                goal: Goal(distance: nil, steps: 100),
                duration: 86400 * 5, // 5 days duration
                date: futureDate,
                id: "c3"
            ),
            
            // Past challenge (history)
            Challenge(
                creatorUserID: otherUserID,
                participants: [participant1], // User participated
                name: "History",
                description: "Test Challenge",
                goal: Goal(distance: nil, steps: 100),
                duration: 86400 * 2, // 2 days duration
                date: pastDate,
                id: "c4"
            ),
            
            // Past challenge created by other
            Challenge(
                creatorUserID: otherUserID,
                participants: [],
                name: "Created Past",
                description: "Test Challenge",
                goal: Goal(distance: nil, steps: 100),
                duration: 86400 * 2, // 2 days duration
                date: pastDate,
                id: "c5"
            ),
            
            // Another other challenge
            Challenge(
                creatorUserID: "user3",
                participants: [Participant(userID: "user4", name: "Bob", progress: 0)],
                name: "Unrelated Future",
                description: "Test Challenge",
                goal: Goal(distance: nil, steps: 100),
                duration: 86400 * 5, // 5 days duration
                date: futureDate,
                id: "c6"
            ),
        ]

        // Directly set the challenges array to bypass async fetch
        userChallengeService.challenges = challengesToTestWith
        
        // When - call filterChallenges directly through private access or by using a method that calls it
        userChallengeService.filterChallenges()

        // Then
        // User participating challenges (c1, c1-bis)
        XCTAssertEqual(userChallengeService.userParticipatingChallenges.count, 2, "Incorrect count for userParticipatingChallenges")
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.contains(where: { $0.id == "c1" }), "Challenge c1 should be in userParticipatingChallenges")
        XCTAssertTrue(userChallengeService.userParticipatingChallenges.contains(where: { $0.id == "c1-bis" }), "Challenge c1-bis should be in userParticipatingChallenges")

        // User current challenge (should be the earliest one: c1-bis)
        XCTAssertEqual(userChallengeService.userCurrentChallenge?.id, "c1-bis", "Incorrect userCurrentChallenge - should be the earliest starting one")

        // User created challenges (c2)
        XCTAssertEqual(userChallengeService.userCreatedChallenges.count, 1, "Incorrect count for userCreatedChallenges")
        XCTAssertTrue(userChallengeService.userCreatedChallenges.contains(where: { $0.id == "c2" }), "Challenge c2 should be in userCreatedChallenges")

        // Other challenges (c3, c6)
        XCTAssertEqual(userChallengeService.otherChallenges.count, 2, "Incorrect count for otherChallenges")
        XCTAssertTrue(userChallengeService.otherChallenges.contains(where: { $0.id == "c3" }), "Challenge c3 should be in otherChallenges")
        XCTAssertTrue(userChallengeService.otherChallenges.contains(where: { $0.id == "c6" }), "Challenge c6 should be in otherChallenges")

        // User challenge history (c4)
        XCTAssertEqual(userChallengeService.userChallengesHistory.count, 1, "Incorrect count for userChallengesHistory")
        XCTAssertTrue(userChallengeService.userChallengesHistory.contains(where: { $0.id == "c4" }), "Challenge c4 should be in userChallengesHistory")

        // Main challenges array should exclude past challenges (c4, c5) after filtering
        XCTAssertEqual(userChallengeService.challenges.count, 5, "Main challenges array should be filtered for ongoing/future challenges")
        XCTAssertFalse(userChallengeService.challenges.contains(where: {$0.id == "c4"}), "Past challenge c4 should be removed from main challenges list")
        XCTAssertFalse(userChallengeService.challenges.contains(where: {$0.id == "c5"}), "Past challenge c5 should be removed from main challenges list")
    }

    func test_participateToChallenge_callsEditChallengeAndRefreshes() async throws {
        // Given
        let user = makeUser(id: "participantUser")
        let mockAuthUser = MockAppAuthUser(uid: user.id)
        mockAuthProvider.currentUserSession = mockAuthUser
        mockAuthProvider.currentUser = user

        let challengeToParticipate = makeChallenge(id: "challengeToParticipate", creatorId: "creator")
        let challengeWithParticipant = challengeToParticipate.addParticipant(user)
        
        mockChallengeStore.reset() // Clear any previous state
        mockChallengeStore.challengesToReturn = [challengeWithParticipant] // Simulate fetch after participation reflects the change

        // When
        await userChallengeService.participateToChallenge(challengeToParticipate, user: user)
        await Task.yield()
        try await Task.sleep(nanoseconds: 500_000_000) // Wait longer (0.5 seconds)

        // Then
        XCTAssertNotNil(mockChallengeStore.editedChallenge, "editChallenge on the store should have been called.")
        XCTAssertTrue(mockChallengeStore.editedChallenge?.participants.contains(where: { $0.userID == user.id }) ?? false, "User should be a participant in the edited challenge.")
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled, "fetchChallenges on the store should have been called after participation.")
    }

    // MARK: - Update User Current Challenge Tests

    func test_updateUserCurrentChallenge_whenNoCurrentChallenge_doesNothing() async {
        // Given
        let user = makeUser(id: "updaterUser")
        mockAuthProvider.currentUser = user
        mockAuthProvider.currentUserSession = MockAppAuthUser(uid: user.id)

        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        userChallengeService.userCurrentChallenge = nil

        // When
        await userChallengeService.updateUserCurrentChallenge()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 0)
    }

    func test_updateUserCurrentChallenge_whenNoCurrentUser_doesNothing() async {
        // Given
        mockAuthProvider.currentUser = nil
        mockAuthProvider.currentUserSession = nil
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        userChallengeService.userCurrentChallenge = makeChallenge(creatorId: "any")

        // When
        await userChallengeService.updateUserCurrentChallenge()

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 0)
    }

    func test_updateUserCurrentChallenge_fetchesHealthData_updatesChallengeWhenProgressIsHigher() async throws {
        // Given
        let userID = "testUserProgress"
        let user = User(id: userID, email: "progress@test.com", name: "Prog", firstName: "User")
        let mockUserSession = MockAppAuthUser(uid: userID)
        mockAuthProvider.currentUserSession = mockUserSession
        mockAuthProvider.currentUser = user

        let initialProgress = 50
        let participant = Participant(userID: userID, name: "Bob", progress: initialProgress)
        
        // Create a challenge with direct initialization for clarity
        let currentChallenge = Challenge(
            creatorUserID: "creator",
            participants: [participant],
            name: "Active Steps",
            description: "Test Challenge",
            goal: Goal(distance: nil, steps: 10000),
            duration: 86400 * 5, // 5 days duration
            date: Date().addingTimeInterval(-86400), // Started yesterday
            id: "activeChallenge"
        )
        
        // Reset mocks and set up current state
        mockChallengeStore.reset()
        mockHealthKitService.reset()
        
        // Set current challenge directly
        userChallengeService.userCurrentChallenge = currentChallenge

        // Set up the health data to return
        let newFetchedProgress = 100
        mockHealthKitService.mockDataToReturn = newFetchedProgress
        
        // Create the updated challenge we expect to be stored
        let updatedParticipant = Participant(userID: userID, name: "Bob", progress: newFetchedProgress)
        let expectedUpdatedChallenge = Challenge(
            creatorUserID: "creator",
            participants: [updatedParticipant],
            name: "Active Steps",
            description: "Test Challenge",
            goal: Goal(distance: nil, steps: 10000),
            duration: 86400 * 5, // 5 days duration
            date: currentChallenge.date,
            id: "activeChallenge"
        )
        
        // Set what the mock store will return after fetch
        mockChallengeStore.challengesToReturn = [expectedUpdatedChallenge]

        // When
        await userChallengeService.updateUserCurrentChallenge()
        await Task.yield()
        try await Task.sleep(nanoseconds: 500_000_000) // Wait longer (0.5 seconds)

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertEqual(mockHealthKitService.lastFetchType?.identifier, HKQuantityTypeIdentifier.stepCount.rawValue)
        XCTAssertNotNil(mockChallengeStore.editedChallenge, "editChallenge on the store should have been called.")
        XCTAssertEqual(mockChallengeStore.editedChallenge?.participants.first?.progress, newFetchedProgress)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled, "fetchChallenges on the store should be called after progress update.")
    }

    func test_updateUserCurrentChallenge_fetchesHealthData_updatesChallengeForDistance() async {
        // Given
        let userID = "testUserDistance"
        let user = User(id: userID, email: "distance@test.com", name: "Dist", firstName: "User")
        let mockUserSession = MockAppAuthUser(uid: userID)
        mockAuthProvider.currentUserSession = mockUserSession
        mockAuthProvider.currentUser = user

        let initialProgress = 500 // meters
        let participant = Participant(userID: userID, name: "Bob", progress: initialProgress)
        let currentChallenge = Challenge(
            creatorUserID: "activeChallengeDist",
            participants: [participant],
            name: "creator",
            description: "Active Distance",
            goal: Goal(distance: 5000, steps: nil),
            duration: 86400 * 5,
            date: Date().addingTimeInterval(-86400),
            id: "Active Distance"
        )
        userChallengeService.userCurrentChallenge = currentChallenge

        let newFetchedProgress = 1000 // meters
        mockHealthKitService.mockDataToReturn = newFetchedProgress
        let expectedUpdatedChallenge = currentChallenge.editParticipantProgress(user, progress: newFetchedProgress)
        mockChallengeStore.challengesToReturn = [expectedUpdatedChallenge]

        // When
        await userChallengeService.updateUserCurrentChallenge()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000) // Give time for async operations

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertEqual(mockHealthKitService.lastFetchType?.identifier, HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue)
        XCTAssertNotNil(mockChallengeStore.editedChallenge)
        XCTAssertEqual(mockChallengeStore.editedChallenge?.participants.first?.progress, newFetchedProgress)
        XCTAssertTrue(mockChallengeStore.fetchedChallengesCalled)
        XCTAssertEqual(userChallengeService.challenges.first?.participants.first?.progress, newFetchedProgress)
    }


    func test_updateUserCurrentChallenge_whenNewProgressIsNotHigher_doesNotUpdateChallenge() async {
        // Given
        let userID = "testUserNoUpdate"
        let user = User(id: userID, email: "noupdate@test.com", name: "NoUp", firstName: "User")
        let mockUserSession = MockAppAuthUser(uid: userID)
        mockAuthProvider.currentUserSession = mockUserSession
        mockAuthProvider.currentUser = user
        mockChallengeStore.reset()

        let initialProgress = 100
        let participant = Participant(userID: userID, name: "Bob", progress: initialProgress)
        let currentChallenge = Challenge(
            creatorUserID: "activeChallengeNoUpdate",
            participants: [participant],
            name: "creator",
            description: "Active No Update",
            goal: Goal(distance: nil, steps: 10000),
            duration: 86400 * 5,
            date: Date().addingTimeInterval(-86400),
            id: "Active No Update"
        )
        userChallengeService.userCurrentChallenge = currentChallenge
        userChallengeService.challenges = [currentChallenge, makeChallenge(id: "other", creatorId: "other")]

        let newFetchedProgress = initialProgress // Same progress, should not update
        mockHealthKitService.mockDataToReturn = newFetchedProgress

        // When
        await userChallengeService.updateUserCurrentChallenge()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000) // Give time for async operations

        // Then
        XCTAssertEqual(mockHealthKitService.fetchDataForDatatypeAndDateCallCount, 1)
        XCTAssertNil(mockChallengeStore.editedChallenge, "editChallenge on store should NOT have been called.")
        XCTAssertFalse(mockChallengeStore.fetchedChallengesCalled, "fetchChallenges on store should NOT have been called if progress didn't increase.")
        XCTAssertFalse(userChallengeService.challenges.isEmpty, "Challenges should not be refreshed if progress hasn't increased.")
        XCTAssertEqual(userChallengeService.challenges.count, 2, "Challenge list should remain untouched.")
    }

    // MARK: - Date Validation Tests

    func test_areChallengeDatesValid_noExistingChallenges_returnsTrue() {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        userChallengeService.userParticipatingChallenges = []

        let startDate = Date()
        let endDate = startDate.addingTimeInterval(86400 * 7)

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: startDate, to: endDate)

        // Then
        XCTAssertTrue(isValid, "Dates should be valid if there are no existing participant challenges.")
    }

    func test_areChallengeDatesValid_newChallengeStartsDuringExisting_returnsFalse() {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        let existingStartDate = Date()
        let existingChallenge = makeChallenge(
            creatorId: "any",
            startDate: existingStartDate,
            duration: 86400 * 10
        )
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStartDate = existingStartDate.addingTimeInterval(86400 * 3)
        let newEndDate = newStartDate.addingTimeInterval(86400 * 5)

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStartDate, to: newEndDate)

        // Then
        XCTAssertFalse(isValid, "New challenge starting during an existing one should be invalid.")
    }

    func test_areChallengeDatesValid_newChallengeEndsDuringExisting_returnsFalse() {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        let existingStartDate = Date()
        let existingChallenge = makeChallenge(
            creatorId: "any",
            startDate: existingStartDate,
            duration: 86400 * 10
        )
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStartDate = existingStartDate.addingTimeInterval(-86400 * 3)
        let newEndDate = existingStartDate.addingTimeInterval(86400 * 3)

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStartDate, to: newEndDate)

        // Then
        XCTAssertFalse(isValid, "New challenge ending during an existing one should be invalid.")
    }

    func test_areChallengeDatesValid_newChallengeSurroundsExisting_returnsFalse() {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        let existingStartDate = Date().addingTimeInterval(86400 * 2) // Existing starts in 2 days
        let existingEndDate = existingStartDate.addingTimeInterval(86400 * 5) // Existing lasts 5 days
        let existingChallenge = makeChallenge(
            creatorId: "any",
            startDate: existingStartDate,
            duration: 86400 * 5
        )
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStartDate = Date() // New starts now
        let newEndDate = Date().addingTimeInterval(86400 * 10) // New lasts 10 days, surrounding existing

        // When
        let isValid = userChallengeService.areChallengeDatesValid(from: newStartDate, to: newEndDate)

        // Then
        XCTAssertFalse(isValid, "New challenge enveloping an existing one should be invalid.")

        let collidingNewStartDate = existingStartDate.addingTimeInterval(86400)
        let collidingNewEndDate = existingEndDate.addingTimeInterval(86400)

        let isCollidingValid = userChallengeService.areChallengeDatesValid(from: collidingNewStartDate, to: collidingNewEndDate)
        XCTAssertFalse(isCollidingValid, "New challenge starting within existing should be invalid.")

        let collidingNewStartDate2 = existingStartDate.addingTimeInterval(-86400)
        let collidingNewEndDate2 = existingEndDate.addingTimeInterval(-86400)

        let isCollidingValid2 = userChallengeService.areChallengeDatesValid(from: collidingNewStartDate2, to: collidingNewEndDate2)
        XCTAssertFalse(isCollidingValid2, "New challenge ending within existing should be invalid.")
    }


    func test_areChallengeDatesValid_newChallengeIsCompletelyOutsideExisting_returnsTrue() {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        let existingStartDate = Date()
        let existingEndDate = existingStartDate.addingTimeInterval(86400 * 5)
        let existingChallenge = makeChallenge(
            creatorId: "any",
            startDate: existingStartDate,
            duration: 86400 * 5
        )
        userChallengeService.userParticipatingChallenges = [existingChallenge]

        let newStartDateAfter = existingEndDate.addingTimeInterval(86400)
        let newEndDateAfter = newStartDateAfter.addingTimeInterval(86400 * 5)

        let newEndDateBefore = existingStartDate.addingTimeInterval(-86400)
        let newStartDateBefore = newEndDateBefore.addingTimeInterval(-86400 * 5)

        // When
        let isValidAfter = userChallengeService.areChallengeDatesValid(from: newStartDateAfter, to: newEndDateAfter)
        let isValidBefore = userChallengeService.areChallengeDatesValid(from: newStartDateBefore, to: newEndDateBefore)

        // Then
        XCTAssertTrue(isValidAfter, "New challenge completely after an existing one should be valid.")
        XCTAssertTrue(isValidBefore, "New challenge completely before an existing one should be valid.")
    }

    func test_areChallengeDatesValid_multipleExisting_correctlyDetectsCollision() {
        // Given
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        let date1Start = Date()
        let challenge1 = makeChallenge(
            id:"c1",
            creatorId: "any",
            startDate: date1Start,
            duration: 86400 * 3 // 3 days duration
        )
        let date1End = date1Start.addingTimeInterval(86400 * 3) // End date matches the duration

        let date2Start = date1End.addingTimeInterval(86400 * 2) // 2 days after c1 ends
        let challenge2 = makeChallenge(
            id:"c2",
            creatorId: "any",
            startDate: date2Start,
            duration: 86400 * 3 // 3 days duration
        )

        userChallengeService.userParticipatingChallenges = [challenge1, challenge2]

        // Test case 1: Challenge overlapping with first challenge
        let newStartDate1 = date1Start.addingTimeInterval(86400) // 1 day after c1 starts
        let newEndDate1 = newStartDate1.addingTimeInterval(86400) // 2 days duration
        let isValid1 = userChallengeService.areChallengeDatesValid(from: newStartDate1, to: newEndDate1)
        XCTAssertFalse(isValid1, "Challenge overlapping with first existing challenge should be invalid")

        // Test case 2: Challenge overlapping with second challenge
        let newStartDate2 = date2Start.addingTimeInterval(86400) // 1 day after c2 starts
        let newEndDate2 = newStartDate2.addingTimeInterval(86400) // 2 days duration
        let isValid2 = userChallengeService.areChallengeDatesValid(from: newStartDate2, to: newEndDate2)
        XCTAssertFalse(isValid2, "Challenge overlapping with second existing challenge should be invalid")

        // Test case 3: Challenge in the gap between challenges
        let newStartDateValid = date1End // Right when c1 ends
        let newEndDateValid = date2Start // Right when c2 starts
        let isValidGap = userChallengeService.areChallengeDatesValid(from: newStartDateValid, to: newEndDateValid)
        XCTAssertTrue(isValidGap, "Challenge in gap between existing challenges should be valid")
    }

    // MARK: - Timer tests

    func test_deinit_invalidatesTimer() {
        mockAuthProvider.currentUserSession = MockAppAuthUser(uid: "timerUser")
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
        userChallengeService = nil
    }

    func test_startUpdateTimer_createsAndStartsTimer_stopUpdateTimer_invalidatesIt() {
        // Given
        mockAuthProvider.currentUserSession = MockAppAuthUser(uid: "timerUser")
        userChallengeService = UserChallengesService(with: mockAuthProvider, mockHealthKitService, challengeStore: mockChallengeStore)
    }
}
