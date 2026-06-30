import ballerina/constraint;
import ballerina/http;

// Existing user record (from database)
public type User record {|
    int id;
    string name;
    string birth_date;
    string mobile_number;
|};

// For creating a new user (with strict constraints)
public type NewUser record {|
    @constraint:String {
        minLength: 2,
        maxLength: 100
    }
    string name;

    // Enforces ISO 8601 date format format (YYYY-MM-DD)
    @constraint:String {
        pattern: re `^\d{4}-\d{2}-\d{2}$`
    }
    string birth_date;

    // Enforces international format (e.g., +94771234567)
    @constraint:String {
        pattern: re `^\+\d{10,12}$`
    }
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

// For creating a new post (with strict constraints)
public type NewPost record {|
    @constraint:String {
        minLength: 1,
        maxLength: 500
    }
    string description;

    @constraint:String {
        minLength: 2,
        maxLength: 50
    }
    string category;

    // Enforces comma-separated tags with no spaces around commas, or a single tag
    @constraint:String {
        pattern: re `^[a-zA-Z0-9]+(,[a-zA-Z0-9]+)*$`
    }
    string tags;
|};

// Error response types

//types inclusion
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

// Sentiment analysis request
public type SentimentRequest record {|
    string text;
|};

// Sentiment analysis response
public type SentimentResponse record {|
    record {|
        decimal neg;
        decimal neutral;
        decimal pos;
    |} probability;
    string label;
|};