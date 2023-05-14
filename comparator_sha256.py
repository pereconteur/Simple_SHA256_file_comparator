import hashlib
import os
import platform

# Function to print a message in green
def echo_green(msg):
    print(f"\033[32m{msg}\033[0m")


# Function to print a message in red
def echo_red(msg):
    print(f"\033[31m{msg}\033[0m")


# Function to calculate the SHA256 hash of a file
def sha256sum_file(file_path):
    with open(file_path, 'rb') as f:
            sha256_hash = hashlib.sha256()
            while True:
                data = f.read(65536)  # Read in 64KB chunks
                if not data:
                    break
                sha256_hash.update(data)
            return sha256_hash.hexdigest()

# Function to compare two hashes
def compare_hash(hash1, hash2):
    if hash1 == hash2:
        echo_green("The hashes are identical")
    else:
        echo_red("The hashes are different")


# Function to compare two hashes character by character
def compare_hashes(hash1, hash2):
    length = len(hash1)
    result = ''
    for i in range(length):
        if hash1[i] == hash2[i]:
            result += hash1[i]
        else:
            result += '\033[31m' + hash1[i] + '\033[0m'
    print(result)

#Function
def get_file_path():
    """
    Fonction qui récupère le chemin d'un fichier saisi par l'utilisateur.
    """
    while True:
        file_path = input()
        file_path = file_path.strip()  # Supprimer les espaces de début et de fin
        if platform.system() == 'Windows':
            file_path = file_path.replace("/", "\\")  # Replace forward slashes with backslashes
        else:
            file_path = file_path.replace("\\", "")  # Supprimer les backslashes inutiles

        file_path = file_path.replace("\\", "")  # Supprimer les backslashes inutiles

        if os.path.isfile(file_path):
            return file_path
        else:
            print("Le fichier spécifié est introuvable. Veuillez réessayer.")


print("What do you want to do?")
print("1. Verify the hash of a single file")
print("2. Compare two files")
print("3. Compare a file with a hash")

choice = input()

if choice == "1":
    print("Veuillez entrer le chemin complet du fichier : ")
    file_path = get_file_path()
    hash_value = sha256sum_file(file_path)
    echo_green(f"The hash of the file is: {hash_value}")
elif choice == "2":
    print("Veuillez entrer le chemin complet du fichier 1 : ")
    file_path1 = get_file_path()
    hash1 = sha256sum_file(file_path1)

    print("Veuillez entrer le chemin complet du fichier 2 : ")
    file_path2 = get_file_path()
    hash2 = sha256sum_file(file_path2)

    if hash1 == hash2:
        echo_green("The two files are identical.")
        print(hash1)
    else:
        echo_red("The two files are different: ")
        compare_hashes(hash1, hash2)
        compare_hashes(hash2, hash1)
elif choice == "3":
    choice1 = input("For the first file, do you want to enter the path (P) or the hash (H)?")
    if choice1.lower() == "p":
        print("Enter the path of the first file:")
        file_path1 = get_file_path()
        hash1 = sha256sum_file(file_path1)
    elif choice1.lower() == "h":
        hash1 = input("Enter the hash of the first file:")
    else:
        echo_red("Invalid choice")
        exit(1)

    choice2 = input("For the second file, do you want to enter the path (P) or the hash (H)?")
    if choice2.lower() == "p":
        print("Enter the path of the seconf file:")
        file_path2 = get_file_path()
        hash2 = sha256sum_file(file_path2)
    elif choice2.lower() == "h":
        hash2 = input("Enter the hash of the second file:")
    else:
        echo_red("Invalid choice")
        exit(1)

    compare_hash(hash1, hash2)
    compare_hashes(hash1, hash2)
    compare_hashes(hash2, hash1)
else:
    echo_red("Invalid choice")
    exit(1)
