#include <SPI.h>
#include <MFRC522.h>
#include <WiFi.h>
#include <HTTPClient.h>

#define SS_PIN 2
#define RST_PIN 1
#define LED_RED 3
#define LED_GRE 4

const char* ssid = "Hippolyteee";
const char* password = "hipopo123";
const String serverUrl = "http://192.168.122.82:33000/check-badge";

MFRC522 mfrc522(SS_PIN, RST_PIN); // Instance MFRC522

void setup() {
  Serial.begin(115200);
  pinMode(LED_RED, OUTPUT);
  pinMode(LED_GRE, OUTPUT);
  SPI.begin(6, 8, 7, SS_PIN); // Initialisation SPI
  mfrc522.PCD_Init(); // Initialisation du lecteur RFID
  
  Serial.println("Initialisation du système...");
  
  connectToWiFi();
}

void loop() {
  if (!mfrc522.PICC_IsNewCardPresent() || !mfrc522.PICC_ReadCardSerial()) {
    return; // Aucune nouvelle carte détectée
  }

  String uid = getCardUID();
  Serial.println("UID détecté : " + uid);

  if (isBadgeAuthorized(uid)) {
    grantAccess();
  } else {
    denyAccess();
  }

  delay(1000); // Petite pause pour éviter une détection rapide en boucle
}

// --- Fonctions Utilitaires ---
void connectToWiFi() {
  Serial.print("Connexion au Wi-Fi : ");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWi-Fi connecté avec IP : " + WiFi.localIP().toString());
}

String getCardUID() {
  String uid = "";
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    if (mfrc522.uid.uidByte[i] < 0x10) uid += "0";
    uid += String(mfrc522.uid.uidByte[i], HEX);
  }
  uid.toUpperCase();
  return uid;
}

bool isBadgeAuthorized(String uid) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("Erreur : Wi-Fi non connecté.");
    return false;
  }

  HTTPClient http;
  String url = serverUrl + "?uid=" + uid;

  Serial.println("Envoi de la requête à : " + url);
  http.begin(url);
  int httpResponseCode = http.GET();

  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.println("Réponse reçue : " + response);
    http.end();
    return response.indexOf("\"status\":\"success\"") >= 0;
  } else {
    Serial.println("Erreur lors de la requête HTTP. Code : " + String(httpResponseCode));
  }
  
  http.end();
  return false;
}

void grantAccess() {
  Serial.println("Accès autorisé.");
  digitalWrite(LED_GRE, HIGH);
  delay(1000);
  digitalWrite(LED_GRE, LOW);
}

void denyAccess() {
  Serial.println("Accès refusé.");
  digitalWrite(LED_RED, HIGH);
  delay(1000);
  digitalWrite(LED_RED, LOW);
}