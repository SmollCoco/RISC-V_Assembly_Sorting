    .data
#===========================================================
# Data Section - Array and constants
#===========================================================
# Test array of color values
    arr:
    .word     0x000099FF               # Color values in format 0xAARRGGBB
    .word     0x0099FFFF
    .word     0x000000DD
    .word     0x0011FFFF
    .word     0x0055FFFF
    .word     0x00DDFFFF
    .word     0x000011FF
    .word     0x0000DDFF
    .word     0x00000055
    .word     0x00000099
    .word     0x000055FF

# Backup copy of original array for resets
    arr_backup:
    .word     0x000099FF
    .word     0x0099FFFF
    .word     0x000000DD
    .word     0x0011FFFF
    .word     0x0055FFFF
    .word     0x00DDFFFF
    .word     0x000011FF
    .word     0x0000DDFF
    .word     0x00000055
    .word     0x00000099
    .word     0x000055FF

# Array size
    arr_size:
    .word     11

# String constants
    newline:
    .asciiz   "\n"
    count_msg:
    .asciiz   "Instructions executed: "
    compare_msg:
    .asciiz   "Comparison of instruction counts for sorting algorithms:"
    bubble_label:
    .asciiz   "Bubble Sort: "
    selection_label:
    .asciiz   "Selection Sort: "
    insertion_label:
    .asciiz   "Insertion Sort: "
    quick_label:
    .asciiz   "Quick Sort: "
    shuffle_msg:
    .asciiz   "Shuffling array...\n"

# Performance counters
    instruction_count:
    .word     0                        # Current algorithm instruction counter
    bubble_count:
    .word     0                        # Bubble sort instruction count
    selection_count:
    .word     0                        # Selection sort instruction count
    insertion_count:
    .word     0                        # Insertion sort instruction count
    quick_count:
    .word     0                        # Quick sort instruction count

# Random seed for shuffling
    seed:
    .word     12345

    .text
    .globl    main
    .globl    bubble_sort
    .globl    selection_sort
    .globl    insertion_sort
    .globl    quickSort
    .globl    partition
    .globl    shuffle_array

#===========================================================
# Main function - Entry point of the program
#===========================================================
    main:
# Initialize LED Matrix
    li        a0, 0x100                # Start LED Matrix
    ecall

# Display original array
    jal       ra, display_original_array

# Shuffle and test bubble sort
    jal       ra, run_bubble_sort_test

# Shuffle and test selection sort
    jal       ra, run_selection_sort_test

# Shuffle and test insertion sort
    jal       ra, run_insertion_sort_test

# Shuffle and test quicksort
    jal       ra, run_quicksort_test

# Display comparison of all algorithms
    jal       ra, display_sort_comparison

# Exit the program
    li        a0, 10                   # Exit
    ecall

#===========================================================
# Test runner functions to modularize main
#===========================================================
    display_original_array:
# Save return address
    addi      sp, sp, -4
    sw        ra, 0(sp)

# Display the original array first
    jal       ra, display_array        # Display original array

# Add a short delay before shuffling
    li        a3, 1000                 # Longer delay for visibility
    jal       ra, delay                # Pause to see original array

# Restore return address and return
    lw        ra, 0(sp)
    addi      sp, sp, 4
    ret

#-------------------------------------------------------
    run_bubble_sort_test:
# Save return address
    addi      sp, sp, -4
    sw        ra, 0(sp)

# Shuffle the array
    jal       ra, shuffle_array        # Shuffle array with visualization

# Add a delay after shuffling
    li        a3, 1000                 # Longer delay for visibility
    jal       ra, delay                # Pause to see shuffled array

# Reset instruction counter
    la        t0, instruction_count
    sw        zero, 0(t0)              # Reset counter to 0

# Run bubble sort
    jal       ra, bubble_sort          # Bubble sort and show the sorting process

# Store and display bubble sort instruction count
    la        t0, instruction_count
    lw        t1, 0(t0)                # Get instruction count
    la        t0, bubble_count
    sw        t1, 0(t0)                # Store in bubble_count

