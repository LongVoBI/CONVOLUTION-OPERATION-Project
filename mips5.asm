.data

input_file: .asciiz "C:/Users/Admin/Downloads/Test_cases/Test_cases/test_10.txt"
output_file: .asciiz "C:/Users/Admin/Desktop/CA code/output/output_matrix10.txt"
error_msg: .asciiz "Error: size not match"
decimal_point: .asciiz "."
zero: .asciiz "0"

float_const: .float 10000.0   
zero_float: .float 0.0       


image: .word 0:49   
kernel: .word 0:16  
out: .word 0:100      
new_image: .word 0:100  

buffer: .space 1024  

float_buffer: .space 32  
temp_buffer: .space 32    

newline: .asciiz "\n"
space: .asciiz " "
minus_sign: .asciiz "-"    

N: .word 0  
M: .word 0  
p: .word 0  
s: .word 0 
output_size: .word 0   

new_image_size: .word 0   

.text
.globl main

main:
 li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 13          
    la $a0, input_file  
    li $a1, 0     
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3     
    li $a2, 0           
    syscall
    move $s0, $v0       
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

    li $v0, 14          
    move $a0, $s0       
    la $a1, buffer      
    li $a2, 1024       
    syscall
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 16         
    move $a0, $s0      
    syscall
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $a0, buffer
    jal extract_parameters
    jal analyze_size
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    jal process_image_matrix
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    jal interpret_kernel_matrix
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    jal get_new_image
    jal execute_convolution
      li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    
    jal write_output
    
    li $v0, 10
    syscall

extract_parameters:
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $sp, $sp, -4
    sw $ra, 0($sp)
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $s0, buffer      
    li $t0, 0          
    li $t1, 0         
    li $t2, 0    

handle_param_loop:
  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lb $t3, ($s0)
    
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    beq $t3, 32, evaluate_param_space  
    beq $t3, 10, evaluate_param_space  
    beq $t3, 0, evaluate_param_space 
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3   
    beq $t3, 13, evaluate_param_space  
    
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $t3, $t3, -48   
    mul $t2, $t2, 10     
    add $t2, $t2, $t3   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    j process_param_next

evaluate_param_space:
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    beq $t1, 0, save_N
    beq $t1, 1, save_M
    beq $t1, 2, save_p
    beq $t1, 3, save_s
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    j process_param_next

save_N:
    sw $t2, N
    j clear_number
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
save_M:
    sw $t2, M
    j clear_number
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
save_p:
    sw $t2, p
    j clear_number
save_s:
    sw $t2, s
    j clear_number
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

clear_number:
    li $t2, 0          
    addi $t1, $t1, 1    
    beq $t1, 4, finish_param_parse  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

process_param_next:
    addi $s0, $s0, 1   
    addi $t0, $t0, 1  
    j handle_param_loop
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

finish_param_parse:
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
	lw $s0, N       
	lw $s1, M       
	lw $s2, p       
	lw $s3, s      

	li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
	add $t0, $s0, $s2  
	add $t0, $t0, $s2  
	sub $t0, $t0, $s1   
    move $t9, $t0
	div $t0, $s3        
	mflo $t0           

	
	li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
	bltz $t9, fix_negative
	bltz $t0, fix_negative 
	
	li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
	addi $t0, $t0, 1    
	sw $t0, output_size
	j terminate

fix_negative:

addi $t0, $t0, -1   
sw $t0, output_size 
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

terminate:  
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

analyze_size:
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $t0, output_size
    bgtz $t0, size_check   
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 13
    la $a0, output_file
    li $a1, 1          
    li $a2, 0           
    syscall
    move $s0, $v0       
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
   
    li $v0, 15
    move $a0, $s0
    la $a1, error_msg
    li $a2, 21          
    syscall

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 16
    move $a0, $s0
    syscall

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 10         
    syscall

size_check:
    jr $ra            	

process_image_matrix:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $s0, buffer     
ignore_first_line:
    lb $t0, ($s0)
    beq $t0, 10, initialize_image_parse  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $s0, $s0, 1
    j ignore_first_line

initialize_image_parse:
    addi $s0, $s0, 1    
    li $t0, 0          
    li $t1, 0         
    li $t2, 0   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3       
    li $t3, 0          
    li $t4, 10        
    li $t6, 0         
    mtc1 $zero, $f0   
    
process_image_loop:
    lb $t5, ($s0)
    beq $t5, 32, save_image_value  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    beq $t5, 10, save_image_value  
    beq $t5, 0, save_image_value   
    beq $t5, 46, enable_decimal_flag 
    beq $t5, 45, initialize_negative_flag 
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3 
    beq $t5, 13, save_image_value  
    addi $t5, $t5, -48    
    beq $t3, 1, process_decimal
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    mul $t2, $t2, 10
    add $t2, $t2, $t5
    j advance_image_parsing

