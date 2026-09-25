import matplotlib.pyplot as plt
import pandas as pd
from dotenv import dotenv_values
from sqlalchemy import create_engine

config = dotenv_values()

# define variables for the login
pg_user = config['POSTGRES_USER']  # align the key label with your .env file !
pg_host = config['POSTGRES_HOST']
pg_port = config['POSTGRES_PORT']
pg_db = config['POSTGRES_DB']
pg_schema = config['POSTGRES_SCHEMA']
pg_pass = config['POSTGRES_PASS']

# 1. connect to the database
url = f'postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}'
engine = create_engine(url, echo=False)

# 2. read the dbt model
query = f'SELECT * FROM {pg_schema}.mart_delay_by_temperature ORDER BY temp_band'
df = pd.read_sql(query, engine)
print(df)

# 3. draw the chart
labels = [b.split('. ')[1] for b in df['temp_band']]
values = df['avg_dep_delay_min']
colors = ['#eb6834' if b.startswith('3.') else '#2a78d6' for b in df['temp_band']]

plt.figure(figsize=(9, 5))
plt.bar(labels, values, color=colors, width=0.5)

for x, y in zip(labels, values):
    plt.text(x, y + 0.4, f'{y:.1f}', ha='center', fontweight='bold')

plt.title('Departure delays peak near freezing, not in extreme cold', fontweight='bold')
plt.ylabel('Average departure delay (minutes)')
plt.grid(axis='y', alpha=0.3)
plt.tight_layout()

# 4. save it
plt.savefig('images/delay_by_temperature.png', dpi=200)
print('saved images/delay_by_temperature.png')
