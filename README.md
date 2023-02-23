# Desktop Application Framework for the Apple IIGS

This is a minimal Apple IIGS desktop application framework for [System 6.0.1](https://en.wikipedia.org/wiki/Apple_GS/OS) written in 65c816 assembly.

The inspiration behind this project was the lack of examples using the Apple IIGS tool sets or creating a System 6 desktop application.  This project can hopefully serve as a working example and jumping off point to fill that gap.

Apple's reference manuals, "Apple IIGS Toolbox Reference Volume 1" and "Volume 2", were crucial for this project.  "Programmer's Introduction to the Apple IIGS" by Apple, "Advanced Programming Techniques for the Apple IIGS Toolbox" by Morgan Davis and Dan Gookin, and "Apple IIGS Assembly Language Programming" by Leo J. Scanlon were also helpful for some of the examples and information that they provided.

# Cross Platform Development Tools

- [Merlin 32](https://www.brutaldeluxe.fr/products/crossdevtools/merlin/index.html) - 65c816 assembler and linker from Brutal Deluxe
- [Cadius](https://www.brutaldeluxe.fr/products/crossdevtools/cadius/index.html) - Apple II disk image utility from Brutal Deluxe ([Linux port](https://github.com/mach-kernel/cadius))
- [KEGS](http://kegs.sourceforge.net/) - Apple IIGS emulator

# Development Environment

All development is done in Linux.  [Visual Studio Code](https://code.visualstudio.com/) is used for code editing and [GNU Make](https://www.gnu.org/software/make/) is used to build and run the project.  The tool chain consists of assembling and linking the source code with Merlin 32, creating an Apple II disk image with Cadius, and executing the program with KEGS.

# Implementation Notes

## Tool Sets

Here is a list of some of the more noteable tool sets used.  This project should provide a working example of starting up, simple interactions with, and shutting down these tool sets.

- Memory Manager
- Desktop Manager
- Menu Manager
- Dialog Manager
- Event Manager

## Data Structures

Some of the tool sets require data structures to be defined in memory to control the position, size, layout, text, etc. for user interface controls.  The format used by examples found in legacy books uses a syntax not supported by modern tools, such as Merlin 32, for defining these memory structures.  This project should provide a working example of defining records in the newer format expected by Merlin 32.

- Menu Lines
- Item Lines
- Dialog Template
- Item Template
- Event Record

# Remaining Work

Getting memory management correct and all of the tool sets working together was tricky.  While this example works as is, it wouldn't be surprising if something is not quite correct with some of the tool set memory management.
