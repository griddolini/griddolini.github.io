---
layout: default
title: Artifact 3
description: Databases
---

[**Artifact 3 Code**](https://github.com/griddolini/griddolini.github.io/tree/master/artifacts/RESTAPI)

# Artifact 3 - Databases
## What is it?
This artifact is from my CS 340 class - Client Server Architecture. In this class, we constructed a REST API  in Python that interfaced to a MongoDB server. The data we manipulated was a large dump of various stocks, prices, and statistics for each one indicated by a “ticker”. The REST API allows users to hit URL endpoints to perform operations on the data, as well as a handful of custom queries allowing easy access to specific kinds of data.

## Why showcase this?
This API was the culmination of 2 months of work in the class, requiring students to learn not only about what a RESTful web service is, but how to implement one in Python using the Bottle library. On top of that, the web service required us to write a slew of MongoDB queries, and learn about pipelines and various other aspects of a NoSQL database. This artifact shows:
- Client to Server Architecture
- MongoDB / NoSQL Experience
- Leveraging external libraries
- RESTful Design Principles
- JSON

## Enhancements
The enhancements I thought were important for this REST api were generally along the lines of cleaning up and enhancing its shortcomings that were left in, as a product of being a final project. I think allowing the user some flexibility over which dataset they need to utilize for their queries would be ideal. Additionally, I want to synchronize some of the outputs from the different functions to be more uniform. While read and delete return an object, create and update return different “success” type objects.
- Added endpoint for accessing a different collection
- Added endpoint for listing available collections
- Uniform returns for update and delete functionality
- Improved documentation

## Reflection
This particular enhancement was a little trickier as I needed to sub in some data. Once I had that going, these feature enhancements were natural progressions of things I had begun working on previously. I think the division I have between core mongoDB querying functions, and the actual REST api endpoint logic made it easier to keep the code organized as I added more depth. 
I think the documentation I had before was pretty lacking, so I added more detailed information about how the program works and flows as I progressed, to help orient a new user. Since I haven’t seen this code in a while, it was a little jarring myself to figure out where things were, so it was an important improvement.
