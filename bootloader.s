#no matter if you have a 32 or 64 bit x86 processor, at boot time the processor will run in the 16 bit real mode
.code16 #  tell the assembler that we're using 16 bit mode

.global init # makes our label "init" available to the outside

#we will load the address of our string (msg) into the special register si which allows us to use the convenient lodsb instruction that loads a byte from the address that si points to into al and #increments the address in si at the same time.

init: # this is the starting point
  mov $msg, %si # loads the address of msg (label) into si
  mov $0xe, %ah # select function teletype by setting ah to 0x0e(teletype prints a character given in al and automatically advances the cursor.)

#This is a loop that goes through the string untill we hit a zero-byte (which is right after the last character of our message).It loads the byte from the address in si into al and increments si,prints it #by calling teletype function.
print_char:
  lodsb # loads the byte from the address in si into al and increments si
  cmp $0, %al # compares content in AL with zero
  je done # if al == 0, go to "done"(it means we have printet all the srting and reached the end)
  int $0x10 # prints the character in al to screen(calling the teletype function to print the ASCII code in al)
  jmp print_char # repeat with next byte(it starts from print_char,prints chars one by one and continues until al==0)

#This label is called when the code reaches the end of the string and 0 is in al.
done:
  hlt # stop execution

#To get a full message to display, we will need a way to store this information in our binary.(.asciz) do this for strings.
#Also we use "msg" label to give us access to the address.
msg: .asciz "Hello world!bahar boroomand"


#In .fill first we say how many times we need to put a zero into our binary, Then we say we want a single byte and finally what value that byte should have (zero).
#We need a total number of 510 bytes so we will fill 510 - (byte size of our code) bytes with zeroes.we get size of our code by (.-init).(here - init)
.fill 510-(.-init), 1, 0 # add zeroes to make it 510 bytes long

#magic bytes are 0x55aa,but we write 0xaa55 because x86 is little endian, so the bytes get swapped in memory.
.word 0xaa55 # magic bytes that tell BIOS that this is bootable
