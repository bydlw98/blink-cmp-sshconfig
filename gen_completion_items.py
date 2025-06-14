from typing import TextIO
from bs4 import BeautifulSoup
import requests
import re


def format_completion_item(fp: TextIO, label: str, documentation: str):
    fp.write("\t{\n")
    fp.write(f'\t\tlabel = "{label}",\n')
    fp.write('\t\tkind = require("blink.cmp.types").CompletionItemKind.Keyword,\n')
    fp.write("\t\tdocumentation = {{\n")
    fp.write('\t\t\tkind = "markdown",\n')
    fp.write(f"\t\t\tvalue = [[{documentation}]],\n")
    fp.write("\t\t},\n")
    fp.write("\t},\n")


def write_completion_items(fp: TextIO):
    r = requests.get("https://man.openbsd.org/ssh_config")

    soup = BeautifulSoup(r.text, features="html.parser")
    keyword_list_tag = soup.find("dl", attrs={"class": "Bl-tag"})
    label: str = ""
    documentation: str = ""

    for tag in keyword_list_tag.children:
        if tag.name == "dt":
            label = tag["id"]
        elif tag.name == "dd":
            for elem in tag.find_all("p"):
                elem.replace_with(f"\n\n{elem.text}\n\n")

            for elem in tag.find_all("code", attrs={"class": "Cm"}):
                elem.replace_with(f"**{elem.text}**")

            for elem in tag.find_all("var", attrs={"class": "Ar"}):
                elem.replace_with(f"|{elem.text}|")

            for elem in tag.find_all("a"):
                elem.replace_with(f"[{elem.text}]")

            documentation = tag.get_text()
            documentation = documentation.replace('"', '\\"')

            new_documentation = ""
            for paragraph in re.split(r"[\n]{2,}", documentation):
                new_documentation += " ".join(paragraph.split()) + "\n\n"
            documentation = new_documentation
        elif label == "" or documentation == "":
            continue
        else:
            format_completion_item(fp, label, documentation)
            label = ""
            documentation = ""


def main():
    with open("lua/blink-cmp-sshconfig/completion_items.lua", "w") as fp:
        fp.write("--- Do NOT edit this file\n")
        fp.write("--- This file is autogenerated from gen_completion_items.py\n")
        fp.write("\n")
        fp.write("--- @type lsp.CompletionItem[]\n")
        fp.write("return {\n")
        write_completion_items(fp)
        fp.write("}\n")


if __name__ == "__main__":
    main()
