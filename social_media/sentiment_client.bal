import ballerina/http;

configurable string sentimentServiceUrl = "http://localhost:9000";

final http:Client sentimentClient = check new (sentimentServiceUrl);

isolated function analyzeSentiment(string text) returns string|error {
    SentimentResponse response = check sentimentClient->/text\-processing/api/sentiment.post({
        text: text
    });
    return response.label;
}