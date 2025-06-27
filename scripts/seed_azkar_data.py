#!/usr/bin/env python3
"""
Script to seed azkar data from CSV into Supabase database
"""
import csv
import os
import sys

def escape_sql_string(text):
    """Escape single quotes and other problematic characters in SQL strings"""
    if text is None or text == '':
        return 'NULL'
    
    # Replace single quotes with double single quotes
    escaped = text.replace("'", "''")
    return f"'{escaped}'"

def clean_repetitions(count_str):
    """Clean and convert repetition count to integer"""
    if not count_str or count_str.strip() == '':
        return 1
    
    try:
        # Handle Arabic numerals and basic conversion
        return int(count_str.strip())
    except ValueError:
        # Try to extract numbers from text like "ثلاثاً" or "100"
        if 'ثلاث' in count_str:
            return 3
        elif 'سبع' in count_str:
            return 7
        elif 'عشر' in count_str:
            return 10
        elif '100' in count_str:
            return 100
        else:
            return 1

def generate_sql_inserts(csv_file_path):
    """Generate SQL INSERT statements from CSV data"""
    insert_statements = []
    
    with open(csv_file_path, 'r', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        
        for row in csv_reader:
            category = escape_sql_string(row['category'])
            arabic_text = escape_sql_string(row['zekr'])
            description = escape_sql_string(row['description'])
            repetitions = clean_repetitions(row['count'])
            reference = escape_sql_string(row['reference'])
            search_tags = escape_sql_string(row['search'])
            
            sql = f"""INSERT INTO public.azkar (category, arabic_text, description, repetitions, reference, search_tags) VALUES
({category}, {arabic_text}, {description}, {repetitions}, {reference}, {search_tags});"""
            
            insert_statements.append(sql)
    
    return insert_statements

def main():
    """Main function to process CSV and generate SQL"""
    csv_file_path = '/Users/ektfaa/Desktop/Apps/Flutter/sakinah_app/assets/data/azkar.csv'
    
    if not os.path.exists(csv_file_path):
        print(f"Error: CSV file not found at {csv_file_path}")
        sys.exit(1)
    
    try:
        print("Generating SQL insert statements...")
        sql_statements = generate_sql_inserts(csv_file_path)
        
        # Write to SQL file
        output_file = '/Users/ektfaa/Desktop/Apps/Flutter/sakinah_app/scripts/azkar_insert.sql'
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("-- Azkar data insert statements\n")
            f.write("-- Generated from azkar.csv\n\n")
            for statement in sql_statements:
                f.write(statement + "\n\n")
        
        print(f"✅ Generated {len(sql_statements)} SQL insert statements")
        print(f"📄 SQL file saved to: {output_file}")
        
        # Also print first few statements for verification
        print("\n📋 Sample statements:")
        for i, statement in enumerate(sql_statements[:3]):
            print(f"\n{i+1}. {statement}")
            
    except Exception as e:
        print(f"❌ Error processing CSV: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
