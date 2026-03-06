import re
import sys
from enum import Enum

class REGISTER(Enum):
    RAX = "rax"
    RBX = "rbx"
    RCX = "rcx"
    RDX = "rdx"
    RSI = "rsi"
    RDI = "rdi"
    RBP = "rbp"
    RSP = "rsp"
    R8 = "r8"
    R9 = "r9"
    R10 = "r10"
    R11 = "r11"
    R12 = "r12"
    R13 = "r13"
    R14 = "r14"
    R15 = "r15"
    RIP = "rip"
    EFLAGS = "eflags"
    CS = "cs"
    SS = "ss"
    DS = "ds"
    ES = "es"
    FS = "fs"
    GS = "gs"
    FS_BASE = "fs_base"
    GS_BASE = "gs_base"

class RegisterState:
    
    #register_list=["rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15", "rip", "eflags", "cs", "ss", "ds", "es", "fs", "gs", "fs_base", "gs_base"]
    register_list=[r.value for r in REGISTER]

    class Register:         
        def __init__(self, register, hexa, decimal):
            self.register = register
            self.hexa = hexa
            self.decimal = decimal

    def __init__(self, registers_lines):
        self.registers_lines = registers_lines

    def parse_line(self, line):
        match = re.match(r'(\w+)\s+(0x[0-9a-f]+)\s+(.+)', line)
        if match:
            return RegisterState.Register(match.group(1), match.group(2), match.group(3))
        else:
            return None

    def to_line(self, headers):
        registers = [self.parse_line(line) for line in self.registers_lines]
        register_map = {r.register: r for r in registers if r is not None}

        extract_value = lambda r: register_map[r].decimal if r in register_map else f"??{r}??"
        return "| " + " | ".join([extract_value(r) for r in headers])

def document(log_file):

    with open(log_file, 'r') as f:
        lines = f.readlines()

    instructions = []
    register_states=[]
    buffer = []
    next = "instruction"
    for line in lines:
        #print(f">>> {line}", end="")
        if next == "instruction":
            if line.startswith("========"):
                instruction = buffer[-1]
                instructions.append(instruction)
                buffer=[]
                next = "registers"
        elif next == "registers":
            if line.startswith("--------------------"):
                register_state = RegisterState(buffer)
                register_states.append(register_state)
                buffer=[]
                next = "instruction"

        buffer.append(line)

    def format_instruction(instruction):
        match = re.match(r'(\d+)\s+(.+)', instruction.split(";")[0])
        if match:
            return match.group(1) + " | " + match.group(2)
        else:
            return " | "
    

    print("".join(instructions))
    
    # Select only some headers
    headers = [r.value for r in [
        REGISTER.RAX,
        REGISTER.RBX,
        REGISTER.RCX,
        REGISTER.RDX,
        REGISTER.RDI,
        REGISTER.RSI,
        REGISTER.EFLAGS,
    ]]
    #headers = RegisterState.register_list

    instructions.insert(0,"")
    output = "\n".join([
        "= Program execution",
        "",
        "[%autowidth]",
        "|====",
        "| Line | Instruction" + " | " + " | ".join([h for h in headers]),
        "",
        "\n".join(["| " + format_instruction(instructions[i]) + " " + register_states[i].to_line(headers) for i in range(len(register_states))]),
        "| " + format_instruction(instructions[-2]) + " | " + " | ".join(["" for h in headers]),
        "|===="
    ])

    with open(re.sub(r"\.log$", ".adoc", log_file), 'w') as f:
        f.write(output)

if __name__ == "__main__":
    instruction_file = sys.argv[1] if len(sys.argv) > 1 else "output.log"
        
    document(instruction_file)