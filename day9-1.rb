code = IO.readlines("day9code.txt")
code = code.join.split(",").map(&:to_i)

def getValue(code, instruction, position, argument, relativeBase)
    mode = (instruction / 10 ** (2 + position)) % 10
    case mode
    when 0
        if (argument < 0)
            abort "Invalid position"
        end
        if (code[argument].nil?)
            code[argument] = 0
        end
        return code[argument]
    when 1
        return argument
    when 2
        if (argument + relativeBase < 0)
            abort "Invalid position"
        end
        if (code[argument + relativeBase].nil?)
            code[argument + relativeBase] = 0
        end
        return code[argument + relativeBase]
    else
        return 0
    end
end

def putValue(code, instruction, position, argument, relativeBase, value)
    mode = (instruction / 10 ** (2 + position)) % 10
    case mode
    when 0
        if (argument < 0)
            abort "Invalid position"
        end
        code[argument] = value
    when 2
        if (argument + relativeBase < 0)
            abort "Invalid position"
        end
        code[argument + relativeBase] = value
    else
        return 0
    end
end

ip = 0
relativeBase = 0
loop do
    inst = code[ip]
    case inst % 100
    when 1
        a = getValue(code, inst, 0, code[ip + 1], relativeBase)
        b = getValue(code, inst, 1, code[ip + 2], relativeBase)
        putValue(code, inst, 2, code[ip + 3], relativeBase, a + b)
        ip += 4
    when 2
        a = getValue(code, inst, 0, code[ip + 1], relativeBase)
        b = getValue(code, inst, 1, code[ip + 2], relativeBase)
        putValue(code, inst, 2, code[ip + 3], relativeBase, a * b)
        ip += 4
    when 3
        c = gets.to_i
        putValue(code, inst, 0, code[ip + 1], relativeBase, c)
        code[code[ip + 1]] = c
        ip += 2
    when 4
        c = getValue(code, inst, 0, code[ip + 1], relativeBase)
        puts c
        ip += 2
    when 5
        val = getValue(code, inst, 0, code[ip + 1], relativeBase)
        pos = getValue(code, inst, 1, code[ip + 2], relativeBase)
        if val != 0
            ip = pos
        else
            ip += 3
        end
    when 6
        val = getValue(code, inst, 0, code[ip + 1], relativeBase)
        pos = getValue(code, inst, 1, code[ip + 2], relativeBase)
        if val == 0
            ip = pos
        else
            ip += 3
        end
    when 7
        a = getValue(code, inst, 0, code[ip + 1], relativeBase)
        b = getValue(code, inst, 1, code[ip + 2], relativeBase)
        val = a < b ? 1 : 0
        putValue(code, inst, 2, code[ip + 3], relativeBase, val)
        ip += 4
    when 8
        a = getValue(code, inst, 0, code[ip + 1], relativeBase)
        b = getValue(code, inst, 1, code[ip + 2], relativeBase)
        val = a == b ? 1 : 0
        putValue(code, inst, 2, code[ip + 3], relativeBase, val)
        ip += 4
    when 9
        val = getValue(code, inst, 0, code[ip + 1], relativeBase)
        relativeBase += val
        ip += 2
    when 99
        exit
    else
        abort "Invalid instruction!"
    end
end