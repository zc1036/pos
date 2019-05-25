
SECTIONS {
    . = 0x80000;

    .text : {
        *(.text.boot)
        *(.text)
    }

    .rodata . : {
        *(.rodata*)
    }

    .data . : {
        *(EXCLUDE_FILE(*stack.o) .data*)
        stack.o (.data*)
    }
}
