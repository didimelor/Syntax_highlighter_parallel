# Syntax_highlighter_parallel
> Developed by Diana Melo, Miguel Medina and Emilio Sanchez

>June 4th 2021

## Code Description
This code recieves a directory input which contains json file and the number of core to split the processes in. For each json file, an html code is generated and with css the json syntax is highlighted with different colors for each valid component.

## Concurrency, Threads and Parallelism
A CPU has cores embeded, before in a CPU there was only one processing core. As technology has advanced, modern computers can now have many cores in a CPU. Cores can run processes at the same time. Parallelism states that if we have 4 cores in a CPU it is possible to run 4 small operations at the same excact nanosecond, this operations come in a process call thread, each core has to manage when to switch between threads in order to perform the necessary operations.
In this particular program that passes each json file in a folder to an html file, it makes sense to use paralelism, because otherwise we will need to wait for the first file to finish in order to start the second one, and so on.
Int this program we recieve the folder's name and the number of cores avaliable to assign while running the program. So for example, if we have four files and four cores, we'll assign the process that writes the Html code for one file each thread, this will enable the computer to write the Html code for all files at the same time.

## How to run the program
In our test case, the folders name is: "Short_Yelp" and the number of cores in my computer is four. So well call it:
```
(convertToHtml "Short_Yelp" 4)
```
And to know the time it took to complete time's racket function need to be added
```
(time(convertToHtml "Short_Yelp" 4))
```
## Speedup with parallelism
To measure the speedup using parallelism vs not using it, with the time was measured on as a test with 1, 2 and 4 cores and the same folder. Then we compared the percentajes on how the excecution time here are the results:
- 4 cores. Time: 60 167ms. 80% faster than with 2 cores. 209% faster than with 1 core.
- 2 cores. Time 108354ms. 71% faster than with 1 core.
- 1 core. Time 186164ms. 
We can clearly see a faster completion of the program managing the threads used as futures. This can also be explained by the time complexity. 
Before parallelism, one core had a **O(n * k)** complexity where n is the length of the file and k is the number of files on the folder.
After parallelism, the time complexity is **O(n * k)** where now k is the number of files in the folder divided by the numer of cores this is a lot faster mostly on large files or a when there are many files.
