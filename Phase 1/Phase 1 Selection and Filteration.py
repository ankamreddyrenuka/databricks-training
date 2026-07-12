# Databricks notebook source
# DBTITLE 1,Introduction
# MAGIC %md
# MAGIC # Phase 1: Selection and Filteration
# MAGIC
# MAGIC This notebook demonstrates fundamental data operations:
# MAGIC - **Selection**: Choosing specific columns from datasets
# MAGIC - **Filteration**: Applying conditions to filter rows
# MAGIC
# MAGIC ## Objectives:
# MAGIC 1. Load customer data
# MAGIC 2. Select relevant columns
# MAGIC 3. Apply filtering conditions
# MAGIC 4. Analyze filtered results

# COMMAND ----------

# DBTITLE 1,Load Data
# Load the customer report data
from pyspark.sql import functions as F

# Read customer data
df_customers = spark.table("workspace.default.customer_report")

print(f"Total records loaded: {df_customers.count():,}")
print(f"\nSchema:")
df_customers.printSchema()

# COMMAND ----------

# DBTITLE 1,Preview Data
# Display sample data
print("Sample of customer data:")
display(df_customers.limit(10))

# COMMAND ----------

# DBTITLE 1,Column Selection
# SELECTION: Choose specific columns
selected_columns = df_customers.select(
    "customer_name",
    "city",
    "segment",
    "total_spend",
    "order_count"
)

print("Selected columns: customer_name, city, segment, total_spend, order_count")
display(selected_columns.limit(10))

# COMMAND ----------

# DBTITLE 1,Filter by Segment
# FILTERATION: Apply conditions to filter rows

# Filter 1: Gold segment customers only
gold_customers = df_customers.filter(F.col("segment") == "Gold")

print(f"Gold segment customers: {gold_customers.count():,}")
print("\nSample of Gold customers:")
display(gold_customers.limit(10))

# COMMAND ----------

# DBTITLE 1,Filter by Spend
# Filter 2: High-value customers (spend > $5M)
high_value_customers = df_customers.filter(F.col("total_spend") > 5000000)

print(f"High-value customers (>$5M): {high_value_customers.count():,}")
print("\nTop high-value customers:")
display(high_value_customers.orderBy(F.desc("total_spend")).limit(15))

# COMMAND ----------

# DBTITLE 1,Combined Filters
# Filter 3: Combined conditions - Gold segment AND high-value
gold_high_value = df_customers.filter(
    (F.col("segment") == "Gold") & 
    (F.col("total_spend") > 5000000)
)

print(f"Gold high-value customers: {gold_high_value.count():,}")
print("\nDistribution by city:")
city_distribution = gold_high_value.groupBy("city").count().orderBy(F.desc("count"))
display(city_distribution.limit(10))

# COMMAND ----------

# DBTITLE 1,Filter by Activity
# Filter 4: Active customers (order_count >= 30)
active_customers = df_customers.filter(F.col("order_count") >= 30)

print(f"Active customers (>=30 orders): {active_customers.count():,}")
print("\nSegment breakdown:")
segment_breakdown = active_customers.groupBy("segment").agg(
    F.count("*").alias("customer_count"),
    F.sum("total_spend").alias("total_revenue"),
    F.avg("total_spend").alias("avg_spend")
)
display(segment_breakdown)

# COMMAND ----------

# DBTITLE 1,Summary Statistics
# Summary statistics for filtered data
print("=" * 60)
print("PHASE 1 SUMMARY: Selection and Filteration Results")
print("=" * 60)

summary_stats = {
    "Total Customers": df_customers.count(),
    "Gold Customers": gold_customers.count(),
    "High-Value (>$5M)": high_value_customers.count(),
    "Gold + High-Value": gold_high_value.count(),
    "Active (>=30 orders)": active_customers.count()
}

for metric, value in summary_stats.items():
    print(f"{metric:.<50} {value:>10,}")

print("=" * 60)
print("Phase 1 Complete: Data selected and filtered successfully")

# COMMAND ----------

