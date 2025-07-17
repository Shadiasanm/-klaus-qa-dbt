import requests
import pandas as pd
from google.cloud import bigquery
import json
from datetime import datetime
import os

class SubscriptionETLPipeline:
    def __init__(self, project_id="here_the_project_name_in_BQ"):
        self.project_id = project_id
        self.dataset_id = "subscription_data"
        self.client = bigquery.Client(project=project_id)
        
    def extract_from_api(self):
        """
        Extract subscription data from API (simulated with etl.json for demo)
        """
        print("🔍 Extracting subscription data from API...")
        try:
            with open("etl.json", "r") as f:
                data = json.load(f)
            print(f"✅ Data extracted: {len(data.get('list', []))} subscriptions")
            return data
        except FileNotFoundError:
            print("❌ etl.json file not found")
            return {}
    
    def transform_data(self, raw_data):
        """
        Transform the extracted subscription data
        """
        print("🔄 Transforming subscription data...")
        
        if not raw_data or 'list' not in raw_data:
            return pd.DataFrame(), pd.DataFrame()
        
        # Extract subscriptions and customers
        subscriptions = []
        customers = []
        
        for item in raw_data['list']:
            if 'subscription' in item:
                sub = item['subscription']
                sub['etl_timestamp'] = datetime.now()
                sub['data_source'] = 'subscription_api'
                subscriptions.append(sub)
            
            if 'customer' in item:
                cust = item['customer']
                cust['etl_timestamp'] = datetime.now()
                cust['data_source'] = 'customer_api'
                customers.append(cust)
        
        # Create DataFrames
        subs_df = pd.json_normalize(subscriptions) if subscriptions else pd.DataFrame()
        cust_df = pd.json_normalize(customers) if customers else pd.DataFrame()
        
        print(f"✅ Transformed: {len(subs_df)} subscriptions, {len(cust_df)} customers")
        return subs_df, cust_df
    
    def load_incremental(self, subs_df, cust_df):
        """
        Load subscription and customer data incrementally to BigQuery
        """
        print("📤 Loading data incrementally...")
        
        # Load subscriptions
        if not subs_df.empty:
            table_id = f"{self.project_id}.{self.dataset_id}.subscriptions"
            job_config = bigquery.LoadJobConfig(
                write_disposition=bigquery.WriteDisposition.WRITE_APPEND, ##c with this we ensure the incremental instead of deleting and re processing everything each time
                autodetect=True
            )
            job = self.client.load_table_from_dataframe(subs_df, table_id, job_config=job_config)
            job.result()
            print(f"✅ Subscriptions loaded: {len(subs_df)} records")
        
        # Load customers
        if not cust_df.empty:
            table_id = f"{self.project_id}.{self.dataset_id}.customers"
            job_config = bigquery.LoadJobConfig(
                write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
                autodetect=True
            )
            job = self.client.load_table_from_dataframe(cust_df, table_id, job_config=job_config)
            job.result()
            print(f"✅ Customers loaded: {len(cust_df)} records")
    
    def run_pipeline(self):
        """
        Run the complete ETL pipeline
        """
        print("🚀 Starting Subscription ETL pipeline...")
        
        # Extract
        raw_data = self.extract_from_api()
        
        # Transform
        subs_df, cust_df = self.transform_data(raw_data)
        
        # Load
        self.load_incremental(subs_df, cust_df)
        
        print("✅ Pipeline completed successfully!")

if __name__ == "__main__":
    pipeline = SubscriptionETLPipeline()
    pipeline.run_pipeline()
