import ballerina/http;
import ballerina/io;

public type Client client object {
    
    http:Client bitmexClient;
    string apiKey;
    string apiSecret;

    public function __init(BitMexConfiguration bitmexConfig) {
        self.bitmexClient = new(bitmexConfig.uri, config = bitmexConfig.clientConfig);
        self.apiKey = bitmexConfig.apiKey;
        self.apiSecret = bitmexConfig.apiSecret;
    }

    public remote function getUser() returns User|error;

    public remote function getMargin(string currency) returns Margin|error;

    public remote function createOrder(string symbol, string? side, float? price, int? quantity, 
        string? orderType) returns Order|error;

    public remote function createOrders(Order[] orders) returns Order[]|error;

    public remote function getOrders(string? symbol) returns Order[]|error;

    public remote function getOrderByClOrdID(string clOrdId) returns Order[]|error;

    public remote function cancelAllOrders(string? symbol, string? filter, string? text) returns Order[]|error;

    public remote function cancelOrders(string? orderID, string? clOrdID, string? text) returns Order[]|error;

    public remote function updateOrder(string? orderID, string? origClOrdID, string? clOrdID, 
        float? orderQty, float? price, float? stopPx) returns Order|error;

    public remote function getPositions() returns Position[]|error;

    public remote function setLeverage(string symbol, float leverage) returns error?;

    public remote function getTrade(string symbol, int count, boolean reverse) returns Trade[]|error;    
};

public type BitMexConfiguration record {
    string uri;
    string apiKey;
    string apiSecret;
    http:ClientEndpointConfig clientConfig = {};
};

