# Traveling Salesman Problem Solver

## Overview
This program solves the Traveling Salesman Problem (TSP) using Dynamic Programming. The TSP is a classic algorithmic problem where the goal is to find the shortest possible route that visits each city exactly once and returns to the origin city.

## Features
- Advanced Dynamic Programming solution with memoization
- Multiple input methods (manual entry, file input, built-in test cases)
- Command-line interface with various options
- Matrix validation (diagonal elements, symmetry check)
- Performance timing and optimization
- Path visualization with distances
- Support for both directed and undirected graphs

## Requirements
- Ruby 2.6 or higher

## Usage

### Running the Program

```bash
ruby src/main.rb [OPTIONS]
```

### Command Line Options

```
Options:
  -f, --file FILENAME  Read input matrix from FILENAME
  -h, --help           Display this help message
  -t, --test           Run with a built-in test case
  -s, --sample         List available sample files
```

### Interactive Mode

When run without arguments, the program offers an interactive menu:

1. **Manual input** - Enter the distance matrix directly
2. **Read from file** - Specify a file containing the matrix
3. **Use built-in test case** - Run with a predefined example
4. **List sample files** - Show available sample files
5. **Exit** - Quit the program

### Input Format

The program supports multiple ways of providing input:

1. **Manual Input**:
   - Enter the number of cities (N)
   - Enter the N×N distance matrix, one row at a time
   - Use 0 for distance from a city to itself
   - Use -1 to represent infinity (no direct path)

2. **File Input**:
   - The first line contains a single integer N (number of cities)
   - The next N lines each contain N integers representing the distance matrix
   - Example:
     ```
     4
     0 143 786 444
     143 0 746 393
     786 746 0 323
     444 393 323 0
     ```

### Input Format Notes
- Use `0` for the distance from a city to itself
- Use `-1` to represent infinity (no direct path)
- For undirected graphs, the matrix should be symmetric (the program will ask if the graph is undirected)
- The program automatically validates and corrects common issues in the input matrix

### Sample Files
Sample input files are included in the `test/` directory, including:
- Small test cases (4-5 cities)
- Medium test cases (10-15 cities)
- Large test cases (20+ cities)

Run `ruby src/main.rb -s` to list all available sample files.

## Algorithm

The program uses Dynamic Programming with the following approach:

1. Represent visited cities using bit manipulation for efficiency
2. Use memoization to avoid redundant calculations
3. Recursively find the optimal path from each state
4. Reconstruct the optimal path from the memoization cache

Time complexity: O(n²·2ⁿ) where n is the number of cities
Space complexity: O(n·2ⁿ)

## Output

The program displays:
1. The distance matrix with city names
2. The optimal route for the TSP
3. Total distance of the optimal route
4. Computation time
5. Step-by-step path visualization with distances

## Example Output

```
================================================================================
                      TRAVELING SALESMAN PROBLEM SOLVER                       
                      Dynamic Programming Implementation                       
================================================================================

Distance Matrix:
          City 1    City 2    City 3    City 4    
City 1    0         10        15        20        
City 2    10        0         35        25        
City 3    15        35        0         30        
City 4    20        25        30        0         

Solving the TSP problem...
This may take a while for large matrices...

================================================================================
                               SOLUTION FOUND!                                
================================================================================
Optimal TSP Solution:
→ Minimum distance: 80
→ Computation time: 5 milliseconds

Optimal path:
  City 1 → City 2 → City 4 → City 3 → City 1

Path visualization:
City 1 → City 2 (10)
City 2 → City 4 (25)
City 4 → City 3 (30)
City 3 → City 1 (15)
```

## Author
- Haegen Quinston (13523109)
- Institut Teknologi Bandung

## License
This project is part of the IF2211 Strategi Algoritma course assignment.