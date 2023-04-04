

def read_data():
    with open("tmp.adoc", "r") as file:
        content = file.read()
    
    lines = content.split("\n")
    separator="|"
    table = [line.split(separator) for line in lines if len(line.split(separator)) == 12]
    
    return table

def format_table(table):
    output = "|====\n"
    output += "| " + "| ".join(xxx) + "\n\n"
    for nb_line in range(len(table)):
        output += f"| {table[nb_line][1]}"
        for index,register in enumerate(xxx[1:]):
            register_index = index + 2
            output += "| "
            if (nb_line == 0 or  table[nb_line][register_index] !=  table[nb_line-1][register_index] ):
                value = table[nb_line][register_index]
                if register == "RSP":
                    output += " +\n".join(value.split(","))
                else:
                    output += f"{value.strip()} "
                
        output += "\n"
    output += "|===="
    return output
    
xxx = [
    "INSTRUCTION",
    "RAX",
    "RCX",
    "RDI",
    "RSI",
    "RDX",
    "R8 ",
    "R9 ",
    "R10",
    "R11",
    "RSP",
]    


DEBUG_PATH="../work/debug"
if __name__ == "__main__":
    table = read_data()

    output_doc = f"{DEBUG_PATH}/format.adoc"
    with open(output_doc, "w") as file:
        doc = format_table(table)
        file.write(doc)
    
    print(f"File generated: {output_doc}")