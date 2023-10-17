#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
else

  if [[ $1 =~ ^[0-9]*$ ]]
  then
  num=$1
  elif [[ $1 =~ ^[A-Z][a-z]{,2}$ ]]
  then
  num=$($PSQL "select atomic_number from elements where symbol='$1'")
  else
  num=$($PSQL "select atomic_number from elements where name='$1'")
  fi

res=$($PSQL "select atomic_number, elements.name, elements.symbol,types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius from elements full join properties using (atomic_number) full join types using (type_id) where atomic_number=$num")
if [[ -z $res ]]
then
echo "I could not find that element in the database."
else
echo $res | sed 's/|/ /g' | while read a1 a2 a3 a4 a5 a6 a7
do
echo "The element with atomic number $a1 is $a2 ($a3). It's a $a4, with a mass of $a5 amu. $a2 has a melting point of $a6 celsius and a boiling point of $a7 celsius."
done



fi
fi
