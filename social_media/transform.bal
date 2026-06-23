import ballerina/time;

isolated function transformPost(NewPost newPost, int userId) returns Post =>{
    description: newPost.description,
    category: newPost.category,
    tags: newPost.tags,
    created_date: time:currentTime().toString(),
    user_id: userId
};

//Takes a NewPost (from the user) and a userId
//Automatically sets created_date to today's date using Ballerina's time module
//Returns a full Post ready to be saved to DB