# Display bubble sort instruction count
    li        a0, 4                    # Print string ecall
    la        a1, count_msg            # Load message string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, bubble_count         # Load instruction count
    ecall

    li        a0, 4                    # Print newline ecall
    la        a1, newline
    ecall

# Restore return address and return
    lw        ra, 0(sp)
    addi      sp, sp, 4
    ret

#-------------------------------------------------------
    run_selection_sort_test:
# Save return address
    addi      sp, sp, -4
    sw        ra, 0(sp)

# Shuffle the array
    jal       ra, shuffle_array        # Shuffle array with visualization

# Display shuffled array
    jal       ra, display_array        # Display shuffled array

# Reset instruction counter
    la        t0, instruction_count
    sw        zero, 0(t0)              # Reset counter to 0

# Run selection sort
    jal       ra, selection_sort       # Selection sort and show the sorting process

# Store and display selection sort instruction count
    la        t0, instruction_count
    lw        t1, 0(t0)                # Get instruction count
    la        t0, selection_count
    sw        t1, 0(t0)                # Store in selection_count

# Display selection sort instruction count
    li        a0, 4                    # Print string ecall
    la        a1, count_msg            # Load message string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, selection_count      # Load instruction count
    ecall

    li        a0, 4                    # Print newline ecall
    la        a1, newline
    ecall

# Restore return address and return
    lw        ra, 0(sp)
    addi      sp, sp, 4
    ret

#-------------------------------------------------------
    run_insertion_sort_test:
# Save return address
    addi      sp, sp, -4
    sw        ra, 0(sp)

# Reset array and display
    jal       ra, reset_array          # Reset array to original values
    jal       ra, shuffle_array        # Shuffle array
    jal       ra, display_array        # Display shuffled array

# Reset instruction counter
    la        t0, instruction_count
    sw        zero, 0(t0)              # Reset counter to 0

# Run insertion sort
    jal       ra, insertion_sort       # Insertion sort and show the sorting process

# Store and display insertion sort instruction count
    la        t0, instruction_count
    lw        t1, 0(t0)                # Get instruction count
    la        t0, insertion_count
    sw        t1, 0(t0)                # Store in insertion_count

# Display insertion sort instruction count
    li        a0, 4                    # Print string ecall
    la        a1, count_msg            # Load message string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, insertion_count      # Load instruction count
    ecall

    li        a0, 4                    # Print newline ecall
    la        a1, newline
    ecall

# Restore return address and return
    lw        ra, 0(sp)
    addi      sp, sp, 4
    ret

#-------------------------------------------------------
    run_quicksort_test:
# Save return address
    addi      sp, sp, -4
    sw        ra, 0(sp)

# Reset array and display
    jal       ra, reset_array          # Reset array to original values
    jal       ra, shuffle_array        # Shuffle array
    jal       ra, display_array        # Display shuffled array

# Reset instruction counter
    la        t0, instruction_count
    sw        zero, 0(t0)              # Reset counter to 0

# Run quick sort
    la        a0, arr                  # Load array address
    li        a1, 0                    # Low index
    lw        a2, arr_size             # High index
    addi      a2, a2, -1               # Adjust high index for 0-based array
    jal       ra, quickSort            # Call quickSort

# Store and display quick sort instruction count
    la        t0, instruction_count
    lw        t1, 0(t0)                # Get instruction count
    la        t0, quick_count
    sw        t1, 0(t0)                # Store in quick_count

# Display quick sort instruction count
    li        a0, 4                    # Print string ecall
    la        a1, count_msg            # Load message string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, quick_count          # Load instruction count
    ecall

    li        a0, 4                    # Print newline ecall
    la        a1, newline
    ecall

# Restore return address and return
    lw        ra, 0(sp)
    addi      sp, sp, 4
    ret

#-------------------------------------------------------
    display_sort_comparison:
