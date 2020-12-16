#include <FirebaseESP32.h>
#include <string.h>
#include "DHT.h"

#define MQ 34
#define pinoDHT11 26
#define DHTTYPE DHT11
#define ledSupressao 27

#define HOST "controle-de-incendio.firebaseio.com"
#define DBKEY "aLFh7i8DxeQTiSBLyoFPKF1OjUIK3xETGZPVttUw"

#define WF_SSID "VIVOFIBRA-49B7"
#define WF_PASSWORD "72233E49B7"

FirebaseData firebaseData;

FirebaseJson json;
FirebaseJsonData jsonObj;

DHT dht(pinoDHT11, DHTTYPE);

/*Configuracoes do dispositivo*/
int dispositivo = 1;

/*Variaveis para ativacao do alerta*/
int gas_threshold = 800;
int temp_threshold = 30;
int humi_threshold = 80;
int atendido = 0;

/*Variaveis para controle do codigo*/
int mq_input = 0;
int dispositivoStatus = 1; // 1->ligado ; 2->acionado
int temperatura = 0;
int umidade = 0;
int ocorrencias = 1;
String cliente = "-MOd3aDctMh9rfi2vEyN";
String caminhoParam = "/instalacao/"+cliente;
String caminhoOcorrencia = "/ocorrencias/";

// Recebe parametros de threshhold do servidor
void pegaParam(){
  Firebase.get(firebaseData, caminhoParam);
  json = firebaseData.jsonObject();
  
  json.get(jsonObj, "gas_threshold");
  gas_threshold = jsonObj.intValue;

  json.get(jsonObj, "temp_threshold");
  temp_threshold = jsonObj.intValue;

  json.get(jsonObj, "humi_threshold");
  humi_threshold = jsonObj.intValue;

  Serial.println(gas_threshold);
  Serial.println(temp_threshold);
  Serial.println(humi_threshold);
}

void acionamento(){
  Firebase.get(firebaseData, caminhoOcorrencia+String(ocorrencias));

  json = firebaseData.jsonObject();
  json.get(jsonObj, "atendido");
  atendido = jsonObj.intValue;
  Serial.println(atendido);
}

void setup() {
  WiFi.begin(WF_SSID, WF_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Connecting to WiFi..");
  }
  Serial.println("WiFi connected.");
  Firebase.begin(HOST, DBKEY);
  Firebase.reconnectWiFi(true);

  dht.begin();
  pinMode(MQ, INPUT);
  pinMode(ledSupressao, OUTPUT);
  Serial.begin(115200);
  pegaParam();
}

void loop() {
  if(dispositivoStatus == 1){
    mq_input = analogRead(MQ);
    temperatura = dht.readTemperature();
    umidade = dht.readHumidity();
    
    if(temperatura > (temp_threshold*1.5)){
      dispositivoStatus = 2;
      atendido = 1;
      enviarDados();
    }else if(temperatura > (temp_threshold)){
      dispositivoStatus = 2;
      enviarDados();
    }else if(mq_input > (gas_threshold*1.5)){
      dispositivoStatus = 2;
      atendido = 1;
      enviarDados();
    }else if (mq_input > (gas_threshold)){
      dispositivoStatus = 2;
      enviarDados();
    }
  }else if(dispositivoStatus == 2){
    acionamento();

    if(atendido == 1){
      digitalWrite(ledSupressao, HIGH);
      atendido = 0;
      dispositivoStatus = 1;
      ocorrencias++;
      
      delay(5000);
      
      digitalWrite(ledSupressao, LOW);
    }
  }
}


bool enviarDados(){
  FirebaseJson ocorrencia;  
  ocorrencia.set("dispositivo", 1);
  ocorrencia.set("atendido",atendido);
  ocorrencia.set("densidade_fumaca",mq_input);
  ocorrencia.set("temperatura",temperatura);
  ocorrencia.set("umidade", umidade);
  Firebase.set(firebaseData, caminhoOcorrencia+String(ocorrencias), ocorrencia);
  
}
