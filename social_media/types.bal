//existing user record from db
public type User record{|
    int id;
    string name;
    string birth_date;
    string mobile_number;
|};

//for creating a new user for no id yet

public type NewUser record{|
    string name;
    string birth_date;
    string mobile_number;
|};

//POST with metadata

public type PostMeta record{
     int id;
    string description;
    string category;
    string created_date;
    string tags;

|};

//for creating new post

public type NewPost record{|
    string description;
    string category;
    string tags;
|};

//error response types

// Error response types
public type UserNotFound record {|
    *http:NotFound;
    string body = "User not found";
|};