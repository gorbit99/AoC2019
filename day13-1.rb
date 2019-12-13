code = IO.readlines("day13code.txt")
code = code.join.split(",").map(&:to_i)

outIndex = 0

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

outPos = []
screen = []

40.times do
    screen << []
    20.times do
        screen[-1] << " "
    end
end

characters = [" ", "#", "M", "=", "O"]

ip = 0
relativeBase = 0
loop do
    inst = code[ip]
    puts inst
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
        ip += 2
    when 4
        c = getValue(code, inst, 0, code[ip + 1], relativeBase)
        
        case outIndex
        when 0
            outPos[0] = c
        when 1
            outPos[1] = c
        else
            if screen[outPos[0]].nil?
                screen[outPos[0]] = []
            end
            screen[outPos[0]][outPos[1]] = characters[c]
        end

        outIndex = (outIndex + 1) % 3
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
        puts a, b, code[code[ip + 3]]
        ip += 4
    when 9
        val = getValue(code, inst, 0, code[ip + 1], relativeBase)
        relativeBase += val
        ip += 2
    when 99
        break
    else
        abort "Invalid instruction!"
    end
end
p screen.flatten.count(2)