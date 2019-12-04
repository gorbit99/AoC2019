steps0 = Hash.new
steps1 = Hash.new

input = gets.split(",")
s = 0
pos = [0, 0]
steps0[pos.dup] = 0
input.each do |dir|
    amount = dir[1..-1].to_i
    amount.times do
        s += 1
        case dir[0]
        when 'U'
            pos[1] -= 1
        when 'D'
            pos[1] += 1
        when 'L'
            pos[0] -= 1
        when 'R'
            pos[0] += 1
        end
        if (!steps0[pos])
            steps0[pos.dup] = s
        end
    end
end
input = gets.split(",")
s = 0
pos = [0, 0]
steps1[pos.dup] = 0
min = 9999999999999
input.each do |dir|
    amount = dir[1..-1].to_i
    amount.times do
        s += 1
        case dir[0]
        when 'U'
            pos[1] -= 1
        when 'D'
            pos[1] += 1
        when 'L'
            pos[0] -= 1
        when 'R'
            pos[0] += 1
        end
        if (!steps1[pos])
            steps1[pos.dup] = s
        end
    end
end
a = []
steps0.each{|key, value|
    if steps1.has_key? key
        a << value + steps1[key]
    end
}
puts a.sort