# Save return address
    addi      sp, sp, -4
    sw        ra, 0(sp)

# Add newlines for readability
    li        a0, 4                    # Print string ecall
    la        a1, newline              # Load newline
    ecall

    li        a0, 4                    # Print string ecall
    la        a1, newline              # Load newline
    ecall

# Display comparison header
    la        a1, compare_msg          # Load comparison message
    li        a0, 4                    # Print string
    ecall

    li        a0, 4                    # Print string ecall
    la        a1, newline              # Load newline
    ecall

# Display bubble sort count
    la        a1, bubble_label         # Load bubble sort label
    li        a0, 4                    # Print string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, bubble_count         # Load bubble sort count
    ecall

    li        a0, 4                    # Print string ecall
    la        a1, newline              # Load newline
    ecall

# Display selection sort count
    la        a1, selection_label      # Load selection sort label
    li        a0, 4                    # Print string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, selection_count      # Load selection sort count
    ecall

    li        a0, 4                    # Print string ecall
    la        a1, newline              # Load newline
    ecall

# Display insertion sort count
    la        a1, insertion_label      # Load insertion sort label
    li        a0, 4                    # Print string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, insertion_count      # Load insertion sort count
    ecall

    li        a0, 4                    # Print string ecall
    la        a1, newline              # Load newline
    ecall

# Display quicksort count
    la        a1, quick_label          # Load quicksort label
    li        a0, 4                    # Print string
    ecall

    li        a0, 1                    # Print integer ecall
    lw        a1, quick_count          # Load quick sort count
    ecall

    li        a0, 4                    # Print string ecall
    la        a1, newline              # Load newline
    ecall

# Restore return address and return
    lw        ra, 0(sp)
    addi      sp, sp, 4
    ret

#===========================================================
# Bubble Sort Implementation
#===========================================================
    bubble_sort:
# Initialize variables
    la        t0, arr                  # Load array address
    lw        t1, arr_size             # Load array size
    addi      t1, t1, -1               # t1 = arr_size - 1 (maximum index for outer loop)

    li        t2, 0                    # i = 0
    bubble_sort_outer_loop:
# Increment instruction counter
    la        s7, instruction_count
    lw        s8, 0(s7)
    addi      s8, s8, 1
    sw        s8, 0(s7)

    bge       t2, t1, bubble_sort_exit_outer_loop
    li        t5, 0                    # swapped = false (optimization for early exit)

# Inner loop iterates from 0 to (n-i-1)
    li        t3, 0                    # j = 0
    sub       t4, t1, t2               # t4 = (arr_size - 1) - i (max index for inner loop)
    bubble_sort_inner_loop:
# Increment instruction counter
    la        s7, instruction_count
    lw        s8, 0(s7)
    addi      s8, s8, 1
    sw        s8, 0(s7)

    bge       t3, t4, bubble_sort_exit_inner_loop

# Calculate address of arr[j] and arr[j+1]
    slli      t6, t3, 2                # t6 = j * 4 (byte offset)
    add       s2, t0, t6               # s2 = &arr[j]
    lw        s0, 0(s2)                # s0 = arr[j]
    lw        s1, 4(s2)                # s1 = arr[j+1]

# Calculate position for LED display
    slli      s3, t3, 16               # Position for arr[j]
    li        s5, 0x10000
    add       s4, s3, s5               # Position for arr[j+1]

# If arr[j] <= arr[j+1], no swap needed
    ble       s0, s1, bubble_sort_no_swap

# Swap arr[j] and arr[j+1]
    sw        s1, 0(s2)                # arr[j] = arr[j+1]
    sw        s0, 4(s2)                # arr[j+1] = arr[j]
    li        t5, 1                    # swapped = true

# Display the swapped elements on the LED matrix
    li        a0, 0x100                # LED matrix ecall
    mv        a1, s3                   # Position for arr[j]
    lw        a2, 0(s2)                # Value at arr[j] (after swap)
    ecall

    li        a0, 0x100                # LED matrix ecall
    mv        a1, s4                   # Position for arr[j+1]
    lw        a2, 4(s2)                # Value at arr[j+1] (after swap)
    ecall

