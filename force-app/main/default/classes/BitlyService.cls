/**
 * Simple service to make http callout to
 * Bitly url shortener service.
 */
public class BitlyService {
    
    // reusable access token for oauth,
    // required when making API requests
    private String accessToken;
    
    public BitlyService() {
        this.accessToken = getAccessToken();
        system.debug('#### accessToken : '+accessToken);
    }
    
    /**
     * Get the access token to make authenticated oauth calls.
     * The actual username/password credentials are stored in
     * Named Credentials so that the password is stored securely.
     * 
     * This does require an extra http request when instantiating
     * the service which adds to latency. Alternatively, you could
     * store the generated access token in a custom setting and simply
     * reference it from your code, but then anyone who can view
     * custom settings can view the access token and use the API.
     * Trade-offs.
     */
    private String getAccessToken() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Bitly/oauth/access_token');
        req.setMethod('POST');

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res.getBody();
    }
    
    
    /**
     * Given a long URL will return the shortened version.
     * http://dev.bitly.com/links.html#v3_shorten
     */
    public String shorten( String url ) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'callout:Bitly/v3/shorten' +
            '?access_token=' + this.accessToken +
            '&longUrl=' + EncodingUtil.urlEncode( url, 'UTF-8' ) +
            '&format=txt'
        );
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug('#### Response : '+res.getBody());
        return res.getBody();
    }
}