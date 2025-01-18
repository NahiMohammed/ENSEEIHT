import sys
import requests
import json
import os

# Check if all required command-line arguments are provided
if len(sys.argv) != 5:
    print("Usage: python download_images.py <class_name> <query> <start_index> <total_images>")
    sys.exit(1)

# Extract command-line arguments
class_name = sys.argv[1]
query = sys.argv[2]
start_index = int(sys.argv[3])
total_images = int(sys.argv[4])

# Our Google API Key
api_key = ' AIzaSyBP29_zxVwkfVjhG-gTFkq8d6Tfe7xQ5T8 '

# Our Custom Search Engine ID
search_engine_id = '65d9c6120feb64b2e'

# Google Custom Search endpoint
url = 'https://www.googleapis.com/customsearch/v1'

# Folder to save images with class name
folder_name = f'/home/zaid/Bureau/S8/ProjectDL/data/{class_name}/'

# Ensure the folder exists
if not os.path.exists(folder_name):
    os.makedirs(folder_name)

# Function to download images
def download_image(image_url, folder_path, file_name_prefix):
    file_path = os.path.join(folder_path, f"{file_name_prefix}.jpg")
    response = requests.get(image_url)
    if response.status_code == 200:
        with open(file_path, 'wb') as f:
            f.write(response.content)
        print(f"Image successfully downloaded: {file_path}")
    else:
        print("Failed to retrieve the image")

# Parameters for pagination
images_per_request = 10

while total_images > 0:
    params = {
        'q': query,
        'cx': search_engine_id,
        'key': api_key,
        'searchType': 'image',
        'num': min(images_per_request, total_images),
        'start': start_index
    }

    response = requests.get(url, params=params)

    if response.status_code == 200:
        search_results = response.json()

        for image_info in search_results.get('items', []):
            print(image_info['link'])
            # Determine the file name based on the number of files in the directory
            files_in_directory = os.listdir(folder_name)
            number_of_files = len([entry for entry in files_in_directory if os.path.isfile(os.path.join(folder_name, entry))])
            file_name = f'{class_name}_{number_of_files + 1}'  # Increment file name

            # Download the image
            download_image(image_info['link'], folder_name, file_name)

        # Update counters for pagination and remaining images
        total_images -= len(search_results.get('items', []))
        start_index += images_per_request
    else:
        print("Failed to retrieve search results")
        break  # Exit the loop if there's an error

