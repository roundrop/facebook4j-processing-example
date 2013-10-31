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

Facebook facebook;

boolean authCompleted = false;
boolean gotAccessToken = false;

void setup() {
  size(400, 610);
  frameRate(100);

  background(255);
  fill(#000000, 128);
  noStroke();

  // Authentication
  rect(10, 10, 380, 190, 7);
  textSize(20);
  text("Authentication", 40, 40);
  textSize(16);
  text("Start", 290, 40);
  rect(270, 23, 80, 25, 7);

  // Getting access token
  rect(10, 210, 380, 190, 7);
  textSize(20);
  text("Getting access token", 40, 240);
  textSize(12);
  text("Email: ", 50, 275);
  text(email, 120, 275);
  textSize(12);
  text("Password: ", 50, 305);
  text("********", 120, 305);
  textSize(16);
  text("Get", 295, 307);
  rect(270, 290, 80, 25, 7);

  // API Examples
  rect(10, 410, 380, 190, 7);
  textSize(20);
  text("API Examples", 40, 440);
  textSize(16);
  text("Run", 295, 440);
  rect(270, 423, 80, 25, 7);

  // prepare Facebook4J
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setDebugEnabled(true);
  cb.setOAuthAppId(appId);
  cb.setOAuthAppSecret("");
  cb.setOAuthPermissions(permissions);
  facebook = new FacebookFactory(cb.build()).getInstance();
}

void draw() {
  changeCursor();
}

void changeCursor() {
  switch (mouseOverButton()) {
  case 1:
  case 2:
  case 3:
    cursor(HAND);
    break;
  default:
    cursor(ARROW);
  }
}

int mouseOverButton() {
  if ((270 <= mouseX && mouseX <= 350) && (23 <= mouseY && mouseY <= 48)) {
    return 1;
  } else
  if ((270 <= mouseX && mouseX <= 350) && (290 <= mouseY && mouseY <= 315)) {
    return 2;
  } else
  if ((270 <= mouseX && mouseX <= 350) && (423 <= mouseY && mouseY <= 448)) {
    return 3;
  }
  return 0;
}

void mouseClicked() {
  switch (mouseOverButton()) {

  // Authentication
  case 1:
    if (authCompleted) break;
    String callbackURL = "https://www.facebook.com/connect/login_success.html";
    link(facebook.getOAuthAuthorizationURL(callbackURL) + "&response_type=token", "_new");
    textSize(12);
    text("Authentication succeeded if the following displayed\n in your web browser:",
         50, 70);
    PImage img = loadImage("auth.png");
    image(img, 20, 100);
    authCompleted = true;
    break;

  // Getting access token
  case 2:
    if (gotAccessToken) break;
    GetAccessToken gat = new GetAccessToken();
    AccessToken accessToken = null;
    try {
      accessToken = gat.getAccessToken();
      facebook.setOAuthAccessToken(accessToken);
    } catch(FacebookException e) {
      println(e);
    }
    textSize(12);
    text("Your Access token:",
         50, 340);
    text(accessToken.getToken().substring(0, 32) + "...", 60, 360);
    println("Access token: " + accessToken.getToken());
    gotAccessToken = true;
    break;

  // API Examples
  case 3:
    getMe();
    break;
  }
}

void getMe() {
  textSize(16);
  text("Your Basic Info:", 50, 480);
  try {
    User me = facebook.getMe();
    text(me.getId(), 60, 500);
    text(me.getName(), 60, 520);
    text(me.getGender(), 60, 540);
    text(me.getEmail(), 60, 560);
  } catch(FacebookException e) {
    println(e);
    exit();
  }
}
