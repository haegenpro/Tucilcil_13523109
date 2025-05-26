class TSPSolver
  attr_reader :distance_matrix, :n

  def initialize
    @distance_matrix = []
    @n = 0
    @memo = {}
  end
  def input_matrix
    puts "=== Traveling Salesman Problem Solver ==="
    puts ""
    puts """
    Input format:
    N - number of cities (>1)
    N x N matrix of distances
    """
    puts "Enter the number of cities (N):"
    
    @n = get_valid_integer("N must be a positive integer greater than 1")
    while @n <= 1
      puts "Error: Number of cities must be greater than 1"
      @n = get_valid_integer("N must be a positive integer greater than 1")
    end
    puts "\nEnter the distance matrix (#{@n}x#{@n}):"
    puts "Each row should contain #{@n} distances separated by spaces"
    puts "Use 0 for the distance from a city to itself"
    puts "Use -1 for impossible direct paths (infinity)"
    
    @n.times do |i|
      puts "Enter row #{i+1}:"
      while true
        row = gets.chomp.split.map { |val| val.to_i }
        
        if row.length != @n
          puts "Error: You must enter exactly #{@n} values for this row"
        else
          @distance_matrix << row
          break
        end      end
    end
    
    validate_matrix(true)
    display_matrix()
  end
  def validate_matrix(interactive = true)
    @n.times do |i|
      if @distance_matrix[i][i] != 0
        puts "Warning: Distance from city #{i+1} to itself should be 0, correcting automatically"
        @distance_matrix[i][i] = 0
      end
    end
    
    # Skip interactive prompt for non-interactive mode
    is_undirected = false
    if interactive
      puts "\nIs the graph undirected? (distances are the same in both directions) [y/n]:"
      is_undirected = gets.chomp.downcase == 'y'
    else
      # Check if matrix is symmetric
      is_symmetric = true
      @n.times do |i|
        (i+1...@n).each do |j|
          if @distance_matrix[i][j] != @distance_matrix[j][i]
            is_symmetric = false
            break
          end
        end
        break unless is_symmetric
      end
      
      # Assume undirected if matrix is symmetric
      is_undirected = is_symmetric
      puts "Matrix analyzed as #{is_undirected ? 'undirected' : 'directed'} graph"
    end
    
    if is_undirected
      @n.times do |i|
        (i+1...@n).each do |j|
          if @distance_matrix[i][j] != @distance_matrix[j][i]
            puts "Warning: Matrix not symmetric at [#{i+1},#{j+1}] and [#{j+1},#{i+1}]"
            puts "Setting both to the minimum non-negative value"
            
            if @distance_matrix[i][j] == -1 && @distance_matrix[j][i] != -1
              @distance_matrix[i][j] = @distance_matrix[j][i]
            elsif @distance_matrix[j][i] == -1 && @distance_matrix[i][j] != -1
              @distance_matrix[j][i] = @distance_matrix[i][j]
            else
              min_val = [@distance_matrix[i][j], @distance_matrix[j][i]].reject { |x| x < 0 }.min
              @distance_matrix[i][j] = @distance_matrix[j][i] = min_val
            end
          end
        end
      end
    end
  end
  def display_matrix
    puts "\nDistance Matrix:"
    
    print "          "
    (1..@n).each do |i|
      print "City #{i}".ljust(10)
    end
    puts
    
    @distance_matrix.each_with_index do |row, i|
      print "City #{i+1}".ljust(10)
      row.each do |dist|
        if dist == -1
          print "∞".ljust(10)
        else
          print dist.to_s.ljust(10)
        end
      end
      puts
    end
  end

  def get_valid_integer(error_msg)
    while true
      input = gets.chomp
      begin
        return Integer(input)
      rescue ArgumentError
        puts "Error: #{error_msg}"
      end
    end
  end  
  def input_from_file(filename)
    begin
      lines = File.readlines(filename).map(&:chomp)
      
      @n = Integer(lines[0])
      
      if @n <= 1
        puts "Error: Number of cities in file must be greater than 1"
        return false
      end
      
      if lines.length < @n + 1
        puts "Error: File format incorrect. Need at least #{@n + 1} lines"
        return false
      end
      
      @distance_matrix = []
      @n.times do |i|
        row = lines[i + 1].split.map { |val| val.to_i }
        
        if row.length != @n
          puts "Error: Row #{i+1} has incorrect number of values"
          return false
        end
          @distance_matrix << row
      end
      
      # Call validate_matrix in non-interactive mode
      validate_matrix(false)
      display_matrix
      return true
      rescue => e
      puts "Error reading file: #{e.message}"
      return false
    end
  end
  
  def solve_tsp
    start = 0
    @memo = {}
    
    if @n <= 1
      return { distance: 0, path: [start] }
    end
    
    all_nodes = (0...@n).to_a
    visited = 1 << start
    min_distance = tsp_recursive(start, visited)
    
    path = reconstruct_path(start)
    
    return { distance: min_distance, path: path }
  end
  
  private
  
  def tsp_recursive(current, visited)
    if visited == (1 << @n) - 1
      return @distance_matrix[current][0] == -1 ? Float::INFINITY : @distance_matrix[current][0]
    end
    
    key = [current, visited]
    return @memo[key] if @memo.has_key?(key)
    
    min_distance = Float::INFINITY
    
    (0...@n).each do |next_node|
      next if (visited & (1 << next_node)) != 0 || @distance_matrix[current][next_node] == -1
      
      distance = @distance_matrix[current][next_node] + tsp_recursive(next_node, visited | (1 << next_node))
      
      if distance < min_distance
        min_distance = distance
        @memo[[current, visited, :next]] = next_node
      end
    end
    
    @memo[key] = min_distance
    
    return min_distance
  end
  
  def reconstruct_path(start)
    path = [start]
    current = start
    visited = 1 << start
    
    while path.size < @n
      next_node = @memo[[current, visited, :next]]
      path << next_node
      visited |= (1 << next_node)
      current = next_node
    end
    
    return path
  end
