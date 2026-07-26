#!/usr/bin/env python3

# Imported modules
import sys
import random

# check if an argument is passed
if len(sys.argv) >= 2 :
    arg = int(sys.argv[1])
    auto = True
else :
    auto = False

# functions
def lorem_auto(length) :
    i = 0
    while i < length :
        print("[" + str(i) + "]" + " hello")
        i += 1
    print("Done")

def lorem_manual() :
        print("1")

if auto == True :
    lorem_auto(arg)
elif auto == False :
    lorem_manual()
else :
    print("The F*ck did you do?!")
    
print("end")
