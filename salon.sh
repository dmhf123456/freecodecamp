#!/bin/bash
#psql --username=freecodecamp --dbname=salon -c "SQL QUERY HERE"

MAIN_MENU(){
echo $(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "select * from services") | sed 's/ /\n/g; s/|/) /g';  
echo "enter service_id"
read SERVICE_ID_SELECTED
SERVICE_ID_SELECTED=$(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "select service_id from services where service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_ID_SELECTED ]]
then
MAIN_MENU
else
echo "enter phone number"
read CUSTOMER_PHONE
NEW=$(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "select phone from customers where phone='$CUSTOMER_PHONE'")
if [[ -z $NEW ]]
then
echo "enter name"
read CUSTOMER_NAME
INSERTNEW=$(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "insert into customers (phone,name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi
echo "enter time"
read SERVICE_TIME
GETCUSTOMERID=$(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "select customer_id from customers where phone='$CUSTOMER_PHONE'")

INSERTNEWAPPT=$(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "insert into appointments (customer_id,service_id,time) values ($GETCUSTOMERID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "select name from services where service_id=$SERVICE_ID_SELECTED")

CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "select name from customers where phone='$CUSTOMER_PHONE'")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}
MAIN_MENU
