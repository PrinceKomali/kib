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
`` ` ``: Push compressed string  
`'`: Push string  
`*`: Pop stack twice and multiply/replicate  
`+`: Pop stack twice and add/concatenate  
`-`: Pop stack twice and subtract/remove  
`<`: Push compressed integer  
`?`: Pop stack twice; if first is truthy re-push the second  
`\`: Push single character string  
`^`: Pop stack twice and exponentiate  
`b`: Pop stack, index into builtins library and execute  
`c`: Pop stack and index into constants list  
`g`: Push input to stack  
`i`: Increment  
`j`: Pop array from stack and join without separator  
`p`: Pop stack and print without newline  
`P`: Pop stack and print with newline  
`s`: Square  
`t`: Test something  
`v`: Pop string and split, or pop array and spread out over stack    

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
(TODO: add more examples) 