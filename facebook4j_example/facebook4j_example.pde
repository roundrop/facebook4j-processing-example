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

String appId = "xxxxxxxxxxxxxxx";
String appSecret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
String accessToken = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
Facebook facebook;

void setup() {
  size(400, 400);
  frameRate(60);

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthAppId(appId);
  cb.setOAuthAppSecret(appSecret);
  cb.setOAuthAccessToken(accessToken);
  facebook = new FacebookFactory(cb.build()).getInstance();
}

void draw() {
  background(255);
  fill(0);

  try {
    User me = facebook.getMe();
    textSize(40);
    text(me.getId(), 10, 30);
    text(me.getName(), 10, 100);
  } catch(FacebookException e) {
    println(e);
    exit();
  }
}
