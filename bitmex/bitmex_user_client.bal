import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/system;

public type UserClient client object {
    
    private http:Client userClient;
    private string apiKey;
    private string apiSecret;

    public function __init(http:Client bitmexClient, string apiKey, string apiSecret) {
        self.userClient = bitmexClient;
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
    }

    public remote function user() returns User|error;
    public remote function margin(string currency) returns Margin|error;
};

public remote function UserClient.user() returns User|error {
    
    http:Client clientEndpoint = self.userClient;
    string path = USER_BASE_PATH;
    string verb = GET;
    string data = "";
    http:Request request = new;

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->get(path, message = request);
    
    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        User|error user = User.convert(jsonPayload);
        if (user is User) {
            msg = string `[id: ${correlationId}]. user: ${io:sprintf("%s", user)}`;
            log:printDebug(msg);

            return user;
        } else {
            msg = string `[id: ${correlationId}]. userError: ${<string> user.detail().message}`;
            log:printError(msg, err = user);

            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }
}

public remote function UserClient.margin(string currency) returns Margin|error {

    http:Client clientEndpoint = self.userClient;
    string path = string `${MARGIN_PATH}?currency=${currency}`;
    string verb = GET;
    string data = "";
    http:Request request = new;

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->get(path, message = request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        Margin|error margin = Margin.convert(jsonPayload);
        if (margin is Margin) {
            msg = string `[id: ${correlationId}]. margin: ${io:sprintf("%s", margin)}`;
            log:printDebug(msg);
            return margin;
        } else {
            msg = string `[id: ${correlationId}]. marginError: ${<string> margin.detail().message}`;
            log:printError(msg, err = margin);
            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }
}