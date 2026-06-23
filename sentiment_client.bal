import ballerina/http;

configurable string sentimentServiceUrl = "http://localhost:9000";

final http:Client sentimentClient = check new (sentimentServiceUrl, {
    retryConfig:{
        count: 3,
        interval:1,
        backOffFactor: 2,
        maxWaitInterval: 10
    }
});

isolated function analyzeSentiment(string text) returns string|error {
    SentimentResponse response = check sentimentClient->/text\-processing/api/sentiment.post({
        text: text
    });
    return response.label;
}