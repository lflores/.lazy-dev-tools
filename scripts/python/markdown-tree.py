import os
import markdown2
from bs4 import BeautifulSoup
from urllib.parse import urlparse, urljoin
from pprint import pprint
import sys
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

class LinkType(Enum):
    LOCAL = auto()
    INTERNET = auto()
    EMAIL = auto()

class Link:
    def __init__(self, url,valid=False):
        self.url = url
        self.valid = valid
        if url.startswith("mailto"):
            self.link_type = LinkType.EMAIL
        elif url.startswith("http://") or url.startswith("https://"):
            self.link_type = LinkType.INTERNET
        else :
            self.link_type = LinkType.LOCAL 
    def __str__(self):
        return f"Tipo: {self.link_type}, URL: {self.url}, Valid: {GREEN if self.valid else RED}{self.valid}{NC}"
    
    def is_valid(self):
        return self.valid
    def set_valid(self, valid):
        self.valid = valid

class DependencyTree:
    def __init__(self, filepath, links):
        self.filepath = filepath
        self.links = [Link(link_url) for link_url in links]
        #self.links = links
    def __str__(self):
        links_str = "\n".join(str(link) for link in self.links)
        return f"Path: {self.filepath}\nLinks:\n{links_str}"
    
    def get_items(self):
        return [(link.url, link) for link in self.links]

def parse_markdown_links(md_content, base_path):
    html_content = markdown2.markdown(md_content)
    #print(html_content)
    soup = BeautifulSoup(html_content, 'html.parser')
    links = []
    for link in soup.find_all('a'):
        link_url = link.get('href', '')
        if not link_url.startswith("#"):
            resolved_url = urljoin(base_path, link_url)
            links.append(link_url)
    cantidad = len(links)
    #print(f"Se encontraron {cantidad} links: \n {links}")
    return links

def generate_dependency_tree(root_path):
    dependency_tree = {}
    for foldername, subfolders, filenames in os.walk(root_path):
        print(f"")
        for filename in filenames:
            if filename.endswith(".md"):
                #print(f"filename: {os.path.basename(foldername)}/{filename}")
                #filepath = os.path.join(foldername, filename)
                filepath = f"{os.path.basename(foldername)}/{filename}"
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                    links = parse_markdown_links(content, os.path.dirname(filepath))
                    dependency_tree[filepath] = DependencyTree(filepath, links)
    return dependency_tree

def generate_file_tree(filename):
    dependency_tree = {}
    if filename.endswith(".md"):
        filepath = os.path.join(foldername, filename)
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()
            links = parse_markdown_links(content, os.path.dirname(filepath))
            dependency_tree = DependencyTree(filepath, links)
    return dependency_tree

def validate_links(tree):
    for link in tree.links:
        if link.link_type == LinkType.LOCAL:
            if check_link(os.path.dirname(tree.filepath),link):
                link.set_valid(True)
            print(f"{link}")            
    return

def check_link(filepath, link):
    fullfilepath = os.path.join(filepath,link.url)
    #print(f"{fullfilepath.split('#')[0]} exist? {os.path.exists(fullfilepath.split('#')[0])}")
    return os.path.exists(fullfilepath.split('#')[0])

def print_dependency_tree(tree, indent=0):
    for file, links in tree.get_items():
        print("  " * indent + f"- {os.path.relpath(file)}")
        #print(f"{links}")
        if links and not isinstance(links,DependencyTree):
            print_dependency_tree({d: tree[d] for d in links}, indent + 1)
        elif isinstance(links,DependencyTree):
            print_dependency_tree({d: tree[d] for d in links.get_items()}, indent + 1)

foldername = ""
filename = "README.md"

# Crear el objeto ArgumentParser
parser = argparse.ArgumentParser(description='Ejemplo de script con argumentos')

# Agregar un argumento con un modificador
parser.add_argument('-n', '--name', help='Filename start scan')
parser.add_argument('-f', '--folder', help='Folder start scan')

# Analizar los argumentos de la línea de comandos
args = parser.parse_args()

if args.name and not args.name.isspace():
    filename= args.name

if not args.folder :
    foldername = os.getcwd()

print(f"{GREEN}Searching in folder {NC}'{foldername}' the file '{YELLOW}{filename}'{NC}")

dependency_tree = generate_file_tree(foldername+"/"+filename)
validate_links(dependency_tree)
#print(dependency_tree)
#print_dependency_tree(dependency_tree)