# Traveling Salesman Problem Solver

## Overview
This program solves the Traveling Salesman Problem (TSP) using Dynamic Programming. The TSP is a classic algorithmic problem where the goal is to find the shortest possible route that visits each city exactly once and returns to the origin city.

## Features
- Input an adjacency matrix either manually or from a file
- Support for named cities
- Matrix validation (diagonal elements, symmetry check)
- Distance visualization with infinity support
- Optimal route calculation using Dynamic Programming

## Requirements
- Ruby 2.6 or higher

## Usage

### Running the Program
```bash
ruby src/main.rb
```

### Input Format
The program supports two ways of providing input:

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

### Sample File
A sample input file is included at `src/sample_input.txt` that demonstrates the correct format.

### Input Options
The program offers two ways to input the adjacency matrix:

1. **Manual Input**: Enter the number of cities and distances between each pair of cities.
2. **File Input**: Provide a file with the following format:
   ```
   N               # Number of cities
   d11 d12 ...     # Distance matrix (N×N)
   d21 d22 ...
   ...
   ```

### Input Format Notes
- Use `0` for the distance from a city to itself
- Use `-1` to represent impossible direct paths (infinity)
- For undirected graphs, the matrix should be symmetric

### Example Input File
```
4
0 143 786 444
143 0 746 393
786 746 0 323
444 393 323 0
```

## Output
The program will display:
1. The distance matrix with city names
2. The optimal route for the TSP
3. Total distance of the optimal route

## Author
- Haegen Quinston (13523109)
- Institut Teknologi Bandung