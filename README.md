<h1 align="left">Story-telling XR Framework - Animation</h3>
<p align="left">
    2021 VR Fall Project 
</p> 

<!-- TABLE OF CONTENTS -->

  <ol>
    <li>
      <a href="#project-summary">Project Summary</a>
    </li>
    <li>
        <a href="#Prerequisites">Prerequisites</a>
    </li>
    <li>
      <a href="#progress">Progress</a>
      <ul>
	  <li><a href="#Basic-animations">Basic Animations</a></li>
	  <li><a href="#camera-movement">Camera Movement</a></li>
	  <li><a href="#Physics-and-AI">Physics & AI</a></li>
      </ul>
    </li>
  </ol>



<!-- Project Summary -->
## Project Summary

XR Storytelling Project presents 3D Animations for viewers to understand the storyline while immersed in VR. This repository shows the dynamics of different animations that involves physics of AI, Waypoints & Graphs, Navigation Meshes and Finite State Machines. The animations with AI were created to depict the different types of character actions for the Storyboard via [Unity3D](https://unity.com/).

## Prerequisites

* Unity 2021.1.13
  ```
  https://unity3d.com/get-unity/download
  ```
* Requirements are limited by Unity game engine requirements, running on both Windows (7, 8, 10) and Mac OS X (10.9+). More information about Unity requirements can be found at: [https://unity3d.com/unity/system-requirements](https://unity3d.com/unity/system-requirements).

  
<!-- Progress -->
## Progress

### Basic Animations
> As of August 19th, 2021
> - "Sitting on a Chair" animation

![Imgur Image](https://i.imgur.com/ynZcGyR.gif)

By using AI based walk, the character moves towards the object upon the click of the object. Based on the proximity of the target object, the character goes through a sequence of animations (stand to sit, sitting, sit to stand) and walks away as the object actions are completed. Animations from [Mixamo](https://www.mixamo.com/#/), and character & environment models from [Meshtint](https://www.meshtint.com/) were utilized in this story. 
  

### Camera Movement
> As of August 27th, 2021
> - Camera following the character around to enhance user engagement

![Imgur Image](https://i.imgur.com/gbyYX5N.gif)

The viewer is presented with a bird-eye point of view with a fixed camera angle, which allows an semi-objective perspective of the story as the character moves around.


### Physics and AI
> As of Sep 10th, 2021
> - Agent with automated targeting

![Imgur Image](https://i.imgur.com/acctSEA.gif)

The tank object is embedded with a script to measure Euler angles between the target (main character) and itself (main character), this angle determines the rotating direction. The trajectory of the shooting material (bullet) is also calculated with the gravity, speed, and preset angles. The physics and equation were referenced from [Unity Learn's Physics of AI](https://learn.unity.com/project/the-physics-of-ai?uv=2019.4&courseId=5dd851beedbc2a1bf7b72bed).


------------

References :
- Brackeys
- Wizards Code
- Unity Learn (Artificial Intelligence for Beginners)



