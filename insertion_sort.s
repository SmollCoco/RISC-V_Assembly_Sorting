.text
    .globl    insertion_sort

#===========================================================
# Insertion Sort Implementation
#===========================================================
    insertion_sort:
    # Initialize variables
    la        t0, arr                  # Load array address
    lw        t1, arr_size             # Load array size

    li        t2, 1                    # i = 1 (start at second element)
    insertion_sort_outer_loop:
    bge       t2, t1, insertion_sort_exit_outer_loop

    # Get current element (key) to be inserted into sorted portion
    slli      t3, t2, 2                # t3 = i * 4 (byte offset)
    add       t4, t0, t3               # t4 = &arr[i]
    lw        s0, 0(t4)                # s0 = arr[i] (key)
    slli      s7, t2, 16               # s7 = LED position for i

    mv        t5, t2                   # j = i

    insertion_sort_inner_loop:
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
