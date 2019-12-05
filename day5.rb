code = IO.readlines("day5code.txt")
code = code.join.split(",").map(&:to_i)

def getValue(code, instruction, position, argument)
    mode = (instruction / 10 ** (2 + position)) % 10
    case mode
    when 0
        return code[argument]
    when 1
        return argument
    else
        return 0
    end
end

ip = 0
loop do
    inst = code[ip]
    case inst % 100
    when 1
        puts "add"
        a = getValue(code, inst, 0, code[ip + 1])
        b = getValue(code, inst, 1, code[ip + 2])
        code[code[ip + 3]] = a + b
        ip += 4
    when 2
        puts "mul"
        a = getValue(code, inst, 0, code[ip + 1])
        b = getValue(code, inst, 1, code[ip + 2])
        code[code[ip + 3]] = a * b
        ip += 4
    when 3
        puts "get"
        c = gets.to_i
        code[code[ip + 1]] = c
        ip += 2
    when 4
        puts "put"
        c = getValue(code, inst, 0, code[ip + 1])
        puts c
        ip += 2
    when 5
        puts "jump-if-true"
        val = getValue(code, inst, 0, code[ip + 1])
        pos = getValue(code, inst, 1, code[ip + 2])
        if val != 0
            ip = pos
        else
            ip += 3
        end
    when 6
        puts "jump-if-false"
        val = getValue(code, inst, 0, code[ip + 1])
        pos = getValue(code, inst, 1, code[ip + 2])
        if val == 0
            ip = pos
        else
            ip += 3
        end
    when 7
        puts "less than"
        a = getValue(code, inst, 0, code[ip + 1])
        b = getValue(code, inst, 1, code[ip + 2])
        val = a < b ? 1 : 0
        code[code[ip + 3]] = val
        ip += 4
    when 8
        puts "equals"
        a = getValue(code, inst, 0, code[ip + 1])
        b = getValue(code, inst, 1, code[ip + 2])
        val = a == b ? 1 : 0
        code[code[ip + 3]] = val
        ip += 4
    when 99
        exit
    else
        abort "Invalid instruction!"
    end
end