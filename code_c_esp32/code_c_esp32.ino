#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "WifiA55";
const char* password = "zion1111";
const char* serverUrl = "http://192.168.94.249:3000/api/data";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connexion au WiFi...");
  }
  Serial.println("Connecté au WiFi");
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/json");

    // Créez un JSON avec les données
    String jsonData = "{\"temperature\": 23.5, \"humidity\": 60.0}";

    int httpResponseCode = http.POST(jsonData);

    if (httpResponseCode > 0) {
      Serial.println("Données envoyées : " + String(httpResponseCode));
    } else {
      Serial.println("Erreur lors de l'envoi : " + String(http.errorToString(httpResponseCode).c_str()));
    }
    http.end();
  }
  delay(10000); // Envoi toutes les 10 secondes
}