# This code is for an implementation of the Traveling Salesman Problem solving using Dynamic Programming

    class TSPSolver
    attr_reader :distance_matrix, :n, :city_names

    def initialize
        @distance_matrix = []
        @city_names = []
        @n = 0
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
        
        # Read and validate N
        @n = get_valid_integer("N must be a positive integer greater than 1")
        while @n <= 1
          puts "Error: Number of cities must be greater than 1"
          @n = get_valid_integer("N must be a positive integer greater than 1")
        end

        # Use default city names (City 1, City 2, etc.)
        @city_names = (1..@n).map { |i| "City #{i}" }

        # Input distance matrix
        puts "\nEnter the distance matrix (#{@n}x#{@n}):"
        puts "Each row should contain #{@n} distances separated by spaces"
        puts "Use 0 for the distance from a city to itself"
        puts "Use -1 for impossible direct paths (infinity)"
        
        @n.times do |i|
        while true
            puts "Enter distances from #{@city_names[i]} to all cities:"
            row = gets.chomp.split.map { |val| val.to_i }
            
            if row.length != @n
            puts "Error: You must enter exactly #{@n} values for this row"
            else
            @distance_matrix << row
            break
            end
        end
        end
        
        validate_matrix
        display_matrix
    end

    # Validate the entered matrix
    def validate_matrix
        @n.times do |i|
        if @distance_matrix[i][i] != 0
            puts "Warning: Distance from #{@city_names[i]} to itself should be 0, correcting automatically"
            @distance_matrix[i][i] = 0
        end
        end
        
        puts "\nIs the graph undirected? (distances are the same in both directions) [y/n]:"
        if gets.chomp.downcase == 'y'
        @n.times do |i|
            (i+1...@n).each do |j|
            if @distance_matrix[i][j] != @distance_matrix[j][i]
                puts "Warning: Matrix not symmetric at [#{i+1},#{j+1}] and [#{j+1},#{i+1}]"
                puts "Setting both to the minimum non-negative value"
                
                # Handle -1 (infinity) properly
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
        @city_names.each do |name|
        print name.ljust(10)
        end
        puts
        
        @distance_matrix.each_with_index do |row, i|
        print @city_names[i].ljust(10)
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
          
          @city_names = (1..@n).map { |i| "City #{i}" }
          
          @distance_matrix = []
          @n.times do |i|
              row = lines[i + 1].split.map { |val| val.to_i }
              
              if row.length != @n
                  puts "Error: Row #{i+1} has incorrect number of values"
                  return false
              end
              
              @distance_matrix << row
          end
          
          validate_matrix
          display_matrix
          return true
          
        rescue => e
          puts "Error reading file: #{e.message}"
          return false
        end
    end
    end

    if __FILE__ == $0
    tsp = TSPSolver.new
    
    puts "Do you want to input the matrix manually or from a file? (m/f):"
    choice = gets.chomp.downcase
    
    if choice == 'f'
        puts "Enter the path to the input file:"
        filename = gets.chomp
        if !tsp.input_from_file(filename)
        puts "Falling back to manual input..."
        tsp.input_matrix
        end
    else
        tsp.input_matrix
    end
    
    puts "\nMatrix input completed successfully."
    end

