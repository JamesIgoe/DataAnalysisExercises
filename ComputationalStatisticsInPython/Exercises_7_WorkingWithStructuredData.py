
""" Working with Text (http://people.duke.edu/~ccc14/sta-663/WorkingWithStructuredData.html"""

""" Exercises: """

#Working example dataset
import statsmodels.api as sm
heart = sm.datasets.heart.load_pandas().data
heart.take(np.random.choice(len(heart), 6))

import sqlite3
conn = sqlite3.connect('heart.db')

#Creating and populating a table
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS transplant
             (survival integer, censors integer, age real)''')
c.executemany("insert into transplant(survival, censors, age) values (?, ?, ?)", heart.values);