process_decimal:
    mtc1 $t5, $f2
    cvt.s.w $f2, $f2   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3  
    mtc1 $t4, $f4
    cvt.s.w $f4, $f4     
    div.s $f2, $f2, $f4  
    add.s $f0, $f0, $f2  
    mul $t4, $t4, 10   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3 
    j advance_image_parsing

enable_decimal_flag:
    li $t3, 1       
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3   
    mtc1 $t2, $f0     
    cvt.s.w $f0, $f0  
    li $t2, 0   
    j advance_image_parsing
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

initialize_negative_flag:
    li $t6, 1           
    j advance_image_parsing
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

save_image_value:
    beq $t3, 0, int_to_float_conversion
following_conversion:
    beq $t6, 1, transform_to_negative
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
post_negative:
    lw $t7, N           
    mul $t8, $t0, $t7   
    add $t8, $t8, $t1  
    sll $t8, $t8, 2   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $t7, image
    add $t7, $t7, $t8   
    li $t9, 3           
    not $t9, $t9        
    and $t7, $t7, $t9   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    s.s $f0, ($t7)      
    li $t2, 0           
    li $t3, 0           
    li $t4, 10         
    li $t6, 0          
    mtc1 $zero, $f0     
    
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $t1, $t1, 1   
    lw $t7, N         
    beq $t1, $t7, advance_image_row  
    j advance_image_parsing

advance_image_row:
    li $t1, 0           
    addi $t0, $t0, 1   
    lw $t7, N          
    beq $t0, $t7, parse_image_done  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

advance_image_parsing:
    addi $s0, $s0, 1   
    j process_image_loop
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

int_to_float_conversion:
    mtc1 $t2, $f0
    cvt.s.w $f0, $f0
    j following_conversion
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

transform_to_negative:
    neg.s $f0, $f0
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    j post_negative

parse_image_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
  
interpret_kernel_matrix:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $s0, buffer     
    li $t0, 0        
jump_to_kernel:
    lb $t1, ($s0)
    beq $t1, 10, count_line 
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $s0, $s0, 1
    j jump_to_kernel
count_line:
    addi $t0, $t0, 1
    beq $t0, 2, launch_kernel_parsing
    addi $s0, $s0, 1
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    j jump_to_kernel

launch_kernel_parsing:
    addi $s0, $s0, 1   
    li $t0, 0          
    li $t1, 0        
    li $t2, 0      
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3  
    li $t3, 0        
    li $t4, 10       
    mtc1 $zero, $f0   
    
process_kernel_loop:
    lb $t5, ($s0)
    
    beq $t5, 32, store_kernel_value  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    beq $t5, 10, store_kernel_value 
    beq $t5, 0, store_kernel_value  
    beq $t5, 46, initialize_kernel_flag 
    beq $t5, 45, enable_kernel_negative 
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $t5, $t5, -48   
    beq $t3, 1, handle_kernel_decimal
    
    mul $t2, $t2, 10
    add $t2, $t2, $t5
    j advance_kernel_parsing

handle_kernel_decimal:
    mtc1 $t5, $f2
    cvt.s.w $f2, $f2
    mtc1 $t4, $f4
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    cvt.s.w $f4, $f4
    div.s $f2, $f2, $f4
    add.s $f0, $f0, $f2
    mul $t4, $t4, 10
    j advance_kernel_parsing
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

initialize_kernel_flag:
    li $t3, 1
    mtc1 $t2, $f0
    cvt.s.w $f0, $f0
    li $t2, 0
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    j advance_kernel_parsing

enable_kernel_negative:
    li $t6, 1
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    j advance_kernel_parsing

store_kernel_value:
 li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    beq $t3, 0, convert_kernel_float
following_kernel_conv:
   
    beq $t6, 1, make_kernel_negative
post_kernel_negative:
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $t7, M          
    mul $t8, $t0, $t7 
    add $t8, $t8, $t1  
    sll $t8, $t8, 2   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $t7, kernel
    add $t7, $t7, $t8
    
    li $t9, 3           
    not $t9, $t9      
    and $t7, $t7, $t9  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    s.s $f0, ($t7)
    
    li $t2, 0           
    li $t3, 0    
    li $t4, 10       
    li $t6, 0     
    mtc1 $zero, $f0  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $t1, $t1, 1  
    lw $t7, M        
    beq $t1, $t7, next_kernel_row 
    j advance_kernel_parsing

next_kernel_row:
    li $t1, 0        
    addi $t0, $t0, 1 
    lw $t7, M       
    beq $t0, $t7, kernel_parsing_done 
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
advance_kernel_parsing:
    addi $s0, $s0, 1  
    j process_kernel_loop

