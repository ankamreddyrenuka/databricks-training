from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()
customers = spark.read.option("header", True).csv("Datasets-PySpark Project/customers.csv")
filtered = customers.filter(customers.city == "Springfield").select("customer_id", "first_name", "last_name", "city")
filtered.show(10)
