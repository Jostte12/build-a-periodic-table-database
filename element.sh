#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ $1 ]]
then 

  # if (( $1 == 1 | $1 == 'H' | $1 == 'Hydrogen' ))
  # then
  #   echo  "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
  # fi
  if [[ $1 =~ [0-9]+ ]]
  then
    ELEMENT=$($PSQL "SELECT properties.atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON types.type_id = properties.type_id WHERE (elements.atomic_number = $1)")
     
  else 
    ELEMENT=$($PSQL "SELECT properties.atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON types.type_id = properties.type_id WHERE (elements.symbol = '$1' OR elements.name = '$1')")
    
  fi
  
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."

  else
    echo $ELEMENT | while IFS="|" read NUMBER TYPE MASS MELTING BOILING SYMBOL NAME
    do
      echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
  


else
  echo "Please provide an element as an argument."

fi
