#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=test -t --no-align -c"

guess(){
read INPUT
if [[ $INPUT != $actual ]]
then  
  if [[ $INPUT =~ ^[0-9]*$ ]]
  then
    if [[ $INPUT -gt $actual ]]
    then
    echo "It's lower than that, guess again:";
    count=$(($count+1))  
    guess
    else  
    echo "It's higher than that, guess again:"  
    count=$(($count+1))  
    guess
    fi
  else
  echo "That is not an integer, guess again:"
  fi
else
count=$(($count+1))  
echo "You guessed it in $count tries. The secret number was $actual. Nice job!"
insert=$($PSQL "insert into record (name,numtries) values('$NAME', $count)")
fi
}


echo "Enter your username:"
read NAME
first=$($PSQL "select id from record where name='$NAME'")
if [[ -z $first ]]
then
echo "Welcome, $NAME! It looks like this is your first time here."
echo "Guess the secret number between 1 and 1000:"
actual=$((1 + $RANDOM % 1000))
count=0
#echo $actual;
guess;
else
games=$($PSQL "select count(*) from record where name='$NAME'");
#games=$(($games + 1));
best=$($PSQL "select min(numtries) from record where name='$NAME'")
echo "Welcome back, $NAME! You have played $games games, and your best game took $best guesses."
echo "Guess the secret number between 1 and 1000:"
actual=$((1 + $RANDOM % 1000))
count=0
#echo $actual;
guess;
fi




