import os

def list_files_recursive(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            print(os.path.join(root, file))

# Get current directory
current_directory = os.getcwd()

# Call the function to list all files recursively
list_files_recursive(current_directory)
