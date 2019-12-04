def runLength(a)
    result = []
    result << 1
    for i in 1...a.size do
        if a[i] == a[i - 1]
            result[-1] += 1
        else
            result << 1
        end
    end
    return result
end

range = gets.split("-").map(&:to_i)
count = 0
for i in range[0]..range[1] do
    dig = i.digits
    if (dig.uniq.size < 6 && dig.sort.reverse == dig)
        a = runLength i.to_s
        if (a.include? 2)
            count += 1
        end
    end
end
puts count