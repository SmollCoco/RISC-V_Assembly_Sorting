# RISC-V Sorting Algorithm Visualizer

This repository contains a RISC-V assembly implementation of four classic sorting algorithms with visual representation on an LED matrix.

## Overview

The program demonstrates bubble sort, selection sort, insertion sort, and quicksort algorithms in RISC-V assembly language. Each algorithm is visualized on an LED matrix as it executes, allowing you to observe the sorting process in real-time.

## Features

-   **Visual Sorting**: Watch as the algorithms sort an array of color values on an LED matrix
-   **Performance Measurement**: Counts the number of instructions executed by each algorithm
-   **Algorithm Comparison**: Displays a side-by-side comparison of instruction counts
-   **Interactive Visualization**: Includes delays to clearly observe each step of the sorting process
-   **Fisher-Yates Shuffling**: Randomizes the array before each sort using a proper shuffling algorithm

## Algorithms Implemented

1. **Bubble Sort**: Simple comparison-based algorithm with early exit optimization
2. **Selection Sort**: Finds the minimum element and places it at the beginning
3. **Insertion Sort**: Builds a sorted array one element at a time
4. **Quick Sort**: Fast, recursive divide-and-conquer algorithm

## Running the Code

The code is designed to run in the Venus RISC-V simulator with LED Matrix visualization. The VS Code configuration is included to set up the simulator with the correct LED matrix size.

## Implementation Details

Each sorting algorithm includes:

-   Instruction counting for performance metrics
-   Visual representation of array elements and swaps on the LED matrix
-   Proper register management for function calls
-   Comments explaining the algorithm's operation

## Educational Purpose

This project serves as a learning tool for understanding:

-   Sorting algorithm behavior and performance
-   RISC-V assembly programming
-   Visual representation of algorithms in action
