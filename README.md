# Kib
**K**omali **i**s **b**ored
An interpreted golfing language written in D

## Building
On Linux 
```
git clone https://github.com/PrinceKomali/kib
cd kib
make
```
## Current features
`0 - 9`: Push number 
`p`: Pop stack and print without newline 
`P`: Pop stack and print with newline 
`+`: Pop stack twice and add/concatenate  
`'`: Push string 
`<`: Push compressed integer 
`backtick`: Push compressed string 
`c`: Pop stack and index into constants list 

## Examples
```
0c
```
Prints "Hello, World!"
```
`
Y9-&.7Q)%2'L%8V-/4(A6b?*Y,$;1G%3`
`````
Print "the quick brown fox jumps over the lazy dog" 