convert_kernel_float:
    mtc1 $t2, $f0
    cvt.s.w $f0, $f0
    j following_kernel_conv
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
make_kernel_negative:
    neg.s $f0, $f0
    j post_kernel_negative

kernel_parsing_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3


get_new_image:
lw $s0, N      
lw $s1, p    
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
add $s2, $s0, $s1  
add $s2, $s2, $s1
sw $s2, new_image_size

li $s3, 0        
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
process_outer_cycle:
    beq $s3, $s0, finalize_padding  

    li $s4, 0       
inner_loop:
    beq $s4, $s0, next_row 

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    add $t0, $s3, $s1  
    add $t1, $s4, $s1 
 
    mul $t2, $t0, $s2  
    add $t2, $t2, $t1 
    sll $t2, $t2, 2  
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    
    mul $t3, $s3, $s0 
    add $t3, $t3, $s4 
    sll $t3, $t3, 2  
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $t4, image    
    add $t4, $t4, $t3  
    
    li $t9, 3        
    not $t9, $t9        
    and $t4, $t4, $t9  
    lw $t5, 0($t4)     
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3 
    la $t6, new_image  
    add $t6, $t6, $t2 
    
    li $t9, 3         
    not $t9, $t9      
    and $t6, $t6, $t9  
    sw $t5, 0($t6)     
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $s4, $s4, 1
    j inner_loop


next_row:
    addi $s3, $s3, 1
    j process_outer_cycle


finalize_padding:
execute_convolution:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    lw $s0, N      
    lw $s1, M  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3   
    lw $s2, p      
    lw $s3, s      
    
    add $t0, $s0, $s2  
    add $t0, $t0, $s2 
    sub $t0, $t0, $s1  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    div $t0, $s3       
    mflo $t0          
    addi $t0, $t0, 1   
    sw $t0, output_size 
    
    li $s0, 0         
    li $s1, 0        

convolution_process_outer_cycle:
    lw $t0, output_size
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    beq $s0, $t0, convolution_finished    

handle_conv_inner_loop:
    lw $t0, output_size
    beq $s1, $t0, next_conv_row   
    lw $t0, s
    mul $t1, $s0, $t0 
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3 
    mul $t2, $s1, $t0  
    
    mtc1 $zero, $f0    
    
    li $t3, 0         
kernel_row_loop:
    lw $t0, M
    beq $t3, $t0, store_conv_result
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $t4, 0        
kernel_col_loop:
    lw $t0, M
    beq $t4, $t0, advance_kernel_row_ptr

    add $t5, $t1, $t3  
    add $t6, $t2, $t4  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $t0, new_image_size
    mul $t7, $t5, $t0
    add $t7, $t7, $t6
    sll $t7, $t7, 2
    la $t8, new_image
    add $t8, $t8, $t7
    
    li $t9, 3          
    not $t9, $t9       
    and $t8, $t8, $t9  
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    l.s $f2, ($t8)   
    
    lw $t0, M
    mul $t7, $t3, $t0
    add $t7, $t7, $t4
    sll $t7, $t7, 2
    la $t8, kernel
    add $t8, $t8, $t7
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $t9, 3        
    not $t9, $t9     
    and $t8, $t8, $t9  
    l.s $f4, ($t8)     
    mul.s $f6, $f2, $f4
    add.s $f0, $f0, $f6
    
    addi $t4, $t4, 1    # Increment kernel column
    j kernel_col_loop

advance_kernel_row_ptr:
    addi $t3, $t3, 1    # Increment kernel row
    j kernel_row_loop

store_conv_result:
    # Calculate output position
    lw $t0, output_size
    mul $t1, $s0, $t0
    add $t1, $t1, $s1
    sll $t1, $t1, 2
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $t2, out
    add $t2, $t2, $t1
    
    li $t9, 3           # Create mask for alignment check
    not $t9, $t9        # Invert mask
    and $t2, $t2, $t9   # Align address to word boundary
    s.s $f0, ($t2)      # Store result
    addi $s1, $s1, 1    # Increment output column
    j handle_conv_inner_loop

next_conv_row:
    li $s1, 0           # Reset column
    addi $s0, $s0, 1    # Increment row
    j convolution_process_outer_cycle

convolution_finished:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

write_output:
  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)    # File descriptor
    sw $s1, 8($sp)    # Current row
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    sw $s2, 12($sp)   # Current column
    sw $s3, 16($sp)   # Output size

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 13
    la $a0, output_file
    li $a1, 1           # Flag for writing
    li $a2, 0           # Mode is ignored
    syscall
    move $s0, $v0       # Save file descriptor

    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $s1, 0          # Row counter
    li $s2, 0          # Column counter
    lw $s3, output_size # Load output matrix size

write_loop:
    beq $s1, $s3, write_done

    li $s2, 0          # Reset column counter
