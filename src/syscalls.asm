
SYS_WRITE equ 1
SYS_OPEN equ 2
SYS_CLOSE equ 3
SYS_FSTAT equ 5
SYS_MMAP equ 9
SYS_MUNMAP equ 11
SYS_EXIT equ 60

O_RDONLY equ 00

ST_STRUCT_SIZE equ 144
ST_SIZE equ 48

PROT_READ equ 0x1
MAP_PRIVATE equ 0x02
MAP_FAILED equ -1

STDOUT equ 1

macro sys_write fd*, buf*, len* {
  mov rax, SYS_WRITE
  mov rdi, fd
  mov rsi, buf
  mov rdx, len
  syscall
}

macro sys_exit code* {
  mov rax, SYS_EXIT
  mov rdi, code
  syscall
}

macro sys_open filename*, flags*, mode* {
  mov rax, SYS_OPEN
  mov rdi, filename
  mov rsi, flags
  mov rdx, mode
  syscall
}

macro sys_fstat fd*, stat_buf* {
  mov rax, SYS_FSTAT
  mov rdi, fd
  mov rsi, stat_buf
  syscall
}

macro sys_mmap addr*, len*, prot*, flags*, fildes*, off* {
  mov rax, SYS_MMAP
  mov rdi, addr
  mov rsi, len
  mov rdx, prot
  mov r10, flags
  mov r8, fildes
  mov r9, off
  syscall
}

