public class InvokeBitlyService {
    @Future( callout = true )
    public static void shortenAsync( Set<ID> recIds, string sobjectType ) {
        system.debug('#### shortenAsync called from ' + sobjectType + ' trigger.');
        
        // Fetch your data and a field where you want to store the generated short url
        string soql = 'SELECT id, Website FROM ' + sobjectType + ' WHERE id in : recIds';
        list<SObject> records = database.query(soql);
        
        // Service to actually call out to bitly and get a shortened url
        BitlyService service = new BitlyService();
        
        // Bitly does not support bulk url shortening
        // so you must make each call individually.
        // Do be aware of Bitly's rate limiting if you try
        // to mass create a bunch of records in short succession
        // http://dev.bitly.com/rate_limiting.html
        for ( SObject obj : records ) {
            system.debug('#### Long URL : '+obj.get('Website'));
            string longURL = (String)obj.get('Website');
            if(!(longURL.startsWith('http://') || longURL.startsWith('https://'))){
                longURL = 'http://'+longURL;
            }
            string shortURL = service.shorten(longURL);
            if(shortURL != 'INVALID_URI'){
                obj.put('Website',shortURL);
            }
            system.debug('#### Short URL: '+obj.get('Website'));
        }
        
        // update the records with their short urls
        if ( records.size() > 0 ) {
            update records;
        }
        system.debug('#### Updated : '+records);
    }
}