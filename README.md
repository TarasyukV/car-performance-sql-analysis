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
- price_in_usd (numeric)
## Data Cleaning

Before performing the analysis, several data cleaning and transformation steps were applied to prepare the dataset for accurate SQL querying:

1. A new column `type_of_engine` was created to distinguish between electric and non-electric vehicles.
2. All values labeled as `Electric` were moved from the `engine_size` column to the `type_of_engine` column.  
   The corresponding values in `engine_size` were replaced with `NULL`.
3. The value `No Electric` was assigned to `type_of_engine` for all remaining records with a specified engine size.
4. All `N/A` values across the dataset were replaced with `NULL` to ensure proper handling of missing data.
5. In the `horsepower` column, non-numeric symbols (such as `+` in values like `1000+`) were removed, and the column was converted to a numeric data type to allow accurate aggregations.
   
   5.1 The same cleaning logic was applied to the `torque` column.
6. The `price_usd` column was converted to a numeric format by removing thousands separators and ensuring consistent numeric values.

These steps ensured consistent data types and improved data quality for reliable analytical results.

