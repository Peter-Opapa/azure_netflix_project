# Netflix Dataset Schema Documentation

## Source Data Schema

### netflix_titles.csv
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| show_id | string | Unique identifier for the title | s1 |
| type | string | Type of content (Movie/TV Show) | Movie |
| title | string | Title of the content | Dick Johnson Is Dead |
| director | string | Director(s) of the content | Kirsten Johnson |
| cast | string | Cast members (comma-separated) | null |
| country | string | Country/countries of production | United States |
| date_added | string | Date added to Netflix | September 25, 2021 |
| release_year | integer | Year of release | 2020 |
| rating | string | Content rating | PG-13 |
| duration | string | Duration (minutes for movies, seasons for TV shows) | 90 min |
| listed_in | string | Categories/genres | Documentaries |
| description | string | Brief description | As her father nears the end... |

### netflix_cast.csv
| Column | Data Type | Description |
|--------|-----------|-------------|
| show_id | string | Foreign key to netflix_titles |
| cast_member | string | Individual cast member name |

### netflix_directors.csv
| Column | Data Type | Description |
|--------|-----------|-------------|
| show_id | string | Foreign key to netflix_titles |
| director | string | Individual director name |

### netflix_countries.csv
| Column | Data Type | Description |
|--------|-----------|-------------|
| show_id | string | Foreign key to netflix_titles |
| country | string | Individual country name |

### netflix_category.csv
| Column | Data Type | Description |
|--------|-----------|-------------|
| show_id | string | Foreign key to netflix_titles |
| category | string | Individual category/genre |

## Data Quality Rules

### Bronze Layer Validation
- Check for duplicate show_ids
- Validate date formats
- Ensure non-null required fields (show_id, title, type)

### Silver Layer Transformations
- Standardize date formats
- Clean and normalize text fields
- Handle missing values appropriately
- Create lookup tables for normalized data

### Gold Layer Aggregations
- Content by country statistics
- Release year trends
- Genre popularity analysis
- Content rating distribution

## Data Lineage

```
Source CSV Files → Bronze Delta Tables → Silver Delta Tables → Gold Delta Tables
                      ↓                    ↓                    ↓
               Raw ingestion         Data cleaning        Business logic
               Schema inference      Validation rules     Aggregations
               Change detection      Normalization        Analytics-ready
```
