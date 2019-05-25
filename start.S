	
.section ".text"

.global _start
.global main

### Main entry point

_start:
    ## Get CPU ID and disable all cores other than 0
    bl get_cpu_id

    cmp x0, 0

    beq .i_am_master_core

  .i_am_slave_core:
    wfe
    b .i_am_slave_core

  .i_am_master_core:

    # Create 1 MB of stack
	
    ldr x0, initial_stack

    mov x1, 1024 * 1024 - 8
    add x0, x0, x1

    mov sp, x0

    b main

### Auxiliary functions

get_cpu_id:
    mrs x0, mpidr_el1
    and x0, x0, 3
    ret

### Literal pool

    .align 3
initial_stack:
    .quad _initial_stack
