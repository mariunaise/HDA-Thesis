import pandas as pd

# Function to find configurations based on parameter value 99 and sort them
def find_sorted_configurations(file_paths):
    dfs = []
    for file_path in file_paths:
        df = pd.read_csv(file_path, header=None, names=['Parameter', 'Bit Error Rate'])
        # Extract configuration from file name
        config = file_path.split('_')[1:3]
        df['config'] = f"{config[0]}_{config[1]}"
        # Filter by parameter value 99
        df = df[df['Parameter'] == 99]
        dfs.append(df)

    # Concatenate all dataframes
    combined_df = pd.concat(dfs, ignore_index=True)

    # Group by configuration and calculate the mean bit error rate
    sorted_configs = combined_df.groupby('config')['Bit Error Rate'].mean().sort_values().reset_index()
    
    # Add a column for the absolute difference of the two configuration parameters
    sorted_configs['Abs Difference'] = sorted_configs['config'].apply(lambda x: abs(int(x.split('_')[0]) - int(x.split('_')[1])))

    return sorted_configs  

tmps = ["5", "15", "25", "35", "45", "55"]
paths = []

for tmp1 in tmps:
    for tmp2 in tmps:
        paths.append("./errorrates_" + tmp1 + "_" + tmp2 + "_processed.csv")

# Example usage
file_paths = [
    "/path/to/errorrates_5_5_processed.csv",
    "/path/to/errorrates_5_15_processed.csv",
    "/path/to/errorrates_5_25_processed.csv",
    "/path/to/errorrates_5_35_processed.csv",
    "/path/to/errorrates_5_45_processed.csv"
]

sorted_configurations = find_sorted_configurations(paths)
print("Sorted configurations:\n", sorted_configurations)

