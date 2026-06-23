import ballerina/time;

isolated function transformPost(NewPost newPost, int userId) returns Post {
    time:Civil now = time:utcToCivil(time:utcNow());
    string created_date = string `${now.year}-${now.month.toString().padStart(2, "0")}-${now.day.toString().padStart(2, "0")}`;
    return {
        description: newPost.description,
        category: newPost.category,
        tags: newPost.tags,
        created_date: created_date,
        user_id: userId
    };
}
//Takes a NewPost (from the user) and a userId
//Automatically sets created_date to today's date using Ballerina's time module
//Returns a full Post ready to be saved to DB

