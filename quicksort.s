.text
    .globl    quickSort
    .globl    partition

#===========================================================
# Quick Sort Implementation
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

#===========================================================
# QuickSort recursive function
#===========================================================
    quickSort:
    # a0 = array address
    # a1 = low index
    # a2 = high index

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
