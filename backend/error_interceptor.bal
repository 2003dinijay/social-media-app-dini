import ballerina/http;
import ballerina/log;

service class ResponseErrorInterceptor {
    *http:ResponseErrorInterceptor;

    remote function interceptResponseError(error err) returns http:BadRequest|http:NotFound|http:InternalServerError {
        string errorMessage = err.message();
        log:printError("Error occurred", 'error = err);

        if errorMessage.includes("not found") || errorMessage.includes("No rows") {
            return <http:NotFound>{
                body: {
                    message: errorMessage
                }
            };
        }

        if errorMessage.includes("constraint") || errorMessage.includes("invalid") {
            return <http:BadRequest>{
                body: {
                    message: errorMessage
                }
            };
        }

        return <http:InternalServerError>{
            body: {
                message: "An unexpected error occurred"
            }
        };
    }
}