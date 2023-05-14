import hashlib

# Function to print a message in green
def echo_green(msg):
    print(f"\033[32m{msg}\033[0m")

# Function to print a message in red
def echo_red(msg):
    print(f"\033[31m{msg}\033[0m")

# Function to calculate the SHA256 hash of a file
def sha256sum_file(file_path):
    file_path = file_path.rstrip() # Supprimer les espaces à la fin de la chaîne
    output = os.popen(f"shasum -a 256 '{file_path}'").read()
    return output.split()[0]


def remove_trailing_spaces(path):
    i = len(path) - 1
    while i >= 0:
        if path[i] == " ":
            i -= 1
        else:
            return path[:i+1]
    return path


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


def replace_spaces(path):
    return path.replace(' ', 'z')



print("What do you want to do?")
print("1. Verify the hash of a single file")
print("2. Compare two files")
print("3. Compare a file with a hash")

choice = input()

if choice == "1":
    file_path = input("Enter the path of the file you want to check the hash of:")
    file_path = replace_spaces(file_path)
    print(file_path)
    hash_value = sha256sum_file(file_path)
    echo_green(f"The hash of the file is: {hash_value}")
elif choice == "2":
    file_path1 = input("Enter the path of the first file:")
    hash1 = sha256sum_file(file_path1)

    file_path2 = input("Enter the path of the second file:")
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
        file_path1 = input("Enter the path of the first file:")
        hash1 = sha256sum_file(file_path1)
    elif choice1.lower() == "h":
        hash1 = input("Enter the hash of the first file:")
    else:
        echo_red("Invalid choice")
        exit(1)

    choice2 = input("For the second file, do you want to enter the path (P) or the hash (H)?")
    if choice2.lower() == "p":
        file_path2 = input("Enter the path of the second file:")
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
