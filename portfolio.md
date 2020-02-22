# Portfolio
<img src="/assets/progr.jpg" width="500" style="margin-left:3px;">

## Intro
My name is Grid Sherman, and I'm a Software Engineer with just over 4 years of experience. I will be graduating from Southern New Hampshire University (SNHU) in March, with a Bachelor's of Science in Computer Science. This ePortfolio serves to give a little background about me and what I'm interested in, as well as showing some of the work I've done on my own and with SNHU.
This portfolio will target 3 areas of software development:

- Software Design and Engineering
- Algorithms and Data Structures
- Databases

I'll be providing a professional self assessment first, followed by a video code review of 3 artifacts I have chosen to demonstrate my capabilities. Each artifact can be assessed in greater detail by clicking their respective links.

## Professional Self-Assessment
I started out my journey in computer science around the age of 12. I had always been enamored with video games since I was old enough to understand them, and my imagination always ran wild with imaginary games I wanted to play. Although there was no internet available at my house, my grandparents down the road were just close enough to get it. I would walk down the road and look up “how to make video games”. Around that time, there was a program available simply called “Game Maker” in its 7th version. I took the program back to my internet-free house on a USB stick, and began spending all my free time trying to learn how to use it, with little guidance. Eventually, after using a drag and drop interface for months, I discovered the scripting language in the engine. I slowly learned how to run commands in code until most of my games were written in code completely. And that’s when I discovered how rewarding programming was, that it was my passion.

I pursued a 4 year degree in computer science immediately after high school, but I eventually felt like I didn’t really need to spend the time and money for 2 more years of it. I decided to withdraw after two years and put my course credits towards finishing an Associate’s degree at a local community college quickly. I then went to work as a Software Engineer right after graduation, where I helped develop infrastructure for a company that hosted web content for over 200 newspapers.

After interviewing with another company, I decided that I wanted to finish what I started and complete my formal education in computer science. I decided that SNHU was the right fit for me, and was exposed to a multitude of classes that taught me new concepts, and reinforced what I had experience in.

For my current job, and a version control course at SNHU, I have become extremely proficient at coordinating with other developers in a team environment, and utilizing powerful software like GIT, JIRA, and Confluence to collaborate on software development projects in an agile development cycle. Another course, Object Oriented Analysis and Design, has also focused on my understanding of UML and software design. I now understand detailed processes to fully flesh out and architect new software solutions before diving into programming. Even for agile development cycles that don’t focus on this in-depth design process, I now have a stronger insight into problems I should look out for and build around. This has also aided my ability to break down the architecture of software to someone who may not be as familiar with programming terminology. I also have experience with writing secure code. I have completed a secure coding course that walked us through the dangers, and solutions, to a multitude of tricky errors such as overflows and injection attacks. I am also scheduled to complete a Security + training camp in March.

Another course, that I also have included as a demonstration in this portfolio, is the Client-Server Architecture course. Here we built a RESTful API that communicated to a NoSQL database and performed queries from URL requests. This covered a multitude of design paradigms and softwares, including Python Bottle servers and MongoDB. I also developed enhancements for this software of my own design, in the 3rd artifact of this portfolio. 

<img src="/assets/godotyarn1.png"/>

I think this serves as a good segue into what I consider one of my strong suites. My other artifacts, complementing my databases examples, are from a tool that I developed on my own using a middleware engine. Although the engine handled the low-level infrastructure, I have designed and implemented a full GUI that interacts with the user’s file system, parses a totally separate scripting language, and handles a variety of user inputs and interactions in a user-friendly display. In my personal work and professional career I have repeatedly been given a task or problem to solve, and have engineered a solution from the ground up to solve the problem in a robust, intuitive, and efficient way. I have recorded the details of this tool I designed between artifacts 1 and 2. All three of my artifacts show unique and important skills I possess, but I think the artifacts taken as a whole serve as a great example of the wide range of tools and methodologies I draw from in my solutions. I have working experience with many languages and tools, which gives me better insight into how to solve a problem in a fluid and sensible way.

As I have written previously, the 3 artifacts following will be specifically targeted to showcase my talent with software engineering, algorithms and data structures, and databases, respectively. I believe this work and the enhancements I have performed on them will back up my claims for experience I have in the software engineering field through school, work, and my personal hobbies.

## Code Review
<iframe width="506" height="300" src="https://www.youtube.com/embed/2Z_dmXj3cAo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Artifact 1
This artifact is focusing on one aspect of my Godot Yarn Tester tool. This is a tool I’ve been developing over the past few months to test out dialogue scripts written for video games or other interactive media. It provides an intuitive user interface that allows you to test out these dialogue scripts before you even bother integrating them into their final purpose. The core application source code will be used across two of my artifacts. In this artifact, I’m focusing on a specific aspect of this tool: the parsing of yarn files and the logic behind adding new user commands.  
[**Artifact 1 Details**](pages/artifact1.md)

## Artifact 2 
In this artifact, I’m focusing on the “action queue” and the surrounding code to utilize it. This is an internal design I’ve made to allow developers that choose to use this tool to receive the next line of dialogue or events at their own pace. This is necessary because the yarn files are parsed in one function call, but then need to be read back piece by piece either by the player or developer’s intervention.  
[**Artifact 2 Details**](pages/artifact2.md)

## Artifact 3
This artifact is from my CS 340 class - Client Server Architecture. In this class, we constructed a REST API in Python that interfaced to a MongoDB server. The data we manipulated was a large dump of various stocks, prices, and statistics for each one indicated by a “ticker”. The REST API allows users to hit URL endpoints to perform operations on the data, as well as a handful of custom queries allowing easy access to specific kinds of data.  
[**Artifact 3 Details**](pages/artifact3.md)
