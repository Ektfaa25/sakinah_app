#!/usr/bin/env python3
"""
Efficient bulk upload script for azkar data to Supabase.
This script processes the remaining records and creates optimized batch SQL statements.
"""

import csv
import json

def escape_sql_string(value):
    """Escape single quotes in SQL strings and handle NULL values"""
    if value is None or not value.strip():
        return 'NULL'
    return "'" + value.replace("'", "''") + "'"

def create_batch_sql(records, batch_number):
    """Create SQL INSERT statement for a batch of records"""
    values = []
    
    for record in records:
        category = escape_sql_string(record['category'])
        arabic_text = escape_sql_string(record['zekr'])
        description = escape_sql_string(record['description'])
        
        # Handle repetitions
        try:
            repetitions = int(record['count']) if record['count'] and record['count'].strip() else 1
        except (ValueError, TypeError):
            repetitions = 1
            
        reference = escape_sql_string(record['reference'])
        search_tags = escape_sql_string(record['search'])
        
        values.append(f"({category}, {arabic_text}, {description}, {repetitions}, {reference}, {search_tags})")
    
    sql = "INSERT INTO azkar (category, arabic_text, description, repetitions, reference, search_tags) VALUES\n" + ",\n".join(values) + ";"
    return sql

def main():
    # Read the CSV file
    csv_path = '/Users/ektfaa/Desktop/Apps/Flutter/sakinah_app/assets/data/azkar.csv'
    
    with open(csv_path, 'r', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        azkar_data = list(csv_reader)
    
    print(f"Total azkar records in CSV: {len(azkar_data)}")
    
    # We've already uploaded the first 13 records, so start from record 14
    remaining_data = azkar_data[13:]
    print(f"Remaining records to upload: {len(remaining_data)}")
    
    # Process in batches of 25 for efficiency
    batch_size = 25
    total_batches = (len(remaining_data) + batch_size - 1) // batch_size
    
    print(f"Will create {total_batches} batches of up to {batch_size} records each")
    
    # Generate batch SQL files
    for i in range(0, len(remaining_data), batch_size):
        batch_number = (i // batch_size) + 1
        batch_data = remaining_data[i:i + batch_size]
        
        sql = create_batch_sql(batch_data, batch_number)
        
        # Save to file
        output_file = f'/Users/ektfaa/Desktop/Apps/Flutter/sakinah_app/scripts/remaining_batch_{batch_number}.sql'
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(sql)
        
        print(f"Batch {batch_number}: {len(batch_data)} records -> {output_file}")
    
    print(f"\n✅ Generated {total_batches} SQL batch files")
    print("Next: Execute these SQL files using MCP Supabase")
    
    # Also generate a summary
    summary = {
        "total_records_in_csv": len(azkar_data),
        "already_uploaded": 13,
        "remaining_to_upload": len(remaining_data),
        "batch_size": batch_size,
        "total_batches": total_batches,
        "batch_files": [f"remaining_batch_{i+1}.sql" for i in range(total_batches)]
    }
    
    with open('/Users/ektfaa/Desktop/Apps/Flutter/sakinah_app/scripts/upload_summary.json', 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    
    print(f"Upload summary saved to: upload_summary.json")

if __name__ == "__main__":
    main()
