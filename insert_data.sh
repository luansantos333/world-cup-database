#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS  

do 

    if [[ $YEAR != "year" ]]; then


      WINNER_TEAM_QUERY=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_TEAM_QUERY=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      
      if [[ -z $WINNER_TEAM_QUERY && -z $OPPONENT_TEAM_QUERY ]]; then

            WINNER_RES_QUERY=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")          
            OPPONENT_RES_QUERY=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")


      elif [[  -n $WINNER_TEAM_QUERY && -z $OPPONENT_TEAM_QUERY ]]; then

            OPPONENT_RES_QUERY=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")

      elif [[ -z $WINNER_TEAM_QUERY && -n $OPPONENT_TEAM_QUERY ]]; then

            WINNER_RES_QUERY=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")    


      fi

            GAME_QUERY_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
             GAME_QUERY_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
             GAME_QUERY_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals ) VALUES ($YEAR, '$ROUND', $GAME_QUERY_WINNER_ID, $GAME_QUERY_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

      if [[ $GAME_QUERY_RESULT == "INSERT 0 1" ]]; then

          echo -e "Inserted a new game row into Games table"


      fi



    fi

      if [[ $WINNER_RES_QUERY == "INSERT 0 1" || $OPPONENT_RES_QUERY ]]; then


          echo -e "Inserted with sucess a new team to the table teams\n"

      fi

done