
import ballerina/io;
import ballerina/http;
import ballerina/crypto;
import ballerina/time;
import ballerina/encoding;

function generateSignature(string secret, string verb, string path, int expires, string data) 
        returns string {
    
    string input = verb + path + <string> string.convert(expires) + data;
    byte[] hmac = crypto:hmacSha256(input.toByteArray("UTF-8"), secret.toByteArray("UTF-8"));
    return encoding:encodeHex(hmac);
}

function constructRequestHeaders(http:Request request, string verb, string apiKey, string apiSecret,
        string path, string data) {
    
    int expires = time:currentTime().time/1000 + 3600;
    string signature = generateSignature(apiSecret, verb, path, expires, data);
    request.setHeader("api-expires", <string> string.convert(expires));
    request.setHeader("api-key", apiKey);
    request.setHeader("api-signature", signature);
}

function validateResponse(http:Response|error httpResponse, string correlationId) 
        returns json|error {
    
    if (httpResponse is http:Response) {

        string msg = string `[id: ${correlationId}]. httpResponse: ${io:sprintf("%s", httpResponse)}`;
        log:printDebug(msg);

        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            msg = string `[id: ${correlationId}]. jsonPayload: ${io:sprintf("%s", jsonPayload)}`;
            log:printDebug(msg);
            if (statusCode == 200) {
                return jsonPayload;
            } else {
                error err = error(BITMEX_ERROR_CODE, { message: jsonPayload.description.toString() });
                return err;
            }           
        } else {
            msg = string `[id: ${correlationId}]. jsonPayloadError: ${io:sprintf("%s", <string> jsonPayload.detail().message)}`;
            log:printError(msg, err = jsonPayload);
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        string msg = string `[id: ${correlationId}]. httpResponseError: ${io:sprintf("%s", <string> httpResponse.detail().message)}`;
        log:printError(msg, err = httpResponse);
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}