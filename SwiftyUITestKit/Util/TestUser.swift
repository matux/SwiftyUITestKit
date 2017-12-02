import Foundation

/// User metadata of an actual user
struct TestUser {

    /// Unique Facebook user to test login/registration and sharing.
    static let facebook = TestUser(username: "test-user",
                                   password: "ABC123def456",
                                   email: "test-user@gmail.com")

    /// TestUser to be used when testing sign up.
    static let new = TestUser(username: "new-user",
                              password: "ABC123def456",
                              email: "new-user@gmail.com")

    /// Existing TestUser we'll use for login and other tests.
    static let existing = TestUser(username: "existing-user",
                                   password: "ABC1234abc1234",
                                   email: "existing-user@gmail.com")

    let username: String
    let password: String
    let email: String
}