# Add delay to visualize the swap
    li        a3, 400
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

    bubble_sort_no_swap:
    addi      t3, t3, 1                # j++
    j         bubble_sort_inner_loop

    bubble_sort_exit_inner_loop:
    beq       t5, zero, bubble_sort_exit_outer_loop # Early exit optimization: if no swaps, array is sorted
    addi      t2, t2, 1                # i++
    j         bubble_sort_outer_loop

    bubble_sort_exit_outer_loop:
    ret

#===========================================================
# Selection Sort Implementation
#===========================================================
    selection_sort:
# Initialize variables
    la        t0, arr                  # Load array address
    lw        t1, arr_size             # Load array size
    addi      t1, t1, -1               # t1 = arr_size - 1 (maximum index for outer loop)

    li        t2, 0                    # i = 0
    selection_sort_outer_loop:
# Increment instruction counter
    la        s7, instruction_count
    lw        s8, 0(s7)
    addi      s8, s8, 1
    sw        s8, 0(s7)

    bge       t2, t1, selection_sort_exit_outer_loop

    mv        t4, t2                   # min_index = i (assume minimum is at current position)

# Inner loop looks for minimum element
    addi      t3, t2, 1                # j = i + 1
    selection_sort_inner_loop:
# Increment instruction counter
    la        s7, instruction_count
    lw        s8, 0(s7)
    addi      s8, s8, 1
    sw        s8, 0(s7)

# Add small delay for visualization
    li        a3, 200                  # Delay for LED display
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

    lw        t1, arr_size             # Load array size
    bge       t3, t1, selection_sort_exit_inner_loop # if j >= arr_size, exit inner loop

# Calculate addresses and load values
    slli      t5, t3, 2                # t5 = j * 4 (byte offset)
    add       t6, t0, t5               # t6 = &arr[j]
    lw        s1, 0(t6)                # s1 = arr[j]

    slli      t6, t4, 2                # t6 = min_index * 4
    add       t6, t0, t6               # t6 = &arr[min_index]
    lw        s2, 0(t6)                # s2 = arr[min_index]

# Compare arr[j] and arr[min_index]
    bge       s1, s2, selection_sort_no_update # if arr[j] >= arr[min_index], skip update

# Update minimum index
    mv        t4, t3                   # min_index = j

    selection_sort_no_update:
    addi      t3, t3, 1                # j++
    j         selection_sort_inner_loop

    selection_sort_exit_inner_loop:
# Swap arr[i] and arr[min_index] if needed
    beq       t2, t4, selection_sort_no_swap # If i == min_index, no swap needed

# Calculate addresses and load values for swap
    slli      t6, t2, 2                # t6 = i * 4 (byte offset)
    add       s2, t0, t6               # s2 = &arr[i]
    lw        s0, 0(s2)                # s0 = arr[i]

    slli      t6, t4, 2                # t6 = min_index * 4 (byte offset)
    add       s3, t0, t6               # s3 = &arr[min_index]
    lw        s1, 0(s3)                # s1 = arr[min_index]

# Calculate positions for LED display
    slli      s4, t2, 16               # Position for arr[i]
    slli      s5, t4, 16               # Position for arr[min_index]

# Perform swap
    sw        s1, 0(s2)                # arr[i] = arr[min_index]
    sw        s0, 0(s3)                # arr[min_index] = arr[i]

# Display the swapped elements on the LED matrix
    li        a0, 0x100                # LED matrix ecall
    mv        a1, s4                   # Position for arr[i]
    lw        a2, 0(s2)                # Value at arr[i] (after swap)
    ecall

    li        a0, 0x100                # LED matrix ecall
    mv        a1, s5                   # Position for arr[min_index]
    lw        a2, 0(s3)                # Value at arr[min_index] (after swap)
    ecall

    selection_sort_no_swap:
    addi      t2, t2, 1                # i++
    j         selection_sort_outer_loop

    selection_sort_exit_outer_loop:
    ret

