---
layout: default
title: Artifact 2
description: Algorithms and Data Structures
---

[**Artifact 2 Code**](https://github.com/griddolini/griddolini.github.io/tree/master/artifacts/GodotYarnTester/singletons/Storyteller.gd)
  
 [**Godot Yarn Tester Full**](https://github.com/griddolini/griddolini.github.io/tree/master/artifacts/GodotYarnTester)
 
# Artifact 2
## What is it?
This artifact is focusing on one aspect of my Godot Yarn Tester tool. This is a tool I’ve been developing over the past few months to test out dialogue scripts written for video games or other interactive media. It provides an intuitive user interface that allows you to test out these dialogue scripts before you even bother integrating them into their final purpose. 
	The core application source code will be used across two of my artifacts. In this artifact, I’m focusing on the “action queue” and the surrounding code to utilize it. This is an internal design I’ve made to allow developers that choose to use this tool to receive the next line of dialogue or events at their own pace. This is necessary because the yarn files are parsed in one function call, but then need to be read back piece by piece either by the player or developer’s intervention.

## Why showcase this?
The Godot Yarn Tester tool covers a broad range of different problems that needed to be solved for it to be in the nearly finished state it is now. For the action queue and associated algorithms, I needed to possess a variety of abilities to get it working how it is now:
- User interface and GUI development
- Event listener architecture
- Advanced dictionary use
- Queue and Stack management
- Recursively reading file trees
- Separation of concerns

## Enhancements
To allow users to actually test their yarn files, I needed a history output of events that happened and a variable tracker so they can view the status of the player/story. Currently, only custom events, dialogue, and choices are built into the action queue. Viewing the history from a parsed file, I realized that setting a variable occurs the instant the yarn file is parsed, instead of when the action queue has reached the appropriate place in the dialogue. I needed to build the action queue out to support a new type of action, as well as accommodate this clearly in the UI and historical output.
- Added new “variable set” action queue entry
- Added the variable setting output to color coded history output
- Processed next action queue entry immediately after calling “variable set”

## Reflection
Like the other enhancement, I was building this around something that already was functional, but needed refinement. Once making the change at the surface level, a variety of other problems I needed to address appeared, such as changing the parsing function to create the action queue entries as opposed to creating the variable, and moving the logic around.
I think this makes a lot more sense for the end user, as they could tie in their own events linked to the changing of a variable, such as a UI notification. If I didn’t call these events chronologically, they would not even have the option to do so.
