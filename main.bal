import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;


type Item record {
    int id?;
    string name;
    int quentity;
};

configurable string host = ?;
configurable int port = ?;
configurable string username = ?;
configurable string password = ?;
configurable string databaseName = ?;

service /store on new http:Listener(9090) {
    final mysql:Client  databaseClient;

    public function init() returns error?{
        self.databaseClient = check new(host,username,password,databaseName,port);
    }
    resource function get .()  returns  Item[]|error {

        stream<Item,sql:Error?> itemStream =  self.databaseClient->query(`SELECT * FROM Inventory`);
        return from Item item in itemStream select item;

    }
    resource function get singleitem/[int item_id]()  returns  Item[]|error {
     
        stream<Item,sql:Error?> itemStream =  self.databaseClient->query(`SELECT * FROM Inventory Where id = ${item_id}`);
        return from Item item in itemStream select item;

    }
    resource function get singleitem()  returns  Item[]|error {
     
        stream<Item,sql:Error?> itemStream =  self.databaseClient->query(`SELECT * FROM Inventory Where id = 1`);
        return from Item item in itemStream select item;

    }

    resource function post .(@http:Payload Item item) returns error? {
        _ = check self.databaseClient->execute(`INSERT INTO Inventory (name,quentity) VALUES(${item.name},${item.quentity});`);
    }

    resource function get liveness() returns http:Ok {
        return http:OK;
    }
    resource function get rediness() returns http:Ok|error {
        int _ = check self.databaseClient->queryRow(`SELECT COUNT(*) FROM Inventory`);  

        return http:OK;
    }
}
