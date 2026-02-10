# Sportcars-performance-sql-analysis
A PostgreSQL project analyzing car performance and pricing, including data cleaning and exploratory analysis.
## Project Overview
This project was created to explore various sports car manufacturers and their top-performing models, as well as to analyze the relationship between price, brand, and performance characteristics.
The main objective is to derive insights that can help understand how performance metrics and brand influence sports car pricing.
## Dataset

- **Source:** [Kaggle – Sports Car Dataset](https://www.kaggle.com/datasets/sadiajavedd/sports-car-speed-power-and-pricing-dataset)
- **Format:** CSV
- **About dataset:**  
  This dataset contains information about high-performance sports cars from various manufacturers and model years. It includes key technical specifications, performance metrics, and pricing data that allow analysis of how vehicle performance and brand relate to market price. The dataset covers attributes such as engine type and size, horsepower, torque, acceleration (0–60 mph), model year, and price in USD.
### Key Columns (after data cleaning)

- car_make (text)
- car_model (text)
- year (integer)
- engine_type (text: Electric / Non-Electric)
- engine_size (numeric)
- horsepower (integer)
- torque (integer)
- zero_to_sixty_time (numeric, seconds)
- price_usd (numeric)
