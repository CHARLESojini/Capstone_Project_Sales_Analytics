# First, you need to create a proper database connection with the correct credentials
from sqlalchemy import create_engine

# Replace these with your actual database credentials
username = "postgres"
password = "Amaka2012"  # Make sure to use the correct password
host = "localhost"
port = "5433"
database = "Sales_analytics"

# Create the database connection string
connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"

# Create the SQLAlchemy engine
engine = create_engine(connection_string)

try:
    with engine.connect() as conn:
        print("✅ Connection successful!")
except Exception as e:
    print("❌ Connection failed:", e)


# Now use the engine to write your dataframes to the database
dates_df.to_sql("date", engine, if_exists='replace', index=False)
products_df.to_sql("products", engine, if_exists='replace', index=False)
customer_df.to_sql("customers", engine, if_exists='replace', index=False)

# Finally, create the fact table that depends on the dimension tables
fact_sales_df.to_sql("sales", engine, if_exists='replace', index=False)