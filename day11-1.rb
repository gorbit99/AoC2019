code = IO.readlines("day11code.txt")
code = code.join.split(",").map(&:to_i)

painted = Hash.new

position = [0, 0]
painted[position.dup] = 1
dir = 0
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
        c = painted[position].nil? ? 0 : painted[position]
        putValue(code, inst, 0, code[ip + 1], relativeBase, c)
        code[code[ip + 1]] = c
        ip += 2
    when 4
        c = getValue(code, inst, 0, code[ip + 1], relativeBase)
        if outIndex % 2 == 0
            painted[position.dup] = c
        else
            if c == 0
                dir = dir - 1 < 0 ? 3 : dir - 1
            else
                dir = (dir + 1) % 4
            end
            case dir
            when 0
                position[1] -= 1
            when 1
                position[0] += 1
            when 2
                position[1] += 1
            when 3
                position[0] -= 1
            end
        end
        outIndex += 1
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
        p painted.size
        break
    else
        abort "Invalid instruction!"
    end
end

hull = []
50.times do
    hull << []
    50.times do
        hull[-1] << ' '
    end
end

painted.each do |pos|
    hull[pos[0][1]][pos[0][0]] = pos[1] == 0 ? ' ' : '#'
end

puts hull.map(&:join)