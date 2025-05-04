.text
    .globl    selection_sort

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
    bge       t2, t1, selection_sort_exit_outer_loop

    mv        t4, t2                   # min_index = i (assume minimum is at current position)

    # Inner loop looks for minimum element
    addi      t3, t2, 1                # j = i + 1
    selection_sort_inner_loop:
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
