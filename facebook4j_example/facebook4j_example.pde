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
DeviceCode deviceCode = null;

void setup() {
  size(400, 610);
  frameRate(100);

  background(255);
  noStroke();

  /* Facebook Login */
  fill(#000000, 18);
  rect(10, 10, 380, 190, 7);
  fill(#000000, 100);
  textSize(20);
  text("Facebook Login", 40, 40);
  PImage img = loadImage("login_with_facebook.png");
  image(img, 110, 50);

  /* API Examples */
  fill(#000000, 18);
  rect(10, 210, 380, 390, 7);
  fill(#000000, 100);
  textSize(20);
  text("API Examples", 40, 240);
  textSize(16);
  text("Run", 295, 240);
  fill(#000000, 50);
  rect(270, 223, 80, 25, 7);

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
  if ((110 <= mouseX && mouseX <= 301) && (50 <= mouseY && mouseY <= 90)) {
    return 1;
  } else
  if (authCompleted && (130 <= mouseX && mouseX <= 370) && (105 <= mouseY && mouseY <= 125)) {
    return 2;
  } else
  if (authCompleted && (270 <= mouseX && mouseX <= 350) && (223 <= mouseY && mouseY <= 248)) {
    return 3;
  }
  return 0;
}

void mouseClicked() {
  switch (mouseOverButton()) {

  /* Facebook Login */
  case 1:
    if (authCompleted) break;
    try {
      deviceCode = facebook.getOAuthDeviceCode();
    } catch (FacebookException e) {
    }
    authCompleted = true;

    fill(#000000, 100);
    textSize(16);
    text("Next, visit ", 40, 120);
    fill(#063965, 200);
    textSize(14);
    text(deviceCode.getVerificationUri(), 130, 120);
    fill(#000000, 100);
    text("and enter this code: ", 130, 150);
    fill(#000000, 200);
    textSize(24);
    text(deviceCode.getUserCode(), 140, 170);
    break;

  /* Visit facebook.com/device */
  case 2:
    link(deviceCode.getVerificationUri());
    break;

  // API Examples
  case 3:
    setToken();

    getMe();
    break;
  }
}

void setToken() {
  try {
    facebook.getOAuthDeviceToken(deviceCode);
  } catch(Exception e) {
    println(e);
    exit();
  }
}

void getMe() {
  fill(#000000, 90);
  textSize(16);
  text("Your Basic Info:", 50, 280);
  try {
    User me = facebook.getMe();
    text(me.getId(), 60, 300);
    text(me.getName(), 60, 320);
    text(me.getGender(), 60, 340);
    text(me.getEmail(), 60, 360);
  } catch(FacebookException e) {
    println(e);
    exit();
  }
}