end

if __FILE__ == $0
  puts "=" * 80
  puts "TRAVELING SALESMAN PROBLEM SOLVER".center(80)
  puts "Dynamic Programming Implementation".center(80)
  puts "=" * 80
  puts

  tsp = TSPSolver.new
  if ARGV.length > 0
    if ARGV[0] == '-f' || ARGV[0] == '--file'
      if ARGV.length < 2
        puts "Error: Missing filename after #{ARGV[0]} option"
        puts "Usage: ruby main.rb -f <filename>"
        exit(1)
      end
      
      filename = ARGV[1]
      puts "Reading from file: #{filename}"
      if !tsp.input_from_file(filename)
        puts "Error: Could not process the input file."
        exit(1)
      end
    elsif ARGV[0] == '-h' || ARGV[0] == '--help'
      puts "Usage: ruby main.rb [OPTIONS]"
      puts "Options:"
      puts "  -f, --file FILENAME  Read input matrix from FILENAME"
      puts "  -h, --help           Display this help message"
      puts "  -t, --test           Run with a built-in test case"
      puts "  -s, --sample         List available sample files"
      exit(0)
    elsif ARGV[0] == '-t' || ARGV[0] == '--test'
      puts "Using built-in test case (4 cities)"
      test_matrix = [
        [0, 10, 15, 20],
        [10, 0, 35, 25],
        [15, 35, 0, 30],
        [20, 25, 30, 0]
      ]
      tsp.instance_variable_set(:@n, 4)
      tsp.instance_variable_set(:@distance_matrix, test_matrix)
      tsp.display_matrix
    elsif ARGV[0] == '-s' || ARGV[0] == '--sample'
      puts "Available sample files in test directory:"
      Dir.glob('../test/*.txt').each do |file|
        puts "  #{File.basename(file)}"
      end
      puts "\nUse: ruby main.rb -f <filename> to run with a specific file"
      exit(0)
    else
      puts "Unknown option: #{ARGV[0]}"
      puts "Use -h or --help for usage information"
      exit(1)
    end
  else
    puts "Select input method:"
    puts "1. Manual input"
    puts "2. Read from file"
    puts "3. Use built-in test case"
    puts "4. List sample files"
    puts "5. Exit"
    print "\nYour choice (1-5): "
    
    choice = gets.chomp.to_i
    
    case choice
    when 1
      tsp.input_matrix
    when 2
      puts "Enter the path to the input file:"
      filename = gets.chomp
      if !tsp.input_from_file(filename)
        puts "Falling back to manual input..."
        tsp.input_matrix
      end
    when 3
      puts "Using built-in test case (4 cities)"
      test_matrix = [
        [0, 10, 15, 20],
        [10, 0, 35, 25],
        [15, 35, 0, 30],
        [20, 25, 30, 0]
      ]
      tsp.instance_variable_set(:@n, 4)
      tsp.instance_variable_set(:@distance_matrix, test_matrix)
      tsp.display_matrix
    when 4
      puts "Available sample files in test directory:"
      Dir.glob('../test/*.txt').each do |file|
        puts "  #{File.basename(file)}"
      end
      puts "\nRestarting program..."
      exec "ruby #{$0}"
      exit(0)
    when 5
      puts "Exiting program."
      exit(0)
    else
      puts "Invalid choice. Defaulting to manual input."
      tsp.input_matrix
    end
  end
  
  puts "\nMatrix input completed successfully."
  
  start_time = Time.now
  
  puts "\nSolving the TSP problem..."
  puts "This may take a while for large matrices..."
  result = tsp.solve_tsp
  
  elapsed_time = Time.now - start_time
  
  time_str = if elapsed_time < 1
               "#{(elapsed_time * 1000).round} milliseconds"
             elsif elapsed_time < 60
               "#{elapsed_time.round(2)} seconds"
             else
               mins = (elapsed_time / 60).floor
               secs = (elapsed_time % 60).round
               "#{mins} minutes #{secs} seconds"
             end
  
  puts "\n" + "=" * 80
  puts "SOLUTION FOUND!".center(80)
  puts "=" * 80
  puts "Optimal TSP Solution:"
  puts "→ Minimum distance: #{result[:distance]}"
  puts "→ Computation time: #{time_str}"
  puts "\nOptimal path:"
  puts "  " + result[:path].map { |i| "City #{i + 1}" }.join(' → ') + " → City #{result[:path].first + 1}"
  
  if tsp.n <= 10
    puts "\nPath visualization:"
    path_with_distances = []
    full_path = result[:path] + [result[:path].first]
    
    (0...full_path.length-1).each do |i|
      from = full_path[i]
      to = full_path[i+1]
      distance = tsp.distance_matrix[from][to]
      path_with_distances << "City #{from + 1} → City #{to + 1} (#{distance})"
    end
    
    puts path_with_distances.join("\n")
  end
end

