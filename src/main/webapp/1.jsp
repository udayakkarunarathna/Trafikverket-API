<%@ page
    import="java.io.*, java.net.*, org.json.JSONObject, org.json.JSONArray"%>
<%
// API endpoint for XML requests (update with the actual endpoint)
String TRAFFIC_URL = "https://api.trafikinfo.trafikverket.se/v2/datex.xml"; // Replace with the actual endpoint for the XML request

String API_KEY = "";
// Construct the XML request
String xmlRequest = "<REQUEST>" +
                    "<LOGIN authenticationkey=\"" + API_KEY + "\"/>" +
                    "<QUERY objecttype=\"roa:siteMeasurements\" namespace=\"trafficflow\" schemaversion=\"3.1\" limit=\"10\">" +
                    "<FILTER></FILTER>" +
                    "</QUERY>" +
                    "</REQUEST>";

// Send XML request to the specified endpoint
String trafficData = sendXmlRequest(TRAFFIC_URL, xmlRequest);

// For public transport data, you may still need to use the original method
String publicTransportData = sendGetRequest("https://api.trafikverket.se/v2/PublicTransport?startStation=Stockholm&endStation=Gothenburg");

// Process data and display route info
out.println("<h2>Multi-modal Route Information</h2>");
out.println("<p>Traffic Data: " + trafficData + "</p>");
out.println("<p>Public Transport Data: " + publicTransportData + "</p>");
%>

<%!
// Function to make GET requests for public transport data
public String sendGetRequest(String urlStr) throws Exception {
	String API_KEY = "238ba050d0534dbc9300786c29b87302";
    URL url = new URL(urlStr);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    String inputLine;
    StringBuffer content = new StringBuffer();
    while ((inputLine = in.readLine()) != null) {
        content.append(inputLine);
    }
    in.close();
    conn.disconnect();
    return content.toString();
}

// Function to send XML requests
public String sendXmlRequest(String urlStr, String xmlData) throws Exception {
    URL url = new URL(urlStr);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST"); // Use POST for sending XML data
    conn.setRequestProperty("Content-Type", "application/xml");
    conn.setDoOutput(true); // Enable writing to the connection

    // Write the XML data to the output stream
    try (OutputStream os = conn.getOutputStream()) {
        byte[] input = xmlData.getBytes("utf-8");
        os.write(input, 0, input.length);
    }

    // Read the response
    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    StringBuilder response = new StringBuilder();
    String responseLine;
    while ((responseLine = in.readLine()) != null) {
        response.append(responseLine.trim());
    }

    in.close();
    conn.disconnect();
    return response.toString();
}
%>
