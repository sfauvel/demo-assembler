import sys

def read_data(data_filepath):
    with open(data_filepath, "r") as file:
        content = file.read()
    
    lines = content.split("\n")
    separator="|"
    table = [line.split(separator) for line in lines if len(line.split(separator)) == 13]
    
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
                elif register == "FLAGS":
                    last_value = table[nb_line-1][register_index]
                    for flag_index,flag in enumerate(FLAGS):
                        if value[flag_index] != last_value[flag_index]:
                            output += f"{flag}={value[flag_index]}&nbsp;"
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
    "FLAGS"
]    


#https://en.wikipedia.org/wiki/FLAGS_register
FLAGS= [
	"CF", 	# Carry flag 	Status 	CY(Carry) 	NC(No Carry)
    "—" ,	# Reserved, always 1 in EFLAGS [2][3] 	—
	"PF", 	# Parity flag 	Status 	PE(Parity Even) 	PO(Parity Odd)
    "—" ,	# Reserved[3] 	—
	"AF", 	# Auxiliary Carry flag[4] 	Status 	AC(Auxiliary Carry) 	NA(No Auxiliary Carry)
    "—" ,	# Reserved[3] 	—
	"ZF", 	# Zero flag 	Status 	ZR(Zero) 	NZ(Not Zero)
	"SF", 	# Sign flag 	Status 	NG(Negative) 	PL(Positive)
	"TF", 	# Trap flag (single step) 	Control
	"IF", 	# Interrupt enable flag 	Control 	EI(Enable Interrupt) 	DI(Disable Interrupt)
 	"DF", 	# Direction flag 	Control 	DN(Down) 	UP(Up)
 	"OF", 	# Overflow flag 	Status 	OV(Overflow) 	NV(Not Overflow)

 	"IOPL", 	#I/O privilege level (286+ only),always all-1s on 8086 and 186 	System
 	"NT", 	#Nested task flag (286+ only),always 1 on 8086 and 186 	System
 	"MD", 	#Mode flag (NEC V-series only),[5] reserved on all Intel CPUs.
#Always 1 on 8086/186, 0 on 286 and later. 	Control 	(NEC only)
]

DEBUG_PATH="../work/debug"
if __name__ == "__main__":
    debug_file = sys.argv[1]
    table = read_data(debug_file)

    output_doc = f"{DEBUG_PATH}/format.adoc"
    with open(output_doc, "w") as file:
        doc = format_table(table)
        file.write(doc)
    
    print(f"File generated: {output_doc}")