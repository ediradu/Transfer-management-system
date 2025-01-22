import pyodbc
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import Normalize

class MSSQLConnection:
    def __init__(self):
        self.host = 'localhost\\SQLEXPRESS'
        self.database = 'football_transfers'
        self.username = 'becali'
        self.password = 'miei123'

    def openConnection(self):
        try:
            self.db = pyodbc.connect(
                f'DRIVER={{ODBC Driver 18 for SQL Server}};'
                f'SERVER={self.host};'
                f'DATABASE={self.database};'
                f'UID={self.username};'
                f'PWD={self.password};'
                f'ENCRYPT=yes;TrustServerCertificate=yes'
            )
            self.cursor = self.db.cursor()
            print("Connection open!")
        except Exception as e:
            print("Connection not open!")
            print(e)

    def closeConnection(self):
        try:
            self.cursor.close()
            self.db.close()
            print("Connection closed!")
        except Exception as e:
            print("Connection not closed!")
            print(e)

    def fetchData(self, procedure):
        try:
            self.cursor.execute(procedure)
            return self.cursor.fetchall()
        except Exception as e:
            print(f"Error executing {procedure}: {e}")
            return []

def plotLeaguesWithHighestSalaries(data):
    leagues = [row[1] for row in data]
    total_salaries = [row[2] for row in data]
    average_salaries = [row[3] for row in data]

    fig, ax = plt.subplots(figsize=(12, 6))

    ax.bar(leagues, total_salaries, color='skyblue', label='Total Salaries', alpha=0.8)
    ax.bar(leagues, average_salaries, color='orange', label='Average Salaries', alpha=0.8)

    ax.set_xlabel('Leagues')
    ax.set_ylabel('Salaries')
    ax.set_title('Leagues With Highest Salaries (Stacked)')
    ax.legend()
    plt.xticks(rotation=60, ha="right")
    plt.tight_layout()
    plt.show()


# Plot for Leagues With Most Foreign Players
def plotLeaguesWithMostForeignPlayers(data):
    leagues = [row[1] for row in data]
    foreign_players_count = [row[2] for row in data]

    plt.bar(leagues, foreign_players_count, color='g', alpha=0.7)
    plt.xlabel('Leagues')
    plt.ylabel('Number of Foreign Players')
    plt.title('Leagues With Most Foreign Players')
    plt.xticks(rotation=45, ha='right')  # Ajustăm rotația etichetelor
    plt.tight_layout()
    plt.show()

def plotTopPlayersByLeague(data):
    leagues = [row[0] for row in data]  # Ligile
    player_names = [row[2] for row in data]  # Numele jucătorilor
    goals = [row[3] for row in data]  # Golurile marcate

    # Obținem o listă de culori unice pentru fiecare ligă
    unique_leagues = list(set(leagues))
    cmap = plt.cm.get_cmap('rainbow', len(unique_leagues))  # Paleta extinsă cu multe culori
    league_colors = {league: cmap(i) for i, league in enumerate(unique_leagues)}

    fig, ax = plt.subplots(figsize=(14, 8))

    # Creăm un bar chart pentru fiecare jucător, colorat în funcție de ligă
    for i in range(len(data)):
        ax.bar(
            player_names[i], goals[i],
            color=league_colors[leagues[i]],
            alpha=0.8,
            edgecolor='black'
        )

    # Setăm etichetele axelor și titlul
    ax.set_xlabel('Players')
    ax.set_ylabel('Goals')
    ax.set_title('Top Players by League')

    # Rotim etichetele de pe axa X pentru a evita suprapunerea
    plt.xticks(rotation=60, ha="right", fontsize=8)

    # Creăm o legendă care să arate toate ligile, cu multe coloane
    handles = [plt.Line2D([0], [0], color=color, lw=4) for color in league_colors.values()]
    labels = list(league_colors.keys())
    ax.legend(
        handles, labels, title="Leagues", loc="upper center", bbox_to_anchor=(0.5, -0.15),
        ncol=6, frameon=False  # 6 coloane pentru o mai bună organizare
    )

    plt.tight_layout()
    plt.show()





# Main
if __name__ == "__main__":
    connection = MSSQLConnection()
    connection.openConnection()

    print("Fetching leagues with highest salaries...")
    salaries_data = connection.fetchData("EXEC GetLeaguesWithHighestSalaries;")
    if salaries_data:
        plotLeaguesWithHighestSalaries(salaries_data)

    print("Fetching leagues with most foreign players...")
    foreign_players_data = connection.fetchData("EXEC GetLeaguesWithMostForeignPlayers;")
    if foreign_players_data:
        plotLeaguesWithMostForeignPlayers(foreign_players_data)

    print("Fetching top players by league...")
    top_players_data = connection.fetchData("EXEC GetTopPlayersByLeague;")
    if top_players_data:
        plotTopPlayersByLeague(top_players_data)

    connection.closeConnection()
