// Stub functions - will connect to MySQL in Feature 2
isolated function getAllUsers() returns User[]|error {
    return [
        {id: 1, name: "Dini", birth_date: "2003-01-01", mobile_number: "+94771234567"},
        {id: 2, name: "Ravi", birth_date: "1995-05-10", mobile_number: "+94771234568"}
    ];
}

isolated function getUserById(int id) returns User|UserNotFound|error {
    if id == 1 {
        return {id: 1, name: "Dini", birth_date: "2003-01-01", mobile_number: "+94771234567"};
    }
    return <UserNotFound>{};
}

isolated function addUser(NewUser newUser) returns error? {
    // Will insert into DB later
}

isolated function deleteUser(int id) returns error? {
    // Will delete from DB later
}

isolated function getPostsByUser(int id) returns PostMeta[]|UserNotFound|error {
    if id == 1 {
        return [
            {id: 1, description: "Learning Ballerina!", category: "education", created_date: "2024-01-01", tags: "ballerina,wso2"}
        ];
    }
    return <UserNotFound>{};
}

isolated function addPost(int userId, NewPost newPost) returns error? {
    // Will insert into DB later
}