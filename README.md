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

1. A new column `engine_type` was created to distinguish between electric and non-electric vehicles.
2. All values labeled as `Electric` were moved from the `engine_size` column to the `engine_type` column.  
   The corresponding values in `engine_size` were replaced with `NULL`.
3. The value `No Electric` was assigned to `engine_type` for all remaining records with a specified engine size.
4. All `N/A` values across the dataset were replaced with `NULL` to ensure proper handling of missing data.
5. In the `horsepower` column, non-numeric symbols (such as `+` in values like `1000+`) were removed, and the column was converted to a numeric data type to allow accurate aggregations.
   
   5.1 The same cleaning logic was applied to the `torque` column.
6. The `price_usd` column was converted to a numeric format by removing thousands separators (commas) and converting it to a numeric data type.

These steps ensured consistent data types and improved data quality for reliable analytical results.


# Business Question 1  
## Which automotive brands have the widest product range in terms of pricing and performance?

## Created Metric
- Price Range = Max(price) − Min(price) per brand  
- Horsepower Range = Max(horsepower) − Min(horsepower) per brand  
- Only brands with more than 5 models were included to ensure statistical relevance

## 📈 Key Insights

- Certain brands demonstrate a significantly wider price range, indicating diversified market positioning.
- Brands with both high price and horsepower dispersion appear to target multiple customer segments, from entry-level performance to ultra-premium models.

# Business Question 2 
## Which brands dominate the ultra high-performance segment (700+ HP)?

## Created Metric

High-Performance Percentage (%) =
(Number of models with horsepower > 700 × 100 ÷ Total models per brand) 

## 📈 Key Insights

- Brands with a high percentage are heavily focused on ultra-performance vehicles.
- Lower percentages indicate either broader market positioning or mass-segment orientation.
- This metric highlights specialization rather than absolute volume.

# Business Question 3
## Which automotive brands demonstrate the highest performance efficiency?

## Created Metric

To evaluate performance efficiency, a custom **Performance Index** was developed:

Performance Index = AVG(Horsepower) ÷ AVG(0–60 Time)

This metric measures how much average power output a brand generates per second of acceleration.

### Why this metric?

- Horsepower alone does not fully describe performance.
- Acceleration time alone does not capture engine capability.
- Combining both allows for a more balanced performance efficiency comparison.

To ensure statistical reliability:
- Only non-electric vehicles were included.
- Records with missing horsepower or acceleration values were excluded.
- Brands with fewer than 3 models were filtered out.

## 📈 Key Insights

- Hypercar manufacturers dominate performance efficiency rankings. Rimac, Bugatti, and Koenigsegg significantly outperform traditional luxury performance brands, with index values often 2–4x higher.

- A clear performance tier structure exists in the market. Hypercar brands form a distinct upper segment, followed by luxury performance manufacturers.

- Brands with broader portfolios tend to show lower performance intensity. This suggests a strategic balance between performance, scalability, and market positioning.

# Business Question 4
## How does horsepower influence non electric vehicle pricing across different performance segments?

## Created Metric
Horsepower groups (100 HP intervals) to identify price behavior across performance tiers.

To ensure statistical reliability:
- Only non-electric vehicles were included.
- Records with missing horsepower values were excluded.
- Brands with fewer than 5 models were filtered out.

## 📈 Key Insights
- Average vehicle price increases gradually up to the 600 HP range.
- A sharp price acceleration occurs beyond 700 HP, indicating entry into a premium / hypercar segment.
- Vehicles exceeding 1200 HP show extreme price escalation, suggesting ultra-exclusive positioning.

# Business Question 5
## What percentage of each brand’s models are priced above the overall market average?

## Created Metric:
Calculated the proportion of models for each brand that are priced above the market-wide average price.

percentage_above_avg = (luxury_cars(cars with above market average price) ÷ total cars by brand) × 100

## 📈 Key Insights:

- Brands with a high percentage (≥70%) of models above average are classified as Premium, indicating strong pricing power.

- Brands in the 40–70% range are Medium, showing a balanced mix of standard and above-average pricing.

- Brands below 40% are Low, mostly offering models under the market average price.

- This analysis helps identify which brands are positioned as premium versus mainstream in terms of pricing.

# Business Question 6
## Which models are the fastest within each brand, and how do they compare to the brand’s average acceleration?

## Created Metric:
To identify each brand’s flagship performance model, a window function (ROW_NUMBER()) was used:

- ROW_NUMBER() OVER (PARTITION BY car_make ORDER BY zero_to_sixty_time ASC) 

Additionally:

- The average 0–60 acceleration time was calculated per brand.
- A new metric was created:
Speed Difference = Average Brand 0–60 Time − Fastest Model 0–60 Time

## 📈 Key Insight

- Each brand’s flagship model is clearly identifiable.

- Brands with large acceleration gaps between the flagship and the rest of the lineup (Nissan, Porsche, Maserati, Lotus, Chevrolet) often have a wider variety of models in terms of speed, with one high-performance star and other models

- Brands with smaller acceleration differences demonstrate more consistent performance engineering across their model range(Tesla, Bugatti, Acura, Rolls-Royce etc.).