#===========================================================
# Insertion Sort Implementation
#===========================================================
    insertion_sort:
# Initialize variables
    la        t0, arr                  # Load array address
    lw        t1, arr_size             # Load array size

    li        t2, 1                    # i = 1 (start at second element)
    insertion_sort_outer_loop:
# Increment instruction counter
    la        s7, instruction_count
    lw        s8, 0(s7)
    addi      s8, s8, 1
    sw        s8, 0(s7)

    bge       t2, t1, insertion_sort_exit_outer_loop

# Get current element (key) to be inserted into sorted portion
    slli      t3, t2, 2                # t3 = i * 4 (byte offset)
    add       t4, t0, t3               # t4 = &arr[i]
    lw        s0, 0(t4)                # s0 = arr[i] (key)
    slli      s7, t2, 16               # s7 = LED position for i

    mv        t5, t2                   # j = i

    insertion_sort_inner_loop:
# Increment instruction counter
    la        s9, instruction_count
    lw        s10, 0(s9)
    addi      s10, s10, 1
    sw        s10, 0(s9)

    beqz      t5, insertion_sort_exit_inner_loop # if j == 0, exit inner loop

# Compare key with previous element
    addi      t6, t5, -1               # t6 = j - 1
    slli      t3, t6, 2                # t3 = (j - 1) * 4 (byte offset)
    add       t4, t0, t3               # t4 = &arr[j - 1]
    lw        s1, 0(t4)                # s1 = arr[j - 1]

    ble       s1, s0, insertion_sort_exit_inner_loop # if arr[j - 1] <= key, exit inner loop

# Calculate positions for LED display
    slli      s3, t5, 16               # s3 = LED position for j
    slli      s4, t6, 16               # s4 = LED position for j-1

# Move arr[j-1] to arr[j]
    slli      s5, t5, 2                # s5 = j * 4 (byte offset)
    add       s6, t0, s5               # s6 = &arr[j]
    sw        s1, 0(s6)                # arr[j] = arr[j-1]

# Display the moved element on LED
    li        a0, 0x100                # LED matrix ecall
    mv        a1, s3                   # Position for arr[j]
    mv        a2, s1                   # Value of arr[j-1] moved to j
    ecall

# Add delay to visualize the movement
    li        a3, 400
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

    addi      t5, t5, -1               # j--
    j         insertion_sort_inner_loop

    insertion_sort_exit_inner_loop:
# Insert key at the correct position
    slli      s5, t5, 2                # s5 = j * 4 (byte offset)
    add       s6, t0, s5               # s6 = &arr[j]
    sw        s0, 0(s6)                # arr[j] = key

# Calculate position for LED display
    slli      s3, t5, 16               # s3 = LED position for j

# Display the inserted key
    li        a0, 0x100                # LED matrix ecall
    mv        a1, s3                   # Position for arr[j]
    mv        a2, s0                   # Value of key
    ecall

# Add delay to visualize the insertion
    li        a3, 500
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

    addi      t2, t2, 1                # i++
    j         insertion_sort_outer_loop

    insertion_sort_exit_outer_loop:
    ret

#===========================================================
# Quicksort Implementation
#===========================================================
    partition:
# a0 = array address
# a1 = low index
# a2 = high index
# Returns: a0 = pivot index

# Save registers
    addi      sp, sp, -28              # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    sw        s0, 4(sp)                # Save s0 (array address)
    sw        s1, 8(sp)                # Save s1 (low)
    sw        s2, 12(sp)               # Save s2 (high)
    sw        s3, 16(sp)               # Save s3 (pivot value)
    sw        s4, 20(sp)               # Save s4 (i)
    sw        s5, 24(sp)               # Save s5 (j)

# Increment instruction counter
    la        s6, instruction_count
    lw        s7, 0(s6)
    addi      s7, s7, 1
    sw        s7, 0(s6)

