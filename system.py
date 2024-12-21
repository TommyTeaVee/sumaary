import pyodbc
import pandas as pd
import os
import tkinter as tk
from tkinter import messagebox
from tkinter.ttk import Treeview
from pygame import mixer

# Database connection
elec_file_out_path = 'C:\\30_seconds'
server = 'LAB105JWZGK3'
database = '30_Seconds'
trusted_connection = 'Yes'
cnxn = pyodbc.connect(
    f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};trusted_connection={trusted_connection}'
)

# Tkinter App
class GameApp:
    def __init__(self, root):
        self.root = root
        self.root.title("30 Seconds Game")
        self.game_id = None
        self.player_id = None
        self.players = []
        self.current_player_index = 0
        self.score = 0

        self.setup_ui()

    def setup_ui(self):
        """Set up the main UI elements"""
        # Game Selection Frame
        self.game_frame = tk.Frame(self.root)
        self.game_frame.pack(pady=10)

        self.game_label = tk.Label(self.game_frame, text="Select Game:")
        self.game_label.grid(row=0, column=0, padx=5)

        self.game_combo = tk.StringVar()
        self.game_dropdown = tk.OptionMenu(self.game_frame, self.game_combo, *self.get_game_list())
        self.game_dropdown.grid(row=0, column=1, padx=5)

        self.start_button = tk.Button(self.game_frame, text="Start Game", command=self.start_game)
        self.start_button.grid(row=0, column=2, padx=5)

        self.create_game_button = tk.Button(self.game_frame, text="Create Game", command=self.create_game)
        self.create_game_button.grid(row=0, column=3, padx=5)

        # Player Identification Frame
        self.player_frame = tk.Frame(self.root)
        self.player_frame.pack(pady=10)

        self.player_label = tk.Label(self.player_frame, text="Players:")
        self.player_label.grid(row=0, column=0, padx=5)

        self.player_entry = tk.Entry(self.player_frame)
        self.player_entry.grid(row=0, column=1, padx=5)

        self.add_player_button = tk.Button(self.player_frame, text="Add Player", command=self.add_player)
        self.add_player_button.grid(row=0, column=2, padx=5)

        self.players_list_label = tk.Label(self.player_frame, text="No players added.")
        self.players_list_label.grid(row=1, column=0, columnspan=3, pady=5)

        # Achievements Frame
        self.achievement_frame = tk.Frame(self.root)
        self.achievement_frame.pack(pady=10)

        self.achievement_label = tk.Label(self.achievement_frame, text="Player Achievements")
        self.achievement_label.pack()

        self.tree = Treeview(self.achievement_frame, columns=("Player", "Score", "Stars"), show="headings")
        self.tree.heading("Player", text="Player")
        self.tree.heading("Score", text="Score")
        self.tree.heading("Stars", text="Stars")
        self.tree.pack()

        # Dice Roll Button
        self.dice_frame = tk.Frame(self.root)
        self.dice_frame.pack(pady=10)

        self.roll_dice_button = tk.Button(self.dice_frame, text="Roll Dice", command=self.roll_dice)
        self.roll_dice_button.pack()

    def get_game_list(self):
        """Fetch the list of games from the database"""
        df = pd.read_sql("SELECT game_id, game_name FROM game", cnxn)
        return [f"{row['game_id']} - {row['game_name']}" for _, row in df.iterrows()]

    def start_game(self):
        """Start the selected game"""
        if not self.game_combo.get():
            messagebox.showerror("Error", "Please select a game.")
            return

        if not self.players:
            messagebox.showerror("Error", "Please add at least one player.")
            return

        self.game_id = int(self.game_combo.get().split(" - ")[0])
        self.current_player_index = 0
        self.play_game()

    def create_game(self):
        """Create a new game"""
        new_game_window = tk.Toplevel(self.root)
        new_game_window.title("Create Game")

        tk.Label(new_game_window, text="Game Name:").grid(row=0, column=0, padx=5, pady=5)
        game_name_entry = tk.Entry(new_game_window)
        game_name_entry.grid(row=0, column=1, padx=5, pady=5)

        tk.Label(new_game_window, text="Game Description:").grid(row=1, column=0, padx=5, pady=5)
        game_desc_entry = tk.Entry(new_game_window)
        game_desc_entry.grid(row=1, column=1, padx=5, pady=5)

        def save_game():
            game_name = game_name_entry.get()
            game_desc = game_desc_entry.get()

            if not game_name or not game_desc:
                messagebox.showerror("Error", "All fields are required.")
                return

            cursor = cnxn.cursor()
            cursor.execute("EXEC sp_create_game ?, ?", (game_name, game_desc))
            cnxn.commit()
            messagebox.showinfo("Success", "Game created successfully!")
            new_game_window.destroy()

        tk.Button(new_game_window, text="Save", command=save_game).grid(row=2, column=0, columnspan=2, pady=10)

    def add_player(self):
        """Add a player to the game"""
        player_name = self.player_entry.get()

        if not player_name:
            messagebox.showerror("Error", "Player name cannot be empty.")
            return

        self.players.append(player_name)
        self.player_entry.delete(0, tk.END)
        self.update_players_list()

    def update_players_list(self):
        """Update the list of players displayed"""
        self.players_list_label.config(text=f"Players: {', '.join(self.players)}")

    def roll_dice(self):
        """Roll the dice for the current player"""
        if not self.players:
            messagebox.showerror("Error", "No players to roll dice for.")
            return

        current_player = self.players[self.current_player_index]
        dice_roll = pd.read_sql("SELECT dbo.fn_roll_dice() AS dice_roll", cnxn).iloc[0]["dice_roll"]
        messagebox.showinfo("Dice Roll", f"{current_player} rolled: {dice_roll}")

        score = int(self.score) - dice_roll
        self.score = score

        # Update achievements
        self.tree.insert("", "end", values=(current_player, score, "⭐" * min(score, 5)))

        # Switch to the next player
        self.current_player_index = (self.current_player_index + 1) % len(self.players)

    def play_game(self):
        """Play the game"""
        mixer.init()
        mixer.music.load("./drumroll-93348.mp3")
        mixer.music.play()

if __name__ == "__main__":
    root = tk.Tk()
    app = GameApp(root)
    root.mainloop()
