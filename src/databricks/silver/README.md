# Silver Layer - Data Cleaning and Transformation

The silver layer performs data cleaning, validation, and transformation on the bronze layer data to create a clean, consistent dataset.

## Overview

Silver layer transformations include:
- **Data Quality Checks**: Validation rules and data quality enforcement
- **Schema Standardization**: Consistent data types and formats
- **Data Normalization**: Creating lookup tables for better data organization
- **Incremental Processing**: Efficient processing of only new/changed data

## Transformations

### Data Quality Rules
- Remove duplicate records
- Validate required fields (show_id, title, type)
- Standardize date formats
- Handle null values appropriately

### Normalization
- Split comma-separated values (cast, directors, countries, categories)
- Create separate lookup tables for better querying
- Maintain referential integrity

### Output Tables
- `netflix_titles_clean`: Main titles table with cleaned data
- `netflix_cast_lookup`: Cast member relationships
- `netflix_directors_lookup`: Director relationships  
- `netflix_countries_lookup`: Country relationships
- `netflix_categories_lookup`: Category/genre relationships

## Usage

These notebooks can be run as:
1. **Interactive Notebooks**: For development and testing
2. **Databricks Jobs**: For scheduled execution
3. **DLT Pipelines**: For continuous processing
