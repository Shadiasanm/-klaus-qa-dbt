# Subscription Data ETL Pipeline

pipeline to extract, transform, and load subscription and customer data to BigQuery incrementally.

## 🚀 Features

- **Extract**: Extracts subscription and customer data from API (simulated with etl.json)
- **Transform**: Cleans and transforms the data into separate subscription and customer tables
- **Load**: Incremental load to BigQuery with separate tables
- **Incremental**: Only loads new data without reprocessing everything

## 📁 Files

- `etl_pipeline.py` - Main pipeline with ETL class for subscription data
- `requirements.txt` - Python dependencies
- `etl.json` - Sample subscription data

## 🛠️ Installation

1. **Install dependencies:**
```bash
pip install -r requirements.txt
```

2. **Configure Google Cloud credentials:**
```bash
export GOOGLE_APPLICATION_CREDENTIALS="path_where_the_gcp_bq_credentails_are_being_stored"
```

3. **Edit project_id in etl_pipeline.py:**
```python
pipeline = SubscriptionETLPipeline(project_id="prod_project")
```

## 🏃‍♂️ Usage

### Run Pipeline
```bash
python etl_pipeline.py
```
