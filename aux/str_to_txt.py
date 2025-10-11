#!/usr/bin/env python3

import re
import sys
import argparse

def convert_srt_to_text(input_file, output_file):
    """Convert SRT subtitle file to plain text."""
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove empty lines
    content = re.sub(r'\n\s*\n', '\n', content)
    
    # Remove subtitle numbers
    content = re.sub(r'^\d+$', '', content, flags=re.MULTILINE)
    
    # Remove timecodes (e.g., 00:00:51,590 --> 00:00:51,600)
    content = re.sub(r'^\d{2}:\d{2}:\d{2},\d{3}\s*-->\s*\d{2}:\d{2}:\d{2},\d{3}$', '', content, flags=re.MULTILINE)
    
    # Clean up the text
    lines = [line.strip() for line in content.split('\n') if line.strip()]
    
    # Remove duplicate consecutive lines
    cleaned_lines = []
    for line in lines:
        if not cleaned_lines or line != cleaned_lines[-1]:
            cleaned_lines.append(line)
    
    # Join the lines with proper spacing
    final_text = '\n'.join(cleaned_lines)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(final_text)

def main():
    parser = argparse.ArgumentParser(description='Convert SRT subtitles to plain text')
    parser.add_argument('input', help='Input SRT file')
    parser.add_argument('-o', '--output', help='Output text file (default: input_clean.txt)')
    
    args = parser.parse_args()
    
    # If no output file is specified, create one based on the input filename
    if not args.output:
        args.output = args.input.rsplit('.', 1)[0] + '_clean.txt'
    
    try:
        convert_srt_to_text(args.input, args.output)
        print(f"Successfully converted {args.input} to {args.output}")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()