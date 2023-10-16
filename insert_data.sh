#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate table teams,games");

tail -n +2 games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
test1= $($PSQL "select name from teams where name='$winner'")
if [[ -z $test1 ]]
  then 
  $($PSQL "insert into teams (name) values ('$winner')")
fi

test2= $($PSQL "select name from teams where name='$opponent'")
if [[ -z $test2 ]]
  then 
  $($PSQL "insert into teams (name) values ('$opponent')")
fi

winner_id=$($PSQL "select team_id from teams where name='$winner'")
opponent_id=$($PSQL "select team_id from teams where name='$opponent'")

$($PSQL "insert into games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($year,'$round',$winner_id,$opponent_id,$winner_goals,$opponent_goals)");
done

#echo $($PSQL "select * from teams");
#echo $($PSQL "select * from games");
