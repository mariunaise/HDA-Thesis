import csv

def filter_sort_and_write_csv(input_file, output_file, filter_value):
    # Read the CSV file
    with open(input_file, mode='r', newline='') as infile:
        reader = csv.reader(infile)
        data = list(reader)
    
    # Extract header and filter data for rows where the first column is the filter_value
    header = data.pop(0)
    filtered_data = [row for row in data if row[0] == str(filter_value)]
    
    # Sort the filtered data based on the first column
    filtered_data.sort(key=lambda x: x[0])
    
    # Remove the first column from each row
    processed_data = [row[1:] for row in filtered_data]
    
    # Write the processed data to a new CSV file
    with open(output_file, mode='w', newline='') as outfile:
        writer = csv.writer(outfile)
        writer.writerows(processed_data)

# Usage example
#input_csv_file = './errorrates_left_5_5.csv'
#output_csv_file = './errorrates_left_5_5_proccessed.csv'
#filter_value = 2
#filter_sort_and_write_csv(input_csv_file, output_csv_file, filter_value)

tmps = ['5', '15', '25', '35', '45', '55']

for tmp1 in tmps:
    for tmp2 in tmps:
        input = './errorrates_left_' + tmp1 + '_' + tmp2 + '.csv'
        output = './processed/errorrates_' + tmp1 + '_' + tmp2 + '_processed.csv'
        filter_sort_and_write_csv(input, output, 2)
