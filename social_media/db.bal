import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;

// Database client
final mysql:Client dbClient = check new (
    host = "localhost",
    user = "root",
    password = "Dinithi@123",
    database = "social_media_database",
    port = 3306
);

isolated function getAllUsers() returns User[]|error {
    stream<User, sql:Error?> userStream = dbClient->query(`SELECT id, name, birth_date, mobile_number FROM users`);
    return from var user in userStream select user;
}

isolated function getUserById(int id) returns User|UserNotFound|error {
    User|sql:Error result = dbClient->queryRow(`SELECT id, name, birth_date, mobile_number FROM users WHERE id = ${id}`);
    if result is sql:NoRowsError {
        return <UserNotFound>{};
    }
    return result;
}

isolated function addUser(NewUser newUser) returns error? {
    _ = check dbClient->execute(`
        INSERT INTO users (name, birth_date, mobile_number) 
        VALUES (${newUser.name}, ${newUser.birth_date}, ${newUser.mobile_number})
    `);
}

isolated function deleteUser(int id) returns error? {
    _ = check dbClient->execute(`DELETE FROM users WHERE id = ${id}`);
}

isolated function getPostsByUser(int userId) returns PostMeta[]|UserNotFound|error {
    // First check if user exists
    User|UserNotFound|error user = getUserById(userId);
    if user is UserNotFound {
        return <UserNotFound>{};
    }
    stream<PostMeta, sql:Error?> postStream = dbClient->query(`
        SELECT id, description, category, created_date, tags FROM posts WHERE user_id = ${userId}
    `);
    return from var post in postStream select post;
}

isolated function addPost(int userId, NewPost newPost) returns error? {
    // First check if user exists
    User|UserNotFound|error user = getUserById(userId);
    if user is UserNotFound {
        return error("User not found");
    }
    _ = check dbClient->execute(`
        INSERT INTO posts (description, category, tags, created_date, user_id) 
        VALUES (${newPost.description}, ${newPost.category}, ${newPost.tags}, CURDATE(), ${userId})
    `);
}