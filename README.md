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
        self.player_id = 1
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

    def get_game_list(self):
        """Fetch the list of games from the database"""
        df = pd.read_sql("SELECT game_id, game_name FROM game", cnxn)
        return [f"{row['game_id']} - {row['game_name']}" for _, row in df.iterrows()]

    def start_game(self):
        """Start the selected game"""
        if not self.game_combo.get():
            messagebox.showerror("Error", "Please select a game.")
            return

        self.game_id = int(self.game_combo.get().split(" - ")[0])
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

    def play_game(self):
        """Play the game"""
        mixer.init()
        mixer.music.load("./drumroll-93348.mp3")
        mixer.music.play()

        dice_roll = pd.read_sql("SELECT dbo.fn_roll_dice() AS dice_roll", cnxn).iloc[0]["dice_roll"]
        messagebox.showinfo("Dice Roll", f"You rolled: {dice_roll}")

        score = int(self.score) - dice_roll
        self.score = score

        # Update achievements
        self.tree.insert("", "end", values=("Player 1", score, "⭐" * min(score, 5)))
        
        if score > 3:
            mixer.music.load("./mega-horn-angry-siren-f-cinematic-trailer-sound-effects-193408.mp3")
            mixer.music.play()

if __name__ == "__main__":
    root = tk.Tk()
    app = GameApp(root)
    root.mainloop()
