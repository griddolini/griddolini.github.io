---
layout: default
title: Artifact 1
description: Software Design and Engineering
---

# Artifact 1 - Software Design and Engineering
## What is it?
This artifact is focusing on one aspect of my Godot Yarn Tester tool. This is a tool I’ve been developing over the past few months to test out dialogue scripts written for video games or other interactive media. It provides an intuitive user interface that allows you to test out these dialogue scripts before you even bother integrating them into their final purpose.
The core application source code will be used across two of my artifacts. In this artifact, I’m focusing on a specific aspect of this tool: the parsing of yarn files and the logic behind adding new user commands.

## Why showcase this?
The Godot Yarn Tester tool covers a broad range of different problems that needed to be solved for it to be in the nearly finished state it is now. When it comes to parsing code from another file, I had to accommodate a lot of different situations if I wanted to make writing code for the yarn file natural. Developing this aspect of the tool required:
- Type conversion and casting
- Error handling
- User input sanitization
- Parsing nested conditional logic
- Parsing a markup language
- Thorough documentation

## Enhancements
Although the product is nearing its first feature complete version, I did notice some lacking parts during my tests. One is how I parse the “if” statement logic. Since the parsing basically defines what the yarn file can support, it turns out that you cannot use the statement “if <<bool>>” in a conditional. Currently, I made it so you have to write out “if <<bool>> is (true || false).
- Changed error handling to allow different sizes of if statements
- Allowed lack of operator to be treated as “==” conditional
- Added support for “not” in shortened if statement

## Objectives
Setting out to achieve this enhancement, I wanted to contribute to making this software complete and high quality, and also to demonstrate various skills I have acquired working with software engineering and design. In creating this yarn parser, I worked on creating what is essentially a streamlined scripting language by parsing my own set of yarn commands and logic. I leveraged existing technologies where it made sense, such as building this in the Godot Engine. I also expect end users to use the existing Yarn Editor. However, I made the decision to program my own rules for how the yarn files be written, as I saw them as simpler yet more powerful.

## Reflection
Since this enhancement was added on to an already functional part of the code, there was a little bit of moving and refactoring required to get it to fit nicely. Some of the logic used to parse the command, such as expected a specific set of words to come in order, needed to be changed. The expanded logic also opened up some new ideas for me on how to potentially improve this further, as the logic for the main parsing command has gotten pretty large. It’s not unwieldy, but has the potential to be should I add more commands.
