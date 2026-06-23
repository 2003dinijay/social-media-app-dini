import ballerina/http;

// Existing user record (from database)
public type User record {|
    int id;
    string name;
    string birth_date;
    string mobile_number;
|};

// For creating a new user (no id yet)
public type NewUser record {|
    string name;
    string birth_date;
    string mobile_number;
|};

// Post with metadata
public type PostMeta record {|
    int id;
    string description;
    string category;
    string created_date;
    string tags;
|};

// For creating a new post
public type NewPost record {|
    string description;
    string category;
    string tags;
|};

// Error response types
public type UserNotFound record {|
    *http:NotFound;
    string body = "User not found";
|};

// Full post record matching DB structure
public type Post record {|
    string description;
    string category;
    string tags;
    string created_date;
    int user_id;
|};

// Error type for forbidden posts
public type PostForbidden record {|
    *http:Forbidden;
    string body = "Post content is not allowed";
|};