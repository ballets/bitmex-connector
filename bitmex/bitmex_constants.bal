//BitMex API resorces
final string BASE_PATH = "/api/v1";
final string GET_USER_PATH = BASE_PATH + "/user";
final string GET_MARGIN_PATH = BASE_PATH + "/user/margin";
final string CREATE_ORDER_PATH = BASE_PATH + "/order";
final string UPDATE_ORDER_PATH = BASE_PATH + "/order";
final string CREATE_BULK_ORDER_PATH = BASE_PATH + "/order/bulk";
final string GET_ORDER_PATH = BASE_PATH + "/order";
final string CANCEL_ALL_ORDERS = BASE_PATH + "/order/all";
final string CANCEL_ORDERS = BASE_PATH + "/order";
final string GET_TRADE_PATH = BASE_PATH + "/trade";
final string GET_POSITION_PATH = BASE_PATH + "/position";
final string SET_LEVERAGE_PATH = BASE_PATH + "/position/leverage";

//string constants
final string POST = "POST";
final string PUT = "PUT";
final string GET = "GET";
final string DELETE = "DELETE";

// Error Codes
final string BITMEX_ERROR_CODE = "(raj/bitmex)BitMexError";