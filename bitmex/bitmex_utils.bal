
import ballerina/io;
import ballerina/http;
import ballerina/crypto;
import ballerina/time;
import ballerina/encoding;

function setResponseError(int statusCode, json jsonResponse) returns error {
    string detail = jsonResponse.description.toString();
    if (statusCode == 429) {
        detail = "429";
    }
    error err = error(BITMEX_ERROR_CODE, { message: detail });
    return err;
}

function generateSignature(string secret, string verb, string path, int expires, string data) returns string {
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