# Initialize registers
    mv        s0, a0                   # s0 = array address
    mv        s1, a1                   # s1 = low
    mv        s2, a2                   # s2 = high

# Get pivot value (arr[high])
    slli      t0, s2, 2                # t0 = high * 4 (byte offset)
    add       t0, s0, t0               # t0 = &arr[high]
    lw        s3, 0(t0)                # s3 = arr[high] (pivot)

    addi      s4, s1, -1               # i = low - 1
    mv        s5, s1                   # j = low

    partition_loop:
# Increment instruction counter
    la        s6, instruction_count
    lw        s7, 0(s6)
    addi      s7, s7, 1
    sw        s7, 0(s6)

    bge       s5, s2, partition_loop_end # if j >= high, exit loop

# Load arr[j]
    slli      t0, s5, 2                # t0 = j * 4 (byte offset)
    add       t0, s0, t0               # t0 = &arr[j]
    lw        t1, 0(t0)                # t1 = arr[j]

# If arr[j] >= pivot, skip swap
    bge       t1, s3, partition_no_swap

# Increment i
    addi      s4, s4, 1                # i++

# Calculate positions for LED display
    slli      t2, s4, 16               # Position for arr[i]
    slli      t3, s5, 16               # Position for arr[j]

# Swap arr[i] and arr[j]
    slli      t0, s4, 2                # t0 = i * 4 (byte offset)
    add       t0, s0, t0               # t0 = &arr[i]
    lw        t4, 0(t0)                # t4 = arr[i]

    slli      t1, s5, 2                # t1 = j * 4 (byte offset)
    add       t1, s0, t1               # t1 = &arr[j]
    lw        t5, 0(t1)                # t5 = arr[j]

# Perform swap
    sw        t5, 0(t0)                # arr[i] = arr[j]
    sw        t4, 0(t1)                # arr[j] = arr[i]

# Display the swapped elements on the LED matrix
    li        a0, 0x100                # LED matrix ecall
    mv        a1, t2                   # Position for arr[i]
    lw        a2, 0(t0)                # Value at arr[i] (after swap)
    ecall

    li        a0, 0x100                # LED matrix ecall
    mv        a1, t3                   # Position for arr[j]
    lw        a2, 0(t1)                # Value at arr[j] (after swap)
    ecall

# Add delay to visualize the swap
    li        a3, 300
    jal       ra, delay

    partition_no_swap:
    addi      s5, s5, 1                # j++
    j         partition_loop

    partition_loop_end:
# Swap arr[i+1] and arr[high] (place pivot in correct position)
    addi      s4, s4, 1                # i = i + 1

# Calculate positions for LED display
    slli      t2, s4, 16               # Position for arr[i+1]
    slli      t3, s2, 16               # Position for arr[high]

# Prepare for swap
    slli      t0, s4, 2                # t0 = (i+1) * 4 (byte offset)
    add       t0, s0, t0               # t0 = &arr[i+1]
    lw        t4, 0(t0)                # t4 = arr[i+1]

    slli      t1, s2, 2                # t1 = high * 4 (byte offset)
    add       t1, s0, t1               # t1 = &arr[high]
    lw        t5, 0(t1)                # t5 = arr[high]

# Perform final swap
    sw        t5, 0(t0)                # arr[i+1] = arr[high]
    sw        t4, 0(t1)                # arr[high] = arr[i+1]

# Display the swapped elements on the LED matrix
    li        a0, 0x100                # LED matrix ecall
    mv        a1, t2                   # Position for arr[i+1]
    lw        a2, 0(t0)                # Value at arr[i+1] (after swap)
    ecall

    li        a0, 0x100                # LED matrix ecall
    mv        a1, t3                   # Position for arr[high]
    lw        a2, 0(t1)                # Value at arr[high] (after swap)
    ecall

# Add delay to visualize the final swap
    li        a3, 500
    jal       ra, delay

