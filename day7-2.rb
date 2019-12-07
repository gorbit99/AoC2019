

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

def loadCode(pathToCode)
    return [0, IO.readlines(pathToCode).join.split(",").map(&:to_i)]
end

def run(code, input)
    output = 0
    ip = code[0]
    loop do
        inst = code[1][ip]
        case inst % 100
        when 1
            a = getValue(code, inst, 0, code[1][ip + 1])
            b = getValue(code, inst, 1, code[1][ip + 2])
            code[1][code[ip + 3]] = a + b
            ip += 4
        when 2
            a = getValue(code, inst, 0, code[1][ip + 1])
            b = getValue(code, inst, 1, code[1][ip + 2])
            code[1][code[ip + 3]] = a * b
            ip += 4
        when 3
            if (ip != code[0])
                return output;
            c = input
            code[1][code[ip + 1]] = c
            ip += 2
        when 4
            c = getValue(code, inst, 0, code[1][ip + 1])
            output = c
            ip += 2
        when 5
            val = getValue(code, inst, 0, code[1][ip + 1])
            pos = getValue(code, inst, 1, code[1][ip + 2])
            if val != 0
                ip = pos
            else
                ip += 3
            end
        when 6
            val = getValue(code, inst, 0, code[1][ip + 1])
            pos = getValue(code, inst, 1, code[1][ip + 2])
            if val == 0
                ip = pos
            else
                ip += 3
            end
        when 7
            a = getValue(code, inst, 0, code[1][ip + 1])
            b = getValue(code, inst, 1, code[1][ip + 2])
            val = a < b ? 1 : 0
            code[1][code[ip + 3]] = val
            ip += 4
        when 8
            a = getValue(code, inst, 0, code[1][ip + 1])
            b = getValue(code, inst, 1, code[1][ip + 2])
            val = a == b ? 1 : 0
            code[1][code[ip + 3]] = val
            ip += 4
        when 99
            return -1
            exit
        else
            abort "Invalid instruction!"
        end
    end
end

possible = [0,1,2,3,4]

answers = []

possible.permutation.to_a.each do |perm|
    lastOutputs = [0, 0, 0, 0, 0]
    codes = []
    5.times do |i|
        codes[i] = loadCode("day7code.txt")
    end
    p codes
    while (lastOutputs[-1] != -1)
        5.times do |i|
            id = perm[i]
            inpId = i - 1 < 0 ? 4 : i - 1
            lastOutputs[i] = run(codes[i], lastOutputs[inpId])
        end
    end
end
puts answers.max