handle_column_loop:
    beq $s2, $s3, record_next_row

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    mul $t0, $s1, $s3
    add $t0, $t0, $s2
    sll $t0, $t0, 2
    
  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    la $t1, out
    add $t1, $t1, $t0
    l.s $f12, ($t1)    # Load float value

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    l.s $f1, float_const  # Load 10000.0 from memory
    mul.s $f2, $f12, $f1 # Multiply to get 4 decimal places
    cvt.w.s $f2, $f2    # Convert to integer
    mfc1 $t2, $f2      # Move to integer register

li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
li $t7, 10000      # Divisor for getting integer part
div $t2, $t7       # Divide by 10000
mflo $t3           # Integer part in $t3
mfhi $t4           # Decimal part in $t4

li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
bltz $t2, fix_decimal_part  # If original number was negative
j proceed_processing

fix_decimal_part:
    beqz $t4, proceed_processing  # If decimal part is 0, no need to fix
    neg $t4, $t4      # Make decimal part positive
    
proceed_processing:

li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
move $a0, $t3
la $a1, float_buffer
jal integer_to_string
  
    
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 15
    move $a0, $s0
    la $a1, float_buffer
    move $a2, $v1
    syscall

li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 15
    move $a0, $s0
    la $a1, decimal_point
    li $a2, 1
    syscall

li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    move $t5, $t4      # Save decimal part
    li $t6, 1000       # For checking leading zeros
    
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    div $t5, $t6
    mflo $t7           # Get first digit
    
    beqz $t7, add_zero1
after_zero1:
    li $t6, 100
    div $t5, $t6
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    mflo $t7
    beqz $t7, add_zero2
zero_correction_step2:
    li $t6, 10
    div $t5, $t6
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    mflo $t7
    beqz $t7, handle_zero3_addition
after_zero3:

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    move $a0, $t4
    la $a1, float_buffer
    jal integer_to_string
    
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 15
    move $a0, $s0
    la $a1, float_buffer
    move $a2, $v1
    syscall

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    mul $t0, $s3, $s3
    mul $t1, $s1, $s3
    add $t1, $t1, $s2
    addi $t1, $t1, 1
    beq $t1, $t0, skip_space
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 15
    move $a0, $s0
    la $a1, space
    li $a2, 1
    syscall
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3

skip_space:
    addi $s2, $s2, 1
    j handle_column_loop

record_next_row:
    addi $s1, $s1, 1
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    j write_loop

write_done:
  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 15
    move $a0, $s0
    la $a1, newline
    li $a2, 1
    syscall

  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $v0, 16
    move $a0, $s0
    syscall

    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

add_zero1:
    li $v0, 15
    move $a0, $s0
    la $a1, zero
    li $a2, 1
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    syscall
    j after_zero1

add_zero2:
    li $v0, 15
    move $a0, $s0
    la $a1, zero
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $a2, 1
    syscall
    j zero_correction_step2

handle_zero3_addition:
    li $v0, 15
    move $a0, $s0
    la $a1, zero
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    li $a2, 1
    syscall
    j after_zero3


integer_to_string:

    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    sw $s3, 16($sp)

    move $s0, $a0   
    move $s1, $a1  
    li $s2, 0       
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    bgez $s0, convert_digits
    li $t0, 45         # ASCII code for '-'
    sb $t0, ($s1)      # Store minus sign
    addi $s1, $s1, 1   # Move buffer pointer
    addi $s2, $s2, 1   # Increment length
    neg $s0, $s0       # Make number positive
li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
convert_digits:
    li $t0, 10         # Divisor
    move $t1, $s1      # Start of current number position

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
process_digit_iteration:
    div $s0, $t0  
    mfhi $t2  
    mflo $s0   
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $t2, $t2, 48  # Convert to ASCII
    sb $t2, ($t1)      # Store digit in buffer - �?Ã SỬA: dùng $t1 thay vì $t3
    addi $t1, $t1, 1   # Move to next position 
    addi $s2, $s2, 1   # Increment length
    
    bnez $s0, process_digit_iteration  # Continue if quotient is not zero

  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    sb $zero, ($t1)    

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    move $a0, $s1      # Start of digits
    sub $a1, $t1, 1    # terminate of string (before null)
    jal invert_string

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    move $v1, $s2

   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
invert_string:
    # $a0 = start address
reverse_loop:
    bge $a0, $a1, reverse_operation_done
    
  li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    lb $t0, ($a0)
    lb $t1, ($a1)
    sb $t1, ($a0)
    li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    sb $t0, ($a1)
    
   li $s6, 12 
and $s6, $s6, $zero 
ori $s6, $s6, 3
    addi $a0, $a0, 1
    subi $a1, $a1, 1
    j reverse_loop
    
reverse_operation_done:
    jr $ra

