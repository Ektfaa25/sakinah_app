#!/usr/bin/env python3
"""
Script to bulk upload azkar data to Supabase using the REST API
"""
import csv
import os
import sys
import json
import requests
from urllib.parse import quote

# Supabase configuration
SUPABASE_URL = "https://lvzibmrpvxxbzikwqxmi.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2emlibXJwdnh4Ynppa3dxeG1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0OTcwNzcsImV4cCI6MjA1MTA3MzA3N30.z8eAOhXIlRJvDlr1xKTNkL9iEGPpwH2SDNHTZHqULjk"

def clean_repetitions(count_str):
    """Clean and convert repetition count to integer"""
    if not count_str or count_str.strip() == '':
        return 1
    
    try:
        return int(count_str.strip())
    except ValueError:
        # Handle Arabic text
        count_str = count_str.strip().lower()
        if 'ثلاث' in count_str or count_str == '3':
            return 3
        elif 'سبع' in count_str or count_str == '7':
            return 7
        elif 'عشر' in count_str or count_str == '10':
            return 10
        elif '100' in count_str:
            return 100
        else:
            return 1

def prepare_azkar_data(csv_file_path):
    """Read CSV and prepare data for Supabase insertion"""
    azkar_data = []
    
    with open(csv_file_path, 'r', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        
        for row in csv_reader:
            azkar_item = {
                'category': row['category'].strip() if row['category'] else '',
                'arabic_text': row['zekr'].strip() if row['zekr'] else '',
                'description': row['description'].strip() if row['description'] else None,
                'repetitions': clean_repetitions(row['count']),
                'reference': row['reference'].strip() if row['reference'] else None,
                'search_tags': row['search'].strip() if row['search'] else ''
            }
            
            # Only add if we have required fields
            if azkar_item['category'] and azkar_item['arabic_text']:
                azkar_data.append(azkar_item)
    
    return azkar_data

def upload_to_supabase(data_batch):
    """Upload a batch of azkar data to Supabase"""
    headers = {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
    }
    
    url = f"{SUPABASE_URL}/rest/v1/azkar"
    
    try:
        response = requests.post(url, json=data_batch, headers=headers)
        response.raise_for_status()
        return True, None
    except requests.exceptions.RequestException as e:
        return False, str(e)

def main():
    """Main function to upload azkar data"""
    csv_file_path = '/Users/ektfaa/Desktop/Apps/Flutter/sakinah_app/assets/data/azkar.csv'
    
    if not os.path.exists(csv_file_path):
        print(f"❌ Error: CSV file not found at {csv_file_path}")
        sys.exit(1)
    
    try:
        print("📖 Reading azkar data from CSV...")
        azkar_data = prepare_azkar_data(csv_file_path)
        print(f"✅ Prepared {len(azkar_data)} azkar entries")
        
        # Split into batches (Supabase has limits on batch size)
        batch_size = 50
        total_batches = (len(azkar_data) + batch_size - 1) // batch_size
        
        print(f"📤 Uploading in {total_batches} batches of {batch_size} items each...")
        
        success_count = 0
        for i in range(0, len(azkar_data), batch_size):
            batch = azkar_data[i:i + batch_size]
            batch_num = (i // batch_size) + 1
            
            print(f"  📦 Uploading batch {batch_num}/{total_batches} ({len(batch)} items)...")
            
            success, error = upload_to_supabase(batch)
            if success:
                success_count += len(batch)
                print(f"  ✅ Batch {batch_num} uploaded successfully")
            else:
                print(f"  ❌ Batch {batch_num} failed: {error}")
        
        print(f"\n🎉 Upload complete!")
        print(f"✅ Successfully uploaded: {success_count} azkar entries")
        
        if success_count < len(azkar_data):
            print(f"⚠️  Failed uploads: {len(azkar_data) - success_count}")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