# Prepare return value
    mv        a0, s4                   # return i+1 (pivot position)

# Restore registers
    lw        ra, 0(sp)                # Restore return address
    lw        s0, 4(sp)                # Restore s0
    lw        s1, 8(sp)                # Restore s1
    lw        s2, 12(sp)               # Restore s2
    lw        s3, 16(sp)               # Restore s3
    lw        s4, 20(sp)               # Restore s4
    lw        s5, 24(sp)               # Restore s5
    addi      sp, sp, 28               # Deallocate stack space

    ret

    quickSort:
# a0 = array address
# a1 = low index
# a2 = high index

# Increment instruction counter
    la        t3, instruction_count
    lw        t4, 0(t3)
    addi      t4, t4, 1
    sw        t4, 0(t3)

# First check if low < high, otherwise return
    bge       a1, a2, quickSort_return

# Save registers that need to be preserved
    addi      sp, sp, -20              # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    sw        s0, 4(sp)                # Save s0 (array address)
    sw        s1, 8(sp)                # Save s1 (low)
    sw        s2, 12(sp)               # Save s2 (high)
    sw        s3, 16(sp)               # Save s3 (pivot index)

# Save arguments to preserved registers
    mv        s0, a0                   # s0 = array address
    mv        s1, a1                   # s1 = low
    mv        s2, a2                   # s2 = high

# Call partition(arr, low, high)
# a0 is already set to array address
# a1 is already set to low
# a2 is already set to high
    jal       ra, partition            # Call partition, result in a0
    mv        s3, a0                   # s3 = pivot index (pi)

# First recursive call: quickSort(arr, low, pi-1)
    mv        a0, s0                   # a0 = array address
    mv        a1, s1                   # a1 = low
    addi      a2, s3, -1               # a2 = pi - 1
    jal       ra, quickSort            # Recursive call

# Second recursive call: quickSort(arr, pi+1, high)
    mv        a0, s0                   # a0 = array address
    addi      a1, s3, 1                # a1 = pi + 1
    mv        a2, s2                   # a2 = high
    jal       ra, quickSort            # Recursive call

# Restore saved registers
    lw        ra, 0(sp)                # Restore return address
    lw        s0, 4(sp)                # Restore s0
    lw        s1, 8(sp)                # Restore s1
    lw        s2, 12(sp)               # Restore s2
    lw        s3, 16(sp)               # Restore s3
    addi      sp, sp, 20               # Deallocate stack space

    quickSort_return:
    ret

#===========================================================
# Helper Functions
#===========================================================
# Display array on LED matrix
    display_array:
    la        t0, arr                  # Load array address
    lw        t1, arr_size             # Load array size
    li        t2, 0                    # i = 0
    li        t5, 0                    # Starting position for LED

    display_loop:
    bge       t2, t1, exit_display_loop

# Get array element
    slli      t3, t2, 2                # offset = i * 4
    add       t4, t0, t3               # t4 = &arr[i]

# Draw on LED matrix
    li        a0, 0x100                # LED matrix ecall
    mv        a1, t5                   # position
    lw        a2, 0(t4)                # Load color value from array
    ecall

# Delay for visualization
    li        a3, 400
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Increment index and position
    addi      t2, t2, 1                # i++
    li        t6, 0x00010000           # Position increment (move right)
    add       t5, t5, t6
    j         display_loop

    exit_display_loop:
    ret

#===========================================================
# Delay function using a loop
# a3: number of iterations to loop (controls delay duration)
#===========================================================
    delay:
    addi      a3, a3, -1
    bne       a3, zero, delay
    ret

#===========================================================
# Reset array function - restores original array values from backup
#===========================================================
    reset_array:
# First set all LEDs to black
    la        t0, arr                  # Load array address
    lw        t2, arr_size             # Load array size
    li        t3, 0                    # i = 0

    clear_leds_loop:
    bge       t3, t2, exit_clear_leds_loop

# Calculate LED position
    slli      t5, t3, 16               # Position for LED i

