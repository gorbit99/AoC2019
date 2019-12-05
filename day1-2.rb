modules = IO.readlines("day1input.txt").map(&:to_i)
sum = 0
modules.each do |m|
    while m > 0 do
        m = m / 3 - 2
        if (m > 0)
            sum += m
        end
    end
end
puts sum