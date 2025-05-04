.text
    .globl    bubble_sort

#===========================================================
# Bubble sort implementation
#===========================================================
    bubble_sort:
    # Initialize variables
    la        t0, arr                  # Load array address
    lw        t1, arr_size             # Load array size
    addi      t1, t1, -1               # t1 = arr_size - 1 (maximum index for outer loop)

    li        t2, 0                    # i = 0
    bubble_sort_outer_loop:
    bge       t2, t1, bubble_sort_exit_outer_loop
    li        t5, 0                    # swapped = false (optimization for early exit)

    # Inner loop iterates from 0 to (n-i-1)
    li        t3, 0                    # j = 0
    sub       t4, t1, t2               # t4 = (arr_size - 1) - i (max index for inner loop)
    bubble_sort_inner_loop:
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