# Set LED to black
    li        a0, 0x100                # LED matrix ecall
    mv        a1, t5                   # Position
    li        a2, 0x0                  # Black color
    ecall

# Add a small delay
    li        a3, 75
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

    addi      t3, t3, 1                # i++
    j         clear_leds_loop

    exit_clear_leds_loop:
# Now restore array values from backup
    la        t0, arr                  # Load destination array address
    la        t1, arr_backup           # Load backup array address
    lw        t2, arr_size             # Load array size
    li        t3, 0                    # i = 0

    reset_loop:
    bge       t3, t2, exit_reset_loop

# Calculate offset and addresses
    slli      t4, t3, 2                # offset = i * 4
    add       t5, t1, t4               # t5 = &arr_backup[i]
    add       t6, t0, t4               # t6 = &arr[i]

# Copy value from backup to original array
    lw        s0, 0(t5)                # s0 = arr_backup[i]
    sw        s0, 0(t6)                # arr[i] = arr_backup[i]

    addi      t3, t3, 1                # i++
    j         reset_loop

    exit_reset_loop:
    ret

#===========================================================
# Shuffle Array Implementation (Fisher-Yates/Knuth Shuffle)
#===========================================================
    shuffle_array:
# Print shuffle message
    li        a0, 4                    # Print string ecall
    la        a1, shuffle_msg          # Load message
    ecall

    la        t0, arr                  # Load array address
    lw        t1, arr_size             # Load array size
    addi      t1, t1, -1               # t1 = arr_size - 1

# Initialize random seed
    la        t2, seed
    lw        t3, 0(t2)                # Load current seed

    li        t6, 0                    # i = 0
    shuffle_loop:
    bge       t6, t1, shuffle_exit     # If i >= arr_size - 1, exit

# Generate random index j such that i <= j < arr_size
# Simple LCG (Linear Congruential Generator) for pseudo-random number
    li        t4, 1664525              # LCG multiplier
    li        t5, 1013904223           # LCG increment
    mul       t3, t3, t4               # seed = seed * multiplier
    add       t3, t3, t5               # seed = seed + increment
    sw        t3, 0(t2)                # Store updated seed

# j = i + (random_value % (arr_size - i))
    sub       t4, t1, t6               # t4 = (arr_size - 1) - i
    addi      t4, t4, 1                # t4 = arr_size - i (range size)
    remu      t4, t3, t4               # t4 = seed % range_size
    add       t4, t6, t4               # t4 = i + (seed % range_size) = j

# Skip swap if i == j
    beq       t6, t4, shuffle_skip_swap

# Calculate positions for LED display
    slli      s1, t6, 16               # Position for arr[i]
    slli      s2, t4, 16               # Position for arr[j]

# Swap arr[i] and arr[j]
    slli      t5, t6, 2                # t5 = i * 4 (byte offset)
    add       s3, t0, t5               # s3 = &arr[i]
    lw        s5, 0(s3)                # s5 = arr[i]

    slli      t5, t4, 2                # t5 = j * 4 (byte offset)
    add       s4, t0, t5               # s4 = &arr[j]
    lw        s6, 0(s4)                # s6 = arr[j]

# Perform swap
    sw        s6, 0(s3)                # arr[i] = arr[j]
    sw        s5, 0(s4)                # arr[j] = arr[i]

# Display the swapped elements on the LED matrix
    li        a0, 0x100                # LED matrix ecall
    mv        a1, s1                   # Position for arr[i]
    lw        a2, 0(s3)                # Value at arr[i] (after swap)
    ecall

    li        a0, 0x100                # LED matrix ecall
    mv        a1, s2                   # Position for arr[j]
    lw        a2, 0(s4)                # Value at arr[j] (after swap)
    ecall

# Add delay to visualize the swap
    li        a3, 300
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

    shuffle_skip_swap:
    addi      t6, t6, 1                # i++
    j         shuffle_loop

    shuffle_exit:
    ret
