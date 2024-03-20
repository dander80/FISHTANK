import os 

# Get the current directory
current_directory = os.getcwd()
print("1 Current directory:", os.getcwd())

# Go two steps back
for _ in range(2):
    current_directory = os.path.dirname(current_directory)
    print(current_directory)

# Navigate to "models/FMUs"
new_directory = os.path.join(current_directory, "Models", "FMUs")

# Change the current working directory
os.chdir(new_directory)

# Verify the new directory
print("Current directory:", os.getcwd())

# Get the list of files in the current directory
files_in_current_directory = os.listdir()

# Print the list of files
print("Files in the current directory:")
for file in files_in_current_directory:
    print(file)