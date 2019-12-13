def approx(a, b)
    return (a - b).abs < 0.01
end

def isVisible(asteroids, from, what)
    dx = what[0] - from[0]
    dy = what[1] - from[1]
    steps = dx.abs.gcd(dy.abs)
    dx /= steps
    dy /= steps
    (steps - 1).times do |i|
        if asteroids[from[1] + dy * (i + 1)][from[0] + dx * (i + 1)] == '#'
            return false
        end
    end
    return true
end

def bestPos(asteroids)
    max = 0
    maxPos = [0,0]
    
    asteroids.size.times do |y|
        asteroids[0].size.times do |x|
            if asteroids[y][x] == '#'
                sees = 0
                asteroids.size.times do |y2|
                    asteroids[0].size.times do |x2|
                        if x == x2 and y == y2
                            next
                        end
                        if asteroids[y2][x2] == '#'
                            if isVisible(asteroids, [x, y], [x2, y2])
                                sees += 1
                            end
                        end
                    end
                end
                if sees > max
                    max = sees
                    maxPos = [x, y]
                end
            end
        end
    end
    return maxPos
end

def dist(a, b)
    return (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2
end

asteroids = IO.readlines("day10input.txt").map{|x|x.chomp.chars}
pos = bestPos(asteroids)

queue = []
if (pos[1] == 0)
    if (pos[0] == asteroids[0].size - 1)
        queue << [asteroids[0].size - 1, asteroids.size - 1]
    else
        queue << [asteroids[0].size - 1, 0]
    end
else
    queue << [pos[0], 0]
end

puts asteroids.map{|x|x.join}
puts

points = []
asteroids.size.times do |y|
    asteroids[0].size.times do |x|
        if (x == pos[0] and y == pos[1])
            next
        end
        points << [x, y]
    end
end

points.map{|x|
    x[2] = Math.atan2(x[0] - pos[0], x[1] - pos[1])
    x[3] = dist(x, pos)
}

points.sort_by! do |p|
    [-p[2], -p[3]]
end

index = 0
loop do
    points.each do |x|
        if asteroids[x[1]][x[0]] == '#' and isVisible(asteroids, pos, x)
            asteroids[x[1]][x[0]] = ' '
            index += 1
            if index == 200
                p x
                exit
            end
        end
    end 
    puts asteroids.map{|x|x.join}
    puts
end

puts asteroids.map{|x|x.map{|x|x.ljust(3)}.join }