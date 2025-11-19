# Capstone Project
👥 CUSTOMERS                    📦 PRODUCTS
(who bought)                              (what sold)
     ↓                     ↓                   ↓
          💰 SALES (the main records)
                    ↓
              📅 DATES (when sold)


Each table talks to the others so we can connect information easily!



 Project Files 

File | What It Does |

`sales_analytics__entity.drawio` | Visual diagram showing how tables connect |
`sales_analytics.ipynb` | Python code that cleans and organizes data |
`Sales_analytics_quries.sql` | Ready-to-use questions we can ask the database |
`README.md` | This file - explains everything! |



 Real Business Questions We Answer 

Money Questions:
Average monthly sales per product - Which items consistently make money?
Cities with top 5% revenue** - Our superstar locations
Monthly profit trends - Are we growing or shrinking?

 Customer Questions:
Top 20 customers** - Who spends the most with us?
Customer behavior by location - Where are loyal customers?

Product Questions:
Best-selling categorie - What should we stock more of?
Product performance by subcategory - Deep dive into what works

 Problem Detection:
Cities with low profitability (under 10%) - Where we're struggling
Underperforming regions- Need attention or strategy change



 How It Works (Step-by-Step)

 Step 1: Clean the Data 

Messy spreadsheet with errors
         ↓
Python cleans it up
         ↓
Perfect, organized data


### Step 2: Build the Database 

Create 5 tables:
- Customers
- Products  
- Dates
- Sales (connects everything)


Step 3: Connect Everything 

Add relationships between tables
(like connecting puzzle pieces)


 Step 4: Ask Questions 

Run SQL queries
         ↓
Get instant answers!




Tools We Used 

Python - Programming language for cleaning data
Pandas- Library for organizing data
PostgreSQL - Database that stores everything
SQL - Language to ask the database questions
Jupyter Notebook - Where we write and test code



 Sample Insights We Can Get 

Example 1: Monthly Performance

Month        Revenue    Profit    Orders
Jan 2024     $50,000    $12,000   450
Feb 2024     $55,000    $14,000   480
Mar 2024     $62,000    $16,000   520


Example 2: Top Cities

City            Revenue     Profit Margin
New York        $500,000    15%
Los Angeles     $450,000    18%
Chicago         $380,000    12%


Example 3: Problem Areas

City        Revenue    Profit Margin
Detroit     $50,000    3%  ← Needs attention!
Cleveland   $45,000    5%  ← Low profit