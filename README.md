# Spanning Tree

**Project:** Spanning Tree 
**Name:** Aneta Dufková
**Login:** xdufko02
**Year:** 2022

**Description:**
The program finds all the spanning trees of a given graph.

## Implementation
A spanning tree contains exactly `|V|-1` edges, there is no cycle in the spanning tree and it connects all the vertices.

The program works as follows:
* Input is read (functions of `input2.pl` are used) and parsed. The lines which don't follow the expected structure are omitted. Duplicates are eliminated.
* The graph is checked to be connected. If it is not, the program doesn't continue.
* All the possible combinations of existing edges of size `|V|-1` are generated with no duplicates.
* The combinations are filtered by two criteria:
	* They contain all the vertices.
	* There is no cycle in the spanning tree. The program checks for all the vertices if there exists a path from the vertice to the same one vertice, given the edges already visited.
* The final spanning trees are written to the output in the desired format.

## Build
- `make` command
- compiled with `swipl`
- binary called `flp21-log` is created in the root directory

## Run
- `./flp21-fun < input_file`

## Files
```
.   
├─ README.md
├─ flp21-log.pl
├─ test
│   ├─ test1.in
│   ├─ test1.out
│   ├─ ...
│   ├─ test11.in
│   └─ test11.out
└─ Makefile
```

## Makefile options
- `default`: compiles the program, creates a binary in the root directory
- `zip`: creates a zip file ready for uploading
- `clear`: deletes all the files created during a compilation
- `run`: runs the program with the input file test/test1.in

## Testing
`Test` folder contains examples of graphs with expected spanning trees.
- name.in = input
- name.out = expected output

| Filename      | Runtime [s]   |
| ------------- | ------------- |
| test1.in      | 0.023         |
| test2.in      | 0.021         |
| test3.in      | 0.021         |
| test4.in      | 0.019         |
| test5.in      | 0.020         |
| test6.in      | 0.024         |
| test7.in      | 0.023         |
| test8.in      | 0.020         |
| test9.in      | 0.020         |
| test10.in     | 0.019         |
| test11.in     | 0.020         |
