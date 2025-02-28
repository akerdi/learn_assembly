# Learn Assembly

Learn Assembly introduces how to quickly master assembly, at lease knowing how to find related documents, and essential knowledgement about assembly.

<!-- Content mostly ref to [Ref](#ref), you can read directly by original author, or learn more clear way by this documentation. -->

## Run

I work on Windows's WSL ubuntu20.04, download nasm, and Using VSCode(VSCode linking to WSL):

```
Platform    : Windows WSL - Ubuntu20.04
IDE         : VSCode - WSL:Ubuntu-20.04
Build Tool  : `sudo apt-get install gcc nasm binutils`
Makefile    : `sudo apt-get install build-essential`
```

Manually build and run:

    nasm -f elf64 -o main.o main.asm && ld -o main main.o && ./main
 <!-- Makefile is optional, you can build&&run by `nasm -f elf64 -o main.o main.asm && ld -o main main.o && ./main`. -->

Run by using vscode task:

<!-- After basic environment is ready, you can quickly run in VSCode: -->
    cp .vscode/tasks.example.json .vscode/tasks.json # copy VSCode tasks configuration
    # Press [Ctrl+p]
    # Type `task run`, then press [Enter] twice

Run in WSL terminal:

    make # or `make 0 1` to build and run one or more lessons.

![01Helloworld](./Assets/01Helloworld01.jpg)

## List

+ [01Helloworld](./01Helloworld/README.md)

## Ref

[0xAX/asm](https://github.com/0xAX/asm/blob/master/content/asm_1.md)

[DGivney/assemblytutorials](https://github.com/DGivney/assemblytutorials)

## License

[License-us](./License)

[License-zh](./License.zh)
