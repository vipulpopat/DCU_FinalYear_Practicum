import requests

def upload_file_to_ipfs(file_path):
    # IPFS daemon API endpoint
    api_url = 'http://localhost:5001/api/v0'

    # Read the file content
    with open(file_path, 'rb') as file:
        file_data = file.read()

    # Prepare the multipart form data
    files = {'file': file_data}

    # Send the request to upload the file
    response = requests.post(f'{api_url}/add', files=files)

    # Extract the IPFS hash from the response
    ipfs_hash = response.json()['Hash']

    # Return the IPFS hash of the uploaded file
    return ipfs_hash

# Usage example
model_path = 'c://Tools/model-test/finalized_model.sav'
metadata_path = 'C://Users/vipul/OneDrive/Documents/Git-Repositories/practicum/utilities/model_data.json'
dataset_path = 'C://Users/vipul/OneDrive/Documents/Git-Repositories/practicum/utilities/pima-indians-diabetes.data.csv.encrypted'

model_hash = upload_file_to_ipfs(model_path)
metadata_hash = upload_file_to_ipfs(metadata_path)
dataset_hash = upload_file_to_ipfs(dataset_path)
print(f'Files uploaded successfully. \nModel Hash: {model_hash}\nMetadata Hash: {metadata_hash}\nDataset Hash: {dataset_hash}')

