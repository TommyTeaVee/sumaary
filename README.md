# sumaary
import pyodbc
import pandas as pd
import time
import os
import tkinter as tk


date_var = None ##'2023-05-12'

import pandas as pd
#from pyathena import connect
import numpy as np
from datetime import datetime, timedelta
from dateutil.relativedelta import *
import subprocess
from subprocess import PIPE

elec_file_out_path = 'C:\30_seconds'
server = 'LAB105JWZGK3' 
database = '30_Seconds' 
trusted_connection = 'Yes' 
games = 'select max(game_id) game_id from game'

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';trusted_connection = Yes')

cursor = cnxn.cursor()

#To identify the player
player_id = 1
add_player ='y'
cont = "y" 
game_data = 'select game_id [ID], game_name [Game Name ] from game'
df = pd.read_sql(game_data,cnxn)
score = 0

print("Commencing Extracting game data....")
game_data = 'select game_id [ID],game_name [Game Name] from game'
df = pd.read_sql(game_data,cnxn)

def play_game(game_id,player_id):
    from pygame import mixer #load the popular external library
    
    mixer.init()
    mixer.music.load("C:/30_seconds/drum-roll.mp3")
    mixer.music.play()  

    #throw dice
    ans = input("press any key to roll a dice:\n")
    roll = 'select dbo.fn_roll_dice() dice_roll'
    df_roll = pd.read_sql(roll,cnxn)

    die_roll = df_roll["dice_roll"][0]
    print("you dice number: " + str(die_roll))

    #Card Flip
    ans = input("press any key to flip the card:\n")
    os.system('cls||clear')

    # A stored procedure 
    cnxn.execute('exec sp_generate_card')
    cnxn.commit()
    df_card = pd.read_sql('select * from temp_card',cnxn)

    print(df_card)

    import time
    time.sleep(30)

    os.system('cls|| clear')

    #Score Entry
    score = input("Enter score:")
    score = int(score)
    
    player_id = int(player_id)
    die_roll = int(die_roll)
    #Minus current score by dice number
    p_score = score - die_roll
    print("Your updated score is: " + str(p_score))
    cnxn.execute("exec sp_add_score ?, ?, ?, ?;",(game_id, player_id, die_roll, p_score))
#cnxn.execute("exec sp_create_game ?, ?;", (game_name, game_desc))

    cnxn.commit()

    if score > 3:
        mixer.init()
        #  mixer.music.load("\\C:\30_seconds\\mega-horn-angry-siren.mp3")
        mixer.music.load("C:/30_seconds/mega-horn-angry-siren.mp3")
        mixer.music.play()


print("\n\nWelcome to 30 Seconds\n")

print(df.to_string(index=False))

game_id = input("\n\nSelect Game or press 0 to create a new one: \n")

if game_id == "0":
    print("Creating New Game")
    game_name = input("Please Enter Game Name: ")  
    game_desc = input("Please Enter Game Description: ")  
    cursor = cnxn.cursor()
    num_of_teams = input("What is the number of teams to play?")
    num_of_teams = int(num_of_teams)

    while num_of_teams < 5:
        print("Creating new team\n")
        team_name = input("Enter team name:")
        team_desc = input("Enter Team Description: ")
        cnxn.execute("exec sp_create_team ?, ?;", (team_name, int(game_id)))
        num_of_teams = num_of_teams - 1
        #cursor = cnxn.cursor()

        team_scr = "select max(team_id) team_id from tbl_team"
        df_team = pd.read_sql(team_scr,cnxn)
        team_id = df_team["team_id"][0]
        add_player = "y"

        while add_player == "y":
            print("\nAdd player")
            player_name = input("Enter Player Name: ")
            email = input("Enter Email: ")
            
            cnxn.execute("exec sp_add_player ?, ?, ?;", (player_name, email, int(team_id)))
        
            add_player = input(f"\nWould you like to add a new player to the team? (team name)? (y/n)")
        num_of_teams = num_of_teams + 1
        cnxn.commit()
    
    cnxn.execute("exec sp_create_game ?, ?;", (game_name, game_desc))
    #time.sleep(30)
    cnxn.commit()
    
    df_games = pd.read_sql(games,cnxn)
    
    game_id = df_games["game_id"][0]
    print(str(game_id))
    
    

else:  
    print("Old Game")
    game_id = input('select game_id from game')
       
    df_games = pd.read_sql(games,cnxn)
    
    if df_games.astype(str).isin([game_id]).any().any():
        game_id = int(game_id) 
        print("Starting game\n")
        play_game(game_id,player_id)
        
    else:
        print(f'Value {game_id} does not exist in the DataFrame')
        game_id = ""

    
def get_players():
         players_id = 2#

print(cont)
while cont != "N":
     play_game(game_id,player_id)
     cont = input("press any key for next team to play or N to exit")
     
