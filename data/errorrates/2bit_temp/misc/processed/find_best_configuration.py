import pandas as pd
import glob

# Function to find the best configuration based on parameter value 99
def find_best_configuration(file_paths):
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

    # Find the configuration with the overall best (lowest) bit error rate for parameter 99
    
    #best_config = combined_df.groupby('config')['Bit Error Rate'].mean().idxmin()
   
    sorted_configs = combined_df.groupby('config')['Bit Error Rate'].mean().sort_values().reset_index()
    return sorted_configs

# Example usage

tmps = ["5", "15", "25", "35", "45", "55"]

paths = []

for tmp1 in tmps: 
    for tmp2 in tmps:
        paths.append("./errorrates_" + tmp1 + "_" + tmp2 + "_" + "processed.csv") 

file_paths = [
    "/path/to/errorrates_5_5_processed.csv",
    "/path/to/errorrates_5_15_processed.csv",
    "/path/to/errorrates_5_25_processed.csv",
    "/path/to/errorrates_5_35_processed.csv",
    "/path/to/errorrates_5_45_processed.csv"
]

best_config, combined_df = find_best_configuration(paths)
print("Best configuration:", best_config)

