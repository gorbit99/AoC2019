orbits = {"COM" => nil}
IO.readlines("day6input.txt").each do |line|
    line = line.chomp.split(")")
    orbits[line[1]] = line[0]
end

meorbit = []
cur = orbits["YOU"]
while cur != nil do
    meorbit << cur
    cur = orbits[cur]
end
sanorbit = []
cur = orbits["SAN"]
while cur != nil do
    sanorbit << cur
    cur = orbits[cur]
end

p sanorbit
p meorbit

while sanorbit[-1] == meorbit[-1]
    sanorbit = sanorbit[0..-2]
    meorbit = meorbit[0..-2]
end

puts meorbit.size + sanorbit.size - 1