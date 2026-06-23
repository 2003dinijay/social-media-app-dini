import ballerina/http;

service /social_media on new http:Listener(9090) {

    // GET /social_media/users
    resource function get users() returns User[]|error {
        return getAllUsers();
    }

    // GET /social_media/users/{id}

    //creating a subtype of http:NotFound for better error handling when user is not found in DB
    //resource fuction is a GET endpoint that takes an id as a path parameter and returns either a User record, a UserNotFound error, or a generic error
    resource function get users/[int id]() returns User|UserNotFound|error {
        return getUserById(id);
    }

    // POST /social_media/users
    resource function post users(NewUser newUser) returns http:Created|error {
        check addUser(newUser);
        return http:CREATED;
    }

    // DELETE /social_media/users/{id}
    resource function delete users/[int id]() returns http:NoContent|error {
        check deleteUser(id);
        return http:NO_CONTENT;
    }

    // GET /social_media/users/{id}/posts
    resource function get users/[int id]/posts() returns PostMeta[]|UserNotFound|error {
        return getPostsByUser(id);
    }

    // POST /social_media/users/{id}/posts
  resource function post users/[int id]/posts(NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error {
    error? result = addPost(id, newPost);
    if result is error {
        string msg = result.message();
        if msg == "User not found" {
            return <UserNotFound>{};
        }
        if msg == "Post content is not allowed" {
            return <PostForbidden>{};
        }
        return result;
    }
    return http:CREATED;
}};