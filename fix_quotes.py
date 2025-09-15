import os
import re

def process_content(content):
    # Process double quotes
    in_double_quote = False
    processed_content = ""
    i = 0
    while i < len(content):
        char = content[i]
        if char == '"':
            # Look behind for escape character
            if i > 0 and content[i-1] == '\\':
                processed_content += char
            else:
                if not in_double_quote:
                    processed_content += "``"
                    in_double_quote = True
                else:
                    processed_content += "''"
                    in_double_quote = False
        else:
            processed_content += char
        i += 1

    content = processed_content

    # Process single quotes, being careful with apostrophes
    # It handles 'word' -> `word'
    # It leaves don't alone.
    # It handles 'tis -> `tis
    content = re.sub(r"(\W|^)'(\w)", r"\1`\2", content)
    content = re.sub(r"(\w)'(\W|$)", r"\1'\2", content)

    return content

def main():
    tex_files = []
    for root, dirs, files in os.walk("."):
        for file in files:
            if file.endswith(".tex"):
                tex_files.append(os.path.join(root, file))

    for filepath in tex_files:
        print(f"Processing {filepath}")
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                original_content = f.read()

            modified_content = process_content(original_content)

            if original_content != modified_content:
                print(f"  ... modifications made, writing back to file.")
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(modified_content)
            else:
                print(f"  ... no changes needed.")

        except Exception as e:
            print(f"Error processing file {filepath}: {e}")

if __name__ == "__main__":
    main()
