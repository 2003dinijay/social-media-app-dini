import ballerina/http;

service /social_media on new http:listener(9090){

     // GET /social_media/users

     resource function get users() returns USER[] | error{
        RETURN getallUsers();
     }
    //GET /social_media/users
    resource function get users(string id) returns USER | error{
            return getUsersById(id);
    }
    //GET /social_media