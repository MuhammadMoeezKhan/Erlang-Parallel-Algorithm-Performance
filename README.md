# Erlang's Parallel Algorithm Performance

The goal of this project is to investigate the impact of parallel programming and parallel execution on the performance of sorting algorithms. You will implement and test both a "slow" sorting algorithm with O(n^2) complexity and a "fast" sorting algorithm with O(n log n) complexity, comparing their performance in sequential and parallel modes. Additionally, you will analyze the effect of list size on sorting performance. The project requires the implementation of eight different sorting functions, four for each type of sorting algorithm.

## Technical Details:

### Selection of Sorting Algorithms:

"Slow" Sorting Algorithm (O(n^2)): You can choose from bubble sort, insertion sort, or selection sort.

"Fast" Sorting Algorithm (O(n log n)): You can choose from merge sort or quicksort.

Parallel Implementation:
For each selected sorting algorithm, you will create four versions of the sort, each with a different level of parallelism:

Sequential: A single-threaded version that runs without parallelism.

Parallel (2 processes): A version that employs two processes for parallel execution.

Parallel (4 processes): A version that uses four processes for parallel execution.

Parallel (8 processes): A version that utilizes eight processes for parallel execution.

### Testing Procedure:

For the "slow" sorting algorithm, test it on random lists of sizes: 5,000, 10,000, 25,000, 50,000, and 100,000.

For the "fast" sorting algorithm, test it on random lists of sizes: 100,000, 250,000, 500,000, 1,000,000, and 5,000,000.

Additionally, test the built-in Erlang function lists:sort on the same size lists as the "fast" sorting algorithm.
Test Repetition:

Run each test for each algorithm at least 5 times to account for variations in execution time.

Average the results for each algorithm to obtain reliable performance metrics.

### Data Recording:

Record the execution times for each test, ensuring that you capture the time taken for each version of the sorting algorithm.

### Test Environment:

Run the tests in as similar circumstances as possible to ensure fair comparisons.

Keep in mind that sorting larger lists may require additional time, and these factors should be considered in the analysis.

The project aims to provide insights into the performance characteristics of sorting algorithms under different levels of parallelism and for various list sizes. 

The results will help in understanding the practical implications of parallel programming on sorting efficiency.
