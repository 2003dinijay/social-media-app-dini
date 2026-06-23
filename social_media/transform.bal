import ballerina/time;

isolated function transformPost(NewPost newPost, int userId) returns Post =>{
    description: newPost.description,
    category: newPost.category,
    tags: newPost.tags,
    created_date: time:currentTime().toString(),
    user_id: userId
};
