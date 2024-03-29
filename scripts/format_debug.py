import os
import sys
import textwrap

def read_data(data_filepath):
    with open(data_filepath, "r") as file:
        content = file.read()

    lines = content.split("\n")

    separator="|"
    table = [line.split(separator) for line in lines if len(line.split(separator)) == len(memory_registers) + 1]

    return table

def format_table(table, registers_to_display=None):
    if registers_to_display is None:
        registers_to_display = memory_registers

    output = "|====\n"
    output += "| " + "| ".join([register.strip() + (12-len(register))*"{nbsp}" for register in registers_to_display]) + "\n\n"

    for nb_line in range(len(table)):
        output += f"| {table[nb_line][1]} a|"

        output += " a| ".join([format_register(register, table[nb_line][index+2], table[nb_line-1][index+2]) \
            if value_has_changed(table, nb_line, index+2) else "" \
            for (index,register) in enumerate(memory_registers[1:]) if register in registers_to_display])

        output += "\n"
    output += "|===="
    return output

def format_register(register, value, last_value):

    if register == "RSP":
        return format_stack_value(value.split(","))
        #return "\n".join([format_stack_value(simple_value) for simple_value in value.split(",")])

    if register == "FLAGS":
        return "".join([f"{flag}={value[flag_index]}&nbsp;" \
            for (flag_index,flag) in enumerate(FLAGS) \
                if value[flag_index] != last_value[flag_index]])

    formatted_value = format_register_value(value)
    return f"{formatted_value} "

def format_stack_value(values):
    result = ""
    for i in range(0, len(values)):
        formatted_value = format_register_value(values[i])
        if i < len(values)-1:
            if formatted_value == values[i].strip():
                formatted_value += " +"
            formatted_value += "\n"

        result += formatted_value



    return result

def format_register_value(value):
    formatted_value = value.strip()
    if len(formatted_value) > 6:
        formatted_value = textwrap.dedent(f"""\
            [%collapsible]
            .{formatted_value[-4:]}
            ====
            {formatted_value}
            ====
        """)

    return formatted_value



def value_has_changed(table, nb_line, register_index):
    return nb_line == 0 or table[nb_line][register_index] != table[nb_line-1][register_index]

memory_registers = [
    "INSTRUCTION",
    "RAX",
    "RBX",
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

if __name__ == "__main__":
    debug_file = sys.argv[1]
    table = read_data(debug_file)
    
    output_folder = sys.argv[2];

    output_doc = f"{output_folder}/format.adoc"
    with open(output_doc, "w") as file:

        registers_to_display = memory_registers.copy()
        registers_to_display.remove("RSP")

        doc = format_table(table, registers_to_display)
        file.write(doc)

    print(f"File generated: {os.path.abspath(output_doc)}")
