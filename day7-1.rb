

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

def run(pathToCode, input)
    code = IO.readlines(pathToCode).join.split(",").map(&:to_i)
    output = []
    ip = 0
    inpC = 0
    loop do
        inst = code[ip]
        case inst % 100
        when 1
            a = getValue(code, inst, 0, code[ip + 1])
            b = getValue(code, inst, 1, code[ip + 2])
            code[code[ip + 3]] = a + b
            ip += 4
        when 2
            a = getValue(code, inst, 0, code[ip + 1])
            b = getValue(code, inst, 1, code[ip + 2])
            code[code[ip + 3]] = a * b
            ip += 4
        when 3
            c = input[inpC]
            inpC += 1
            code[code[ip + 1]] = c
            ip += 2
        when 4
            c = getValue(code, inst, 0, code[ip + 1])
            output << c
            ip += 2
        when 5
            val = getValue(code, inst, 0, code[ip + 1])
            pos = getValue(code, inst, 1, code[ip + 2])
            if val != 0
                ip = pos
            else
                ip += 3
            end
        when 6
            val = getValue(code, inst, 0, code[ip + 1])
            pos = getValue(code, inst, 1, code[ip + 2])
            if val == 0
                ip = pos
            else
                ip += 3
            end
        when 7
            a = getValue(code, inst, 0, code[ip + 1])
            b = getValue(code, inst, 1, code[ip + 2])
            val = a < b ? 1 : 0
            code[code[ip + 3]] = val
            ip += 4
        when 8
            a = getValue(code, inst, 0, code[ip + 1])
            b = getValue(code, inst, 1, code[ip + 2])
            val = a == b ? 1 : 0
            code[code[ip + 3]] = val
            ip += 4
        when 99
            return output
            exit
        else
            abort "Invalid instruction!"
        end
    end
    return output
end

possible = [0,1,2,3,4]

answers = []

possible.permutation.to_a.each do |perm|
    cur = 0
    perm.each do |id|
        input = [id, cur]
        cur = run("day7code.txt", input)[-1]
    end
    answers << cur
end
puts answers.max
