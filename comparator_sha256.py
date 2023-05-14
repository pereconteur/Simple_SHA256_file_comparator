import hashlib
import os
import platform

#For Windows

if platform.system() == 'Windows':
    import colorama
    from colorama import init, Fore

    # Initialize colors
    init()

    # Function to print a message in green
    def echo_green(msg):
        print(Fore.GREEN + msg + Fore.RESET)

    # Function to print a message in red
    def echo_red(msg):
        print(Fore.RED + msg + Fore.RESET)


    def echo_yellow(msg):
        print(Fore.YELLOW + msg + Fore.RESET)

else:

    # Function to print a message in green
    def echo_green(msg):
        print(f"\033[32m{msg}\033[0m")


    # Function to print a message in red
    def echo_red(msg):
        print(f"\033[31m{msg}\033[0m")


    def echo_yellow(msg):
        print(f"\033[33m{msg}\033[0m")


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

def delimit():
    print("")
    print("-"*10)
    print("")

# Function to compare two hashes character by character
def compare_hashes(hash1, hash2):
    length = len(hash1)
    result = ''
    result2 = ''
    if len(hash1) == len(hash2):
        for i in range(length):
            if hash1[i] == hash2[i]:
                result += hash1[i]
                result2 += hash2[i]
            else:
                result += '\033[31m' + hash1[i] + '\033[0m'
                result2 += '\033[31m' + hash2[i] + '\033[0m'
        if result2 == result:
            echo_green("The hashes are identical : ")
            print()
            print(result)
        else:
            echo_red("The hashes are different : ")
            print()
            print(result)
            print(result2)
    else:
        echo_red("The hashes are different : ")
        print()
        echo_red(hash1)
        echo_red(hash2)

#Function
def get_file_path():
    """
    Function that retrieves the path of a file entered by the user.
    """
    while True:
        file_path = input()
        file_path = file_path.strip()  # Remove leading and trailing spaces
        if platform.system() == 'Windows':
            file_path = file_path.replace("/", "\\")  # Replace forward slashes with backslashes
        else:
            file_path = file_path.replace("\\", "")  # Remove unnecessary backslashes

        if os.path.isfile(file_path):
            return file_path
        else:
            print("The specified file could not be found. Please try again.")


def main():
    # Your program's instructions

    print("What do you want to do?")
    print("1. Verify the hash of a single file")
    print("2. Compare two files")
    print("3. Compare a file with a hash")

    choice = input()

    if choice == "1":
        print("Please enter the full path of the file:")
        file_path = get_file_path()
        hash_value = sha256sum_file(file_path)
        delimit()
        echo_yellow(os.path.basename(file_path)+" : \n")
        echo_green(hash_value)
        delimit()
    elif choice == "2":
        print("Please enter the full path of file 1:")
        file_path1 = get_file_path()
        hash1 = sha256sum_file(file_path1)

        print("Please enter the full path of file 2:")
        file_path2 = get_file_path()
        hash2 = sha256sum_file(file_path2)

        if hash1 == hash2:
            delimit()
            echo_green("The two files are identical.")
            echo_yellow(os.path.basename(file_path1)+" = "+ os.path.basename(file_path2))
            print()
            echo_green(hash1)
            delimit()
        else:
            delimit()
            echo_red("The two files are different: ")
            echo_yellow(os.path.basename(file_path1)+" != "+ os.path.basename(file_path2))
            print()
            compare_hashes(hash1, hash2)
            delimit()
    elif choice == "3":
        choice1 = ""
        while choice1.lower() != "p" and choice1.lower() != "h":
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

        choice2 = ""
        while choice2.lower() != "p" and choice2.lower() != "h":
            choice2 = input("For the second file, do you want to enter the path (P) or the hash (H)?")
        if choice2.lower() == "p":
            print("Enter the path of the second file:")
            file_path2 = get_file_path()
            hash2 = sha256sum_file(file_path2)
        elif choice2.lower() == "h":
            hash2 = input("Enter the hash of the second file:")
        else:
            echo_red("Invalid choice")
            exit(1)

        delimit()
        compare_hashes(hash2, hash1)
        delimit()
    else:
        echo_red("Invalid choice")
        exit(1)


if __name__ == "__main__":
    while True:
        main()
