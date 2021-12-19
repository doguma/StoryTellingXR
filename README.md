<h1 align="left">Story-telling XR Framework - Animation</h3>
<p align="left">
    2021 VR Summer Project (https://youtu.be/79MMeKkfeFU)
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
	  <li><a href="#waypoint-system">Waypoint System</a></li>
	  <li><a href="#waypoint-variations">Waypoint Variations</a></li>   
	  <li><a href="#character-interactions">Character Interactions</a></li>   
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

<img src="/vr story gifs/vrstory1.gif?raw=true" width="500px">


By using AI based walk, the character moves towards the object upon the click of the object. Based on the proximity of the target object, the character goes through a sequence of animations (stand to sit, sitting, sit to stand) and walks away as the object actions are completed. Animations from [Mixamo](https://www.mixamo.com/#/), and character & environment models from [Meshtint](https://www.meshtint.com/) were utilized in this story. 
  

### Camera Movement
> As of August 27th, 2021
> - Camera following the character around to enhance user engagement

<img src="/vr story gifs/vrstory2.gif?raw=true" width="500px">


The viewer is presented with a bird-eye point of view with a fixed camera angle, which allows an semi-objective perspective of the story as the character moves around.


### Physics and AI
> As of Sep 10th, 2021
> - Agent with automated targeting

<img src="/vr story gifs/vrstory3.gif?raw=true" width="500px">

The tank object is embedded with a script to measure Euler angles between the target (main character) and itself (main character), this angle determines the rotating direction. The trajectory of the shooting material (bullet) is also calculated with the gravity, speed, and preset angles. The physics and equation were referenced from [Unity Learn's Physics of AI](https://learn.unity.com/project/the-physics-of-ai?uv=2019.4&courseId=5dd851beedbc2a1bf7b72bed).

### Waypoint System
> As of Sep 17th, 2021
> - Character Navigation with Waypoint System

<img src="/vr story gifs/vrstory4a.gif?raw=true" width="500px"> 
<img src="/vr story gifs/vrstory4b.gif?raw=true" width="500px">

Character navigation led by graphs of waypoints (yellow balls for visibility) with smooth rotation. This can be also applied to non-player character/object navigation to add movement to the background objects. Unity provides simple waypoint mechanism via Vector3 distance and Quaternion rotation.

Following is another example with Distant Lands asset - [Athazagoraphobia](https://assetstore.unity.com/packages/3d/environments/landscapes/athazagoraphobia-stylized-jungles-204433) and [Cryptid](https://assetstore.unity.com/packages/3d/characters/creatures/cryptid-low-poly-monsters-166160)

<img src="/vr story gifs/vrstory5a.gif?raw=true" width="500px"> 
<img src="/vr story gifs/vrstory5b.gif?raw=true" width="500px">

'Will-o'-the-wisp walking over the wires'
- Waypoint works for all 3 dimensions, allowing walks on different heights and positions


### Waypoint Variations
> As of Sep 29th, 2021
> - Variations of Waypoint System

Waypoints can be incorporated with different animation sequences as well - patrol, idle and jump functions were implemented with waypoints in this story. Throughout the game play, incremented waypoints are conditioned with the current **time** in Unity, which enables the character to pause in between the animations. 

Simple patrol function allows smooth animation sequence, while jump and idle functions use time to wait for certain amount of seconds before moving onto the next waypoint. Below is an example of the character jump animation with time pauses in between the jumps. 

Will-o'-the-wisp jumps off from the wire, steps on invisible stairs, and swims towards the bottom ground.

<img src="/vr story gifs/vrstory6a.gif?raw=true" width="500px"> 

Unity also allows change of physics state of the character in the script - here the character's rigidbody is changed from a floating state to a state with mass pulled by gravity.

When Will-o'-the-wisp almost reaches the ground, gravity is applied to the rigidbody, allowing smooth transition from state of jumping in the air to a state of walking or patrolling over the ground.

<img src="/vr story gifs/vrstory6b.gif?raw=true" width="500px">




### Character Interactions
> As of Oct 8th, 2021
> - Character Interactions

Simple interaction is created between Will and Spectre with each animator iterations. Will tries to talk to Spectre by approaching him and chatting out loud to wake him up.

<img src="/vr story gifs/vrstory7a.gif?raw=true" width="500px"> 

However Spectre barely responds by raising his head slightly to see where the sound is coming from, waves with his hand, and goes back to resting state. Will loses interest and leaves to look for another creature.

<img src="/vr story gifs/vrstory7b.gif?raw=true" width="500px">



------------

References :
- Brackeys
- Wizards Code
- Unity Learn (Artificial Intelligence for Beginners)
- Distant Lands (Unity Assets)



