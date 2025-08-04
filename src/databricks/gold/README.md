# Gold Layer - Business Logic and Analytics

The gold layer contains business-ready data optimized for analytics, reporting, and machine learning workloads.

## Overview

Gold layer tables provide:
- **Aggregated Data**: Pre-calculated metrics and KPIs
- **Business Logic**: Applied business rules and calculations  
- **Analytics-Ready**: Optimized for BI tools and dashboards
- **Performance**: Optimized partitioning and indexing

## Business Metrics

### Content Analysis
- Content distribution by type (Movies vs TV Shows)
- Release year trends and patterns
- Content rating distribution
- Duration analysis

### Geographic Analysis  
- Content by country/region
- Regional content preferences
- Production country insights

### Genre Analysis
- Popular genres and categories
- Genre trends over time
- Content diversity metrics

### Cast and Crew Analysis
- Most prolific directors and actors
- Collaboration networks
- Career span analysis

## Output Tables

### Fact Tables
- `fact_content_metrics`: Core content metrics and KPIs
- `fact_release_trends`: Time-based content release patterns

### Dimension Tables
- `dim_content`: Content dimension with all attributes
- `dim_geography`: Geographic dimension for location analysis
- `dim_time`: Time dimension for temporal analysis

### Aggregate Tables
- `agg_content_by_country`: Country-level content statistics
- `agg_content_by_year`: Year-over-year content trends
- `agg_genre_popularity`: Genre popularity metrics

## Usage

Gold layer tables are designed for:
- Business Intelligence dashboards
- Analytics and reporting
- Data science and ML feature engineering
- Executive reporting and KPIs
