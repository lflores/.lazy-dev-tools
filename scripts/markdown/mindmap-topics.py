import os
import markdown2
from bs4 import BeautifulSoup
from urllib.parse import urlparse, urljoin
from pprint import pprint
import argparse
from enum import Enum, auto

# Colors for console
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

import markdown
import re

def parse_markdown(input_file):
    with open(input_file, 'r', encoding='utf-8') as file:
        markdown_text = file.read()
    html_content = markdown.markdown(markdown_text)
    headers = extract_headers(markdown_text)
    return html_content, headers

def extract_headers(markdown_text):
    headers = []
    for match in re.finditer(r'^#+\s+(.+)', markdown_text, re.MULTILINE):
        level = match.group(0).count('#')
        header_text = match.group(1)
        headers.append((header_text, level))
    return headers

if __name__ == "__main__":
    input_file = "DEPLOYMENT.md"

    
    parsed_html, headers = parse_markdown(input_file)
    print("HTML Content:")
    print(parsed_html)
    print("\nHeaders:")
    for header, level in headers:
        print("  " * (level - 1) + f"- {header} (Level {level})")
