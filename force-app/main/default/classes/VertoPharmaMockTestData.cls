public class VertoPharmaMockTestData implements HttpCalloutMock {
    public String testData;
    public VertoPharmaMockTestData(String jsonInput){
        this.testData = jsonInput;
    }
    public HTTPResponse respond(HTTPRequest req) {
        String requestBody = req.getBody();
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(this.testData);
        response.setStatusCode(200);
        return response;
    }
}