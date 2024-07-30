import pandas as pd

# List of input CSV file names
csv_files = ['./errorrates_5_5_processed.csv', './errorrates_15_15_processed.csv', './errorrates_25_25_processed.csv', './errorrates_35_35_processed.csv', './errorrates_45_45_processed.csv', './errorrates_55_55_processed.csv']

# Read all CSV files into a list of DataFrames
dfs = [pd.read_csv(file) for file in csv_files]

# Concatenate DataFrames along the columns (axis=1)
combined_df = pd.concat(dfs, axis=1)

# Calculate the mean for each row, excluding the first column which is assumed to be the index
mean_values = combined_df.iloc[:, 1::2].mean(axis=1)

# Create the output DataFrame with the original index and the calculated mean
output_df = pd.DataFrame({
    'Index': dfs[0].iloc[:, 0],  # Assumes the first column is the index
    'Mean': mean_values
})

# Save the result to a new CSV file
output_df.to_csv('errorrates_diff_0.csv', index=False)

print("Row-wise mean calculated and saved.")
