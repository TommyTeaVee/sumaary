import tkinter as tk
from tkinter import messagebox, simpledialog
import random
import sqlite3


class QuizGame:
    def __init__(self, root):
        self.root = root
        self.root.title("30 Seconds Quiz Game")
        self.time_left = 30
        self.current_team_index = 0
        self.current_member_index = 0
        self.teams = []
        self.questions = []
        self.score = {}
        self.game_name = None
        self.timer_running = False
        self.load_questions()

        # Database setup
        self.setup_database()

        # UI Setup
        self.setup_ui()

    def setup_ui(self):
        """Setup the main UI components."""
        self.main_frame = tk.Frame(self.root)
        self.main_frame.pack(pady=10)

        self.title_label = tk.Label(self.main_frame, text="30 Seconds Quiz Game", font=("Arial", 18))
        self.title_label.grid(row=0, column=0, columnspan=2, pady=10)

        self.current_player_label = tk.Label(self.main_frame, text="", font=("Arial", 14), fg="blue")
        self.current_player_label.grid(row=1, column=0, columnspan=2, pady=10)

        self.timer_label = tk.Label(self.main_frame, text="Time Left: 30", font=("Arial", 14), fg="red")
        self.timer_label.grid(row=2, column=0, columnspan=2, pady=10)

        self.dice_button = tk.Button(self.main_frame, text="Roll Dice", command=self.roll_dice, state=tk.NORMAL)
        self.dice_button.grid(row=3, column=0, columnspan=2, pady=10)

        self.new_game_button = tk.Button(self.main_frame, text="New Game", command=self.new_game)
        self.new_game_button.grid(row=4, column=0, padx=5)

        self.load_game_button = tk.Button(self.main_frame, text="Load Game", command=self.load_game)
        self.load_game_button.grid(row=4, column=1, padx=5)

        # Quiz area
        self.quiz_frame = tk.Frame(self.root)
        self.quiz_frame.pack(pady=10)

        self.question_label = tk.Label(self.quiz_frame, text="", font=("Arial", 14), wraplength=400, justify="left")
        self.question_label.grid(row=0, column=0, columnspan=2, pady=10)

        self.answer_var = tk.StringVar()
        self.answer_buttons = []
        for i in range(4):  # 4 options
            button = tk.Radiobutton(self.quiz_frame, text="", variable=self.answer_var, value="", font=("Arial", 12))
            button.grid(row=i + 1, column=0, sticky="w")
            self.answer_buttons.append(button)

        self.submit_button = tk.Button(self.quiz_frame, text="Submit", command=self.submit_answer, state=tk.DISABLED)
        self.submit_button.grid(row=5, column=0, columnspan=2, pady=10)

    def setup_database(self):
        """Set up the SQLite database."""
        self.conn = sqlite3.connect("quiz_game.db")
        self.cursor = self.conn.cursor()
        self.cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS games (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                teams TEXT
            )
            """
        )
        self.conn.commit()

    def load_questions(self):
        """Load questions with correct and incorrect answers."""
        self.questions = [
            {"question": "What is 5 + 7?", "options": ["10", "12", "14", "8"], "answer": "12"},
            {"question": "What is the capital of France?", "options": ["Paris", "London", "Berlin", "Madrid"], "answer": "Paris"},
            {"question": "What color is the sky on a clear day?", "options": ["Blue", "Green", "Red", "Yellow"], "answer": "Blue"},
            {"question": "How many legs does a spider have?", "options": ["6", "8", "4", "10"], "answer": "8"},
            {"question": "What is the largest planet in our solar system?", "options": ["Earth", "Mars", "Jupiter", "Venus"], "answer": "Jupiter"},
        ]

    def new_game(self):
        """Start a new game."""
        self.game_name = simpledialog.askstring("Game Name", "Enter a name for the new game:")
        if not self.game_name:
            messagebox.showerror("Error", "Game name cannot be empty.")
            return

        self.setup_teams()

    def load_game(self):
        """Load an existing game."""
        self.cursor.execute("SELECT id, name FROM games")
        games = self.cursor.fetchall()
        if not games:
            messagebox.showinfo("No Games", "No saved games found.")
            return

        game_names = [f"{game[0]} - {game[1]}" for game in games]
        selected_game = simpledialog.askstring("Load Game", f"Available games:\n{', '.join(game_names)}")

        if not selected_game:
            return

        game_id = int(selected_game.split(" - ")[0])
        self.cursor.execute("SELECT teams FROM games WHERE id = ?", (game_id,))
        teams_data = self.cursor.fetchone()
        if teams_data:
            self.teams = eval(teams_data[0])
            self.start_game()

    def setup_teams(self):
        """Set up teams and team members."""
        num_teams = simpledialog.askinteger("Teams", "How many teams will participate?")
        if not num_teams or num_teams < 2:
            messagebox.showerror("Error", "You need at least 2 teams to play.")
            return

        for i in range(num_teams):
            team_name = simpledialog.askstring("Team Name", f"Enter the name for Team {i + 1}:")
            if not team_name:
                messagebox.showerror("Error", "Team name cannot be empty.")
                return

            num_members = simpledialog.askinteger("Team Members", f"How many members in {team_name}? (Must be even)")
            if not num_members or num_members % 2 != 0:
                messagebox.showerror("Error", "Number of team members must be even.")
                return

            members = []
            for j in range(num_members):
                name = simpledialog.askstring("Member Name", f"Enter name for member {j + 1} of {team_name}:")
                email = simpledialog.askstring("Member Email", f"Enter email for {name}:")
                members.append({"name": name, "email": email})

            self.teams.append({"name": team_name, "members": members})

        self.start_game()

    def start_game(self):
        """Start the game after setup or loading."""
        self.current_team_index = 0
        self.current_member_index = 0
        self.score = {team["name"]: 0 for team in self.teams}
        self.update_current_player()

    def update_current_player(self):
        """Update the label to show which player should roll the dice."""
        team = self.teams[self.current_team_index]
        member = team["members"][self.current_member_index]
        self.current_player_label.config(text=f"{member['name']} from {team['name']}, it's your turn to roll the dice!")
        self.dice_button.config(state=tk.NORMAL)
        self.timer_running = False

    def roll_dice(self):
        """Roll the dice for the current team member."""
        team = self.teams[self.current_team_index]
        member = team["members"][self.current_member_index]

        dice_roll = random.randint(1, 6)
        messagebox.showinfo("Dice Roll", f"{member['name']} from {team['name']} rolled a {dice_roll}!")
        self.start_timer()

    def start_timer(self):
        """Start the countdown timer for the current team member."""
        self.time_left = 30
        self.timer_running = True
        self.ask_question()
        self.update_timer()

    def ask_question(self):
        """Ask a question to the current team member."""
        question_data = random.choice(self.questions)
        self.current_question = question_data
        self.answer_var.set("")

        self.question_label.config(text=question_data["question"])
        for i, option in enumerate(question_data["options"]):
            self.answer_buttons[i].config(text=option, value=option)

        self.submit_button.config(state=tk.NORMAL)

    def submit_answer(self):
        """Check the answer and continue."""
        selected_answer = self.answer_var.get()
        if not selected_answer:
            messagebox.showwarning("No Answer", "You must select an answer!")
            return

        correct_answer = self.current_question["answer"]
        team_name = self.teams[self.current_team_index]["name"]
        if selected_answer == correct_answer:
            self.score[team_name] += 1

        self.ask_question()

    def update_timer(self):
        """Update the countdown timer."""
        if self.time_left > 0 and self.timer_running:
            self.time_left -= 1
            self.timer_label.config(text=f"Time Left: {self.time_left}")
            self.root.after(1000, self.update_timer)
        elif self.timer_running:
            self.next_turn()

    def next_turn(self):
        """Move to the next turn."""
        self.timer_running = False
        self.submit_button.config(state=tk.DISABLED)
        self.current_member_index += 1
        if self.current_member_index >= len(self.teams[self.current_team_index]["members"]):
            self.current_member_index = 0
            self.current_team_index += 1

        if self.current_team_index >= len(self.teams):
            self.end_game()
        else:
            self.update_current_player()

    def end_game(self):
        """End the game and display results."""
        results = "\n".join([f"{team}: {score}" for team, score in self.score.items()])
        messagebox.showinfo("Game Over", f"Game over! Final scores:\n{results}")

        # Save game to the database
        self.cursor.execute(
            "INSERT INTO games (name, teams) VALUES (?, ?)",
            (self.game_name, str(self.teams)),
        )
        self.conn.commit()

        self.dice_button.config(state=tk.DISABLED)
        self.submit_button.config(state=tk.DISABLED)


if __name__ == "__main__":
    root = tk.Tk()
    game = QuizGame(root)
    root.mainloop()
