def loadCode(path)
    return [0, IO.readlines(path).join.split(",").map(&:to_i)]
end

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

def run(code, inputQueue)
    outputs = []
    ip = code[0]
    loop do
        inst = code[1][ip]
        case inst % 100
        when 1
            a = getValue(code[1], inst, 0, code[1][ip + 1])
            b = getValue(code[1], inst, 1, code[1][ip + 2])
            code[1][code[1][ip + 3]] = a + b
            ip += 4
        when 2
            a = getValue(code[1], inst, 0, code[1][ip + 1])
            b = getValue(code[1], inst, 1, code[1][ip + 2])
            code[1][code[1][ip + 3]] = a * b
            ip += 4
        when 3
            if inputQueue.size == 0
                code[0] = ip
                return outputs
            else
                inp = inputQueue[0]
                inputQueue = inputQueue[1..-1]
                code[1][code[1][ip + 1]] = inp
                ip += 2
            end
        when 4
            c = getValue(code[1], inst, 0, code[1][ip + 1])
            ip += 2
            outputs << c
        when 5
            val = getValue(code[1], inst, 0, code[1][ip + 1])
            pos = getValue(code[1], inst, 1, code[1][ip + 2])
            if val != 0
                ip = pos
            else
                ip += 3
            end
        when 6
            val = getValue(code[1], inst, 0, code[1][ip + 1])
            pos = getValue(code[1], inst, 1, code[1][ip + 2])
            if val == 0
                ip = pos
            else
                ip += 3
            end
        when 7
            a = getValue(code[1], inst, 0, code[1][ip + 1])
            b = getValue(code[1], inst, 1, code[1][ip + 2])
            val = a < b ? 1 : 0
            code[1][code[1][ip + 3]] = val
            ip += 4
        when 8
            a = getValue(code[1], inst, 0, code[1][ip + 1])
            b = getValue(code[1], inst, 1, code[1][ip + 2])
            val = a == b ? 1 : 0
            code[1][code[1][ip + 3]] = val
            ip += 4
        when 99
            return outputs + [nil]
        else
            abort "Invalid instruction!"
        end
    end
end

possible = [5, 6, 7, 8, 9]

results = []

possible.permutation.to_a.each do |perm|
    codes = []
    5.times do
        codes << loadCode("day7code.txt")
    end
    inputs = [[perm[0], 0], [perm[1]], [perm[2]], [perm[3]], [perm[4]]]
    loop do
        done = false
        5.times do |i|
            outputs = run(codes[i], inputs[i])
            outId = i + 1 > 4 ? 0 : i + 1
            inputs[i] = []
            inputs[outId] += outputs
            if i == 4 and outputs[-1].nil?
                results << outputs[-2]
                done = true
                break
            end
        end
        if done
            break
        end
    end
end

results.sort!
puts results