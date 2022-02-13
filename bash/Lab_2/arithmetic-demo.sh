#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

echo "Enter first number : "
read firstNumber
echo "Enter second number : "
read secondNumber
echo "Enter third number : "
read thirdNumber
sum=$((firstNumber + secondNumber + thirdNumber))
product=$((firstNumber * secondNumber * thirdNumber))
echo "Sum of all three number is : $sum"
echo "Product of all three number is : $product"
