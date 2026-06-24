import ballerina/test;
import ballerina/http;

http:Client testClient = check new ("http://localhost:9090");
// ─── User Tests ───────────────────────────────────────────

@test:Config {}
function testGetAllUsers() returns error? {
    User[] users = check testClient->/social_media/users;
    test:assertTrue(users.length() > 0, msg = "Should return at least one user");
}
// this test is done for checking the user id is 1 or not. if not it will fail the test case.
@test:Config {}
function testGetUserById() returns error? {
    User user = check testClient->/social_media/users/[1];
    test:assertEquals(user.id, 1, msg = "User ID should be 1");
}

@test:Config {}
function testGetNonExistentUser() returns error? {
    http:Response response = check testClient->/social_media/users/[999];
    test:assertEquals(response.statusCode, 404, msg = "Should return 404 for missing user");
}

@test:Config {}
function testCreateUser() returns error? {
    NewUser newUser = {
        name: "TestUser",
        birth_date: "2000-01-01",
        mobile_number: "+94771234999"
    };
    http:Response response = check testClient->/social_media/users.post(newUser);
    test:assertEquals(response.statusCode, 201, msg = "Should return 201 Created");
}

// ─── Post Tests ───────────────────────────────────────────

@test:Config {}
function testGetPostsByUser() returns error? {
    PostMeta[] posts = check testClient->/social_media/users/[1]/posts;
    test:assertTrue(posts.length() > 0, msg = "User 1 should have posts");
}

//this test is for checking the post id is 1 or not. if not it will fail the test case.

@test:Config {}
function testCreatePost() returns error? {
    NewPost newPost = {
        description: "Test post from unit test",
        category: "test",
        tags: "ballerina,test"
    };
    http:Response response = check testClient->/social_media/users/[1]/posts.post(newPost);
    test:assertEquals(response.statusCode, 201, msg = "Should return 201 Created");
}

// ─── Transform Tests ──────────────────────────────────────

//this test is for checking the transformPost function which is used to transform the NewPost record to Post record by adding the user_id and created_date fields.
@test:Config {}
function testTransformPost() {
    NewPost newPost = {
        description: "Test description",
        category: "education",
        tags: "test,ballerina"
    };
    Post post = transformPost(newPost, 1);
    test:assertEquals(post.user_id, 1, msg = "User ID should match");
    test:assertEquals(post.description, "Test description", msg = "Description should match");
    test:assertEquals(post.category, "education", msg = "Category should match");
}