    .data
# Include the other assembly files
    .   "bubble_sort.s"
    .   "selection_sort.s"
    .   "insertion_sort.s"
    .   "quicksort.s"

    arr:
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
    arr_backup:                        # Backup of original array values
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
    arr_size:
    .word     11
    newline:
    .asciiz   "\n"

    .text
    .globl    main
    main:
    li        a0, 0x100                # Start LED Matrix
    ecall

# Display original array
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, display_array        # Display array
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Run bubble sort
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, bubble_sort          # Bubble sort and show the sorting process
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Reset array and display
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, reset_array          # Reset array to original values
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, display_array        # Display original array
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Run selection sort
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, selection_sort       # Selection sort and show the sorting process
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Reset array and display
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, reset_array          # Reset array to original values
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, display_array        # Display original array
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Run insertion sort
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, insertion_sort       # Insertion sort and show the sorting process
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Reset array and display
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, reset_array          # Reset array to original values
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, display_array        # Display original array
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

# Run quick sort
    la        a0, arr                  # Load array address
    li        a1, 0                    # Low index
    lw        a2, arr_size             # High index
    addi      a2, a2, -1               # Adjust high index for 0-based array
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, quickSort            # Call quickSort
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space

    li        a0, 10                   # Exit
    ecall

#================ Helper Functions ==========================
#-------------------------------------------------------------
# Display array on LED matrix
    display_array:
    la        t0, arr
    lw        t1, arr_size
    li        t2, 0                    # i = 0
    li        t5, 0
    display_loop:
    bge       t2, t1, exit_display_loop
# Get array element
    slli      t3, t2, 2                # offset = i * 4
    add       t4, t0, t3               # t4 = &arr[i]
# Draw on LED matrix
    li        a0, 0x100                # LED matrix ecall
    mv        a1, t5                   # position
    lw        a2, 0(t4)                # t4 = arr[i]
    ecall
# Delay
    li        a3, 400
    addi      sp, sp, -4               # Allocate stack space
    sw        ra, 0(sp)                # Save return address
    jal       ra, delay
    lw        ra, 0(sp)                # Restore return address
    addi      sp, sp, 4                # Deallocate stack space
# Increment index
    addi      t2, t2, 1
    li        t6, 0x00010000
    add       t5, t5, t6
    j         display_loop
    exit_display_loop:
    ret

#-------------------------------------------------------------
# Delay function using a loop
# a3: number of iterations to loop (controls delay duration)
    delay:
    addi      a3, a3, -1
    bne       a3, zero, delay
    ret

#-------------------------------------------------------------
# Reset array function - restores original array values from backup
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
