#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~ My Salon ~~\n"
echo -e "How may I help you?\n"

MAIN_MENU() {
 #LIST_OF_SERVICES_BY_SED_METHOD 
 MENU_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
 echo "$MENU_SERVICES" | sed -E 's/^ *| *$//g' | sed -E 's/ \|/)/g'
 if [[ $1 ]]
 then
 echo -e "\n$1"
 fi 
 echo -e "\nPlease select an option above:"
 read SERVICE_ID_SELECTED
 #IF NOT EXIST
 #GET_ID_SELECT
 SERVICE_ID_SELECTED_QUERY=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

 if [[ -z $SERVICE_ID_SELECTED_QUERY ]] 
  then
 
  MAIN_MENU "I could not find that service. What would you like today?"
  else
 
  #Do QUESTION
  echo -e "\nWhat's you Phone Number"
  #READ VARIABLE 
  read CUSTOMER_PHONE
  #QUERY PHONE NUMBER
  QUERY_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
 
   #IF NOT FOUND
   if [[ -z $QUERY_PHONE_NUMBER ]]
    then
     echo -e "\nI don't have a record for that phone number, what's your name?\n"
     read CUSTOMER_NAME
     #INSERT DATA CUSTOMER
     INSERT_DATA_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
     #GET PHONE NUMBER
     PHONE_NUMBER_IN_DATABASE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
     #GET ID CUSTOMER
     CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
     #GET NAME CUSTOMER FROM DB
      NAME_IN_DATABASE=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      #GET NAME OF SERVICE
      SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED_QUERY")
      
      echo -e "\nWhat time would you like your$SERVICE_SELECTED,$CUSTOMER_NAME?\n"
 
      read SERVICE_TIME
      #INSERT CHOSEN TIME
      INSERT_TIME_TO_APPOINMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID ,'$SERVICE_ID_SELECTED_QUERY','$SERVICE_TIME')")
      #OUTPUT_MESSAGE
      echo -e "\nI have put you down for a$SERVICE_SELECTED at $SERVICE_TIME,$NAME_IN_DATABASE.\n"
      
   fi
      
      
  
 fi
 
}
echo -e "\nWelcome to My Salon, how can i help you?\n"

MAIN_MENU