public remote function Client.getUser() returns User|error {
    
    http:Client clientEndpoint = self.bitmexClient;
    string path = GET_USER_PATH;
    string verb = GET;
    string data = "";
    http:Request request = new;

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    io:println("Calling BitMex.getUser()");

    var httpResponse = clientEndpoint->get(path, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                User|error user = User.convert(jsonPayload);
                if (user is User) {
                    return user;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    } 
}

public remote function Client.getMargin(string currency) returns (Margin|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = GET_MARGIN_PATH + "?currency=" + currency;
    string verb = GET;
    string data = "";
    http:Request request = new;

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    io:println("Calling BitMex.getMargin()");

    var httpResponse = clientEndpoint->get(path, message = request);

    if (httpResponse is http:Response) {               
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Margin|error margin = Margin.convert(jsonPayload);
                if (margin is Margin) {
                    return margin;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.setLeverage(string symbol, float leverage) returns error? {

    http:Client clientEndpoint = self.bitmexClient;
    string path = SET_LEVERAGE_PATH;
    string verb = POST;

    json payload = {"symbol":symbol,"leverage":leverage};

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    io:println("Calling BitMex.setLeverage()");

    var httpResponse = clientEndpoint->post(path, request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                return;
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.createOrder(string symbol, string? side, float? price, int? quantity, 
    string? orderType) returns (Order|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = CREATE_ORDER_PATH;
    string verb = POST;

    json payload = {"symbol":symbol};

    if (side is string) {
        payload.side = side;
    }

    if (price is float) {
        payload.price = price;
    }

    if (quantity is int) {
        payload.orderQty = quantity;
    }

    if (orderType is string) {
        payload.ordType = orderType;
    }

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    io:println("Calling BitMex.createOrder()");

    var httpResponse = clientEndpoint->post(path, request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Order|error ord  = Order.convert(jsonPayload);
                if (ord is Order) {
                    return ord;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.updateOrder(string? orderID, string? origClOrdID, string? clOrdID, 
        float? orderQty, float? price, float? stopPx) returns (Order|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = UPDATE_ORDER_PATH;
    string verb = PUT;

    json payload = {};

    if (orderID is string) {
        payload.orderID = orderID;
    }

    if (origClOrdID is string) {
        payload.origClOrdID = origClOrdID;
    }

    if (clOrdID is string) {
        payload.clOrdID = clOrdID;
    }

    if (orderQty is float) {
        payload.orderQty = orderQty;
    }

    if (price is float) {
        payload.price = price;
    }

    if (stopPx is float) {
        payload.stopPx = stopPx;
    }

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    io:println("Calling BitMex.updateOrder()");

    var httpResponse = clientEndpoint->put(path, request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Order|error ord  = Order.convert(jsonPayload);
                if (ord is Order) {
                    return ord;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.createOrders(Order[] orders) returns (Order[]|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = CREATE_BULK_ORDER_PATH;
    string verb = POST;

    json[] ordersJson = [];
    int i = 0;
    foreach Order ord in orders {
        json|error orderJson = json.convert(ord);
        if (orderJson is json) {
            ordersJson[i] = orderJson;
        }
        i = i + 1;
    }

    json payload = {"orders":ordersJson};

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    io:println("Calling BitMex.createOrders()");

    var httpResponse = clientEndpoint->post(path, request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Order[]|error ord  = Order[].convert(jsonPayload);
                if (ord is Order[]) {
                    return ord;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.getOrders(string? symbol) returns (Order[]|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = GET_ORDER_PATH + "?filter=%7B%22open%22%3A%20true%7D&count=100&reverse=false";
    if (symbol is string) {
        path = path + "&symbol=" + symbol;
    }
    string verb = GET;
    string data = "";
    http:Request request = new;
    
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    io:println("Calling BitMex.getOrders()");

    var httpResponse = clientEndpoint->get(path, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Order[]|error ord  = Order[].convert(jsonPayload);
                if (ord is Order[]) {
                    return ord;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.getOrderByClOrdID(string clOrdId) returns (Order[]|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = GET_ORDER_PATH + "?filter=%7B%22open%22%3A%20true%2C%22clOrdID%22%3A%20%22" + clOrdId + "%22%7D&count=100&reverse=false";
    string verb = GET;
    string data = "";
    http:Request request = new;
    
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    io:println("Calling BitMex.getOrderByClOrdID()");

    var httpResponse = clientEndpoint->get(path, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Order[]|error ord  = Order[].convert(jsonPayload);
                if (ord is Order[]) {
                    return ord;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.cancelAllOrders(string? symbol, string? filter, string? text) returns (Order[]|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = CANCEL_ALL_ORDERS;
    string verb = DELETE;
    string data = "";
    http:Request request = new;

    if (symbol is string || filter is string || text is string) {
        json payload = {};
        if (symbol is string) {
            payload.symbol= symbol;
        }
        if (filter is string) {
            payload.filter = filter;
        }
        if (text is string) {
            payload.text = text;
        }
        data = payload.toString();
        request.setJsonPayload(payload, contentType = "application/json");
    }
    
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    io:println("Calling BitMex.cancelAllOrders()");

    var httpResponse = clientEndpoint->delete(path, request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Order[]|error ord  = Order[].convert(jsonPayload);
                if (ord is Order[]) {
                    return ord;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.cancelOrders(string? orderID, string? clOrdID, string? text) returns (Order[]|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = CANCEL_ORDERS;
    string verb = DELETE;
    string data = "";
    http:Request request = new;

    json payload = {};
    if (orderID is string) {
        payload.orderID= orderID;
    }
    if (clOrdID is string) {
        payload.clOrdID = clOrdID;
    }
    if (text is string) {
        payload.text = text;
    }

    data = payload.toString();
    request.setJsonPayload(payload, contentType = "application/json");
  
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    io:println("Calling BitMex.cancelOrders()");

    var httpResponse = clientEndpoint->delete(path, request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Order[]|error ord  = Order[].convert(jsonPayload);
                if (ord is Order[]) {
                    return ord;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.getPositions() returns (Position[]|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = GET_POSITION_PATH;
    string verb = GET;
    string data = "";
    http:Request request = new;
    
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    io:println("Calling BitMex.getPositions()");

    var httpResponse = clientEndpoint->get(path, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json) {
            if (statusCode == 200) {
                Position[]|error positions  = Position[].convert(jsonPayload);
                if (positions is Position[]) {
                    return positions;
                } else {
                    error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                    return err;                
                }
            } else {
                return setResponseError(statusCode, jsonPayload);
            }           
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}

public remote function Client.getTrade(string symbol, int count, boolean reverse) returns (Trade[]|error) {

    http:Client clientEndpoint = self.bitmexClient;
    string path = GET_TRADE_PATH + "?symbol=" + symbol + "&count=" + count + "&reverse=" + reverse;
    http:Request request = new;

    io:println("Calling BitMex.getTrade()");
    var httpResponse = clientEndpoint->get(path, message = request);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var jsonPayload = httpResponse.getJsonPayload();
        if (jsonPayload is json[]) {
            if (statusCode == 200) {
                // int i = 0;
                Trade[]|error trades = Trade[].convert(jsonPayload);
                // foreach json j in jsonPayload {
                //     io:println(j);
                //     Trade|error trade = Trade.convert(j);
                //     io:println(trade);
                //     if (trade is Trade) {
                //         trades[i] = trade;
                //         i = i + 1;
                //     } else {
                //         error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
                //         return err; 
                //     }
                //     io:println("inter past");
                // }
                return trades;
            } else {
                return setResponseError(statusCode, jsonPayload);
            }          
        } else {
            error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
            return err;
        }
    } else {
        error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
        return err;
    }
}