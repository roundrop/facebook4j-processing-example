import java.net.*;

import facebook4j.auth.*;
import facebook4j.internal.http.*;
import facebook4j.internal.json.*;
import facebook4j.internal.logging.*;
import facebook4j.internal.org.json.*;
import facebook4j.conf.*;
import facebook4j.internal.util.*;
import facebook4j.management.*;
import facebook4j.*;
import facebook4j.json.*;
import facebook4j.api.*;

public class GetAccessToken {
  private static final String callbackURL = "https://www.facebook.com/connect/login_success.html";

  public AccessToken getAccessToken() throws FacebookException {
    CookieManager manager = new CookieManager();
    manager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
    CookieHandler.setDefault(manager);

    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setDebugEnabled(true);
    cb.setOAuthAppId(appId);
    cb.setOAuthAppSecret("");
    cb.setOAuthPermissions(permissions);
    Facebook facebook = new FacebookFactory(cb.build()).getInstance();

    HttpClientImpl http = new HttpClientImpl();
    HttpResponse response;
    
    // auth
    String authorizationURL = facebook.getOAuthAuthorizationURL(callbackURL) + "&response_type=token";
    response = http.get(authorizationURL);
  
    // login
    String loginURL = response.getResponseHeader("Location");
    response = http.get(loginURL);
  
    String resStr = response.asString();
    String authorizeURL = "https://www.facebook.com" + catchPattern(resStr, "<form id=\"login_form\" action=\"", "\" method=\"post\"");
    HttpParameter[] params = new HttpParameter[18];
    params[0] = new HttpParameter("lsd", catchPattern(resStr
                , "<input type=\"hidden\" name=\"lsd\" value=\"", "\" autocomplete=\"off\" />"));
    params[1] = new HttpParameter("api_key", catchPattern(resStr
                , "<input type=\"hidden\" autocomplete=\"off\" id=\"api_key\" name=\"api_key\" value=\"", "\" />"));
    params[2] = new HttpParameter("display", "page");
    params[3] = new HttpParameter("enable_profile_selector", "");
    params[4] = new HttpParameter("legacy_return", "1");
    params[5] = new HttpParameter("next", catchPattern(resStr
                , "<input type=\"hidden\" autocomplete=\"off\" id=\"next\" name=\"next\" value=\"", "\" />"));
    params[6] = new HttpParameter("profile_selector_ids", "");
    params[7] = new HttpParameter("skip_api_login", "1");
    params[8] = new HttpParameter("signed_next", "1");
    params[9] = new HttpParameter("trynum", "1");
    params[10] = new HttpParameter("timezone", "");
    params[11] = new HttpParameter("lgnrnd", catchPattern(resStr
                , "<input type=\"hidden\" name=\"lgnrnd\" value=\"", "\" />"));
    params[12] = new HttpParameter("lgnjs", catchPattern(resStr
                , "<input type=\"hidden\" id=\"lgnjs\" name=\"lgnjs\" value=\"", "\" />"));
    params[13] = new HttpParameter("email", email);
    params[14] = new HttpParameter("pass", password);
    params[15] = new HttpParameter("persistent", "1");
    params[16] = new HttpParameter("default_persistent", "0");
    params[17] = new HttpParameter("login", "&#x30ed;&#x30b0;&#x30a4;&#x30f3;");
  
    response = http.request(new HttpRequest(RequestMethod.POST, authorizeURL, params, null, null));
  
    // dialog
    String dialogURL = response.getResponseHeader("Location").replaceAll("&amp%3B", "&");
    response = http.request(new HttpRequest(RequestMethod.GET, dialogURL, null, null, null));
    String redirectURL = response.getResponseHeader("Location");

    // extract access token (ignore expires_in)
    String accessToken = redirectURL.substring(redirectURL.indexOf("#access_token=")+14, redirectURL.indexOf("&expires"));
    return new AccessToken(accessToken, null);
  }
}

private static String catchPattern(String body, String before, String after) {
  int beforeIndex = body.indexOf(before);
  int afterIndex = body.indexOf(after, beforeIndex);
  return body.substring(beforeIndex + before.length(), afterIndex);
}

