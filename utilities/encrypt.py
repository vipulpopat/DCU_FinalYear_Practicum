from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import unpad
import hashlib

def encrypt_file(file_path, private_key):
    # Generate encryption key from private key
    key = hashlib.sha256(private_key.encode()).digest()

    # Generate a random initialization vector (IV)
    iv = get_random_bytes(16)

    # Read the file content
    with open(file_path, 'rb') as file:
        file_content = file.read()

    # Pad the file content to match the block size
    padded_content = pad(file_content, AES.block_size)

    # Create the AES cipher object with the key and IV
    cipher = AES.new(key, AES.MODE_CBC, iv)

    # Encrypt the padded file content
    encrypted_content = cipher.encrypt(padded_content)

    # Write the encrypted content along with the IV to a new file
    encrypted_file_path = file_path + '.encrypted'
    with open(encrypted_file_path, 'wb') as encrypted_file:
        encrypted_file.write(iv + encrypted_content)

    print("File encrypted successfully!")
    
def decrypt_file(file_path, private_key):
    # Generate decryption key from private key
    key = hashlib.sha256(private_key.encode()).digest()

    # Read the encrypted file content
    with open(file_path, 'rb') as encrypted_file:
        file_content = encrypted_file.read()

    # Extract the IV and encrypted content from the file
    iv = file_content[:16]
    encrypted_content = file_content[16:]

    # Create the AES cipher object with the key and IV
    cipher = AES.new(key, AES.MODE_CBC, iv)

    # Decrypt the encrypted content
    decrypted_content = cipher.decrypt(encrypted_content)

    # Remove the padding from the decrypted content
    unpadded_content = unpad(decrypted_content, AES.block_size)

    # Write the decrypted content to a new file
    decrypted_file_path = file_path + '.decrypted'
    with open(decrypted_file_path, 'wb') as decrypted_file:
        decrypted_file.write(unpadded_content)

    print("File decrypted successfully!")
    

# Example usage
file_path = './pima-indians-diabetes.data.csv'
private_key = '33ef8824d28b33319597947c8f6d1a66f9d2c95272d4db7b6a874c10f31f2219'

encrypt_file(file_path, private_key)
#decrypt_file(file_path + '.encrypted', private_key)
