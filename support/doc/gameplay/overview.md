


# [*Asymmetric Golf Game* One Page Pitch (Notes)](https://docs.google.com/document/d/1jzf2ZQjRkKHt4cArtHs0mGiY5tlQgmUuavycKDsxWFg/edit)


## Names
- *Griefers’ Golf*


## Overview
- *“A **competitive** golfing game that focuses on **asymmetric** gameplay where **one** person strives to **complete the objective** while all **others** try and **hinder** them.”*
- Wacky
- App
- Multiplayer


## Target Audience and Rating
- E for Everyone
- Some comic mischief (on a ball)


## Game Play
- “How do we empower players to grief each other?”
    - What is griefing?
        - Indirect, Unfair Confrontation
        - Messing with others
        - *“performing **actions** in a game to **prevent** the **player** from **enjoying** the game”* -- [UrbanDictionary: Griefing](https://www.urbandictionary.com/define.php?term=griefing)
    - What games do this well?
- We want real-time griefing, think Team Fortress 2, with how the engineer can repair, upgrade, and move his building during an attack from the enemies
- What do we want the player to feel?
    - Accomplishment?
    - Frustration?
    - [Eight Kinds of Fun](http://algorithmancy.8kindsoffun.com/)
- What do we want players to be frustrated in?
    - The Ball?
    - Themselves?
    - Other Players?
- What is failure?
    - Player is killed?
    - Player is stuck?
    - Player is delayed?
- What do the griefer’s traps do?
    - Are they annoying? (Think Jarate)
    - Are they disruptive? (Think AirBlast)
    - Are they disabling? (Think Sapper)
- Do we want static or dynamic sabotage?


## Multiplayer
- Two players minimum
- One golfer, and at least one player attempting to externally interfere with the golfer’s success (potentially called a “griefer”)


## Controls
- Consider Carrion’s movement system
    - Very easy/pleasant to use input system
        - Left Click: Move in this direction
        - Right Click: Attack/Ability


## Characters
- Do we want role-playing?
    - Compare Team Fortress 2 with Planetside 2
        - Both have classes, but one emphasizes a ***character* with special weapons**, while the other emphasizes ***equipment* and allowing most classes to share weapons**


## Camera
- 3D, 3rd person camera following the ball for the Golf player
- Similar perspective and controls for the griefers, however:
    - Griefers can zoom out more and view more of the level
    - Griefers’ movement and position is not tied to a ball; They can move freely


## Graphics
- Goofy, cartoonish art style
- Courses will consist of vibrant, smooth rolling hills
- Traps deployed by the anti-golf players will look goofy and ramshackle
    - Wile E. Coyote’s ACME traps come to mind


## Time
- Plays fast; 5 minutes at maximum
- Golfer’s ball movement and Griefers’ trap/obstacle placement both occur in the same real time
    - Traps are more intended to slow down the golfer than to outright derail them
    - Leaves the time spent in each match mostly up to map size
    - Griefers could potentially force an artificial time limit on the golfer by punishing them for playing slowly
        - Most likely by preparing more if given time, not by directly harming the Golfer


## UI
- Minimal HUD
    - Display as much pertinent information through the level itself as possible
    - Golfer may not need a HUD at all
    - Griefers likely need a widget for placing objects, like sort of a pre-placement hologram
    - Griefers need to know what they’re placing, what they have available, etc.


## Sound
- *Fling to the Finish*
    - The ambient music is mostly kazoo
- Avoid serious tones, focus on goofy music to suit a nonchalant, party-game type of casual fun


## Level Design
- Golf courses, but: 
- Designed specifically to house traps and various interference objects/manipulatable terrain elements for use by the mischievous non-golfing players
- More of a maze, less of a course?
- Minigolf?
    - Have several “mini-courses”
    - Players open app
    - Players press “play” and join queue of 5 others
    - Players told to start, have one minute to set up their course with traps, curves, loops, features
    - Clock rings, players line up to play first course
    - Player who designed course is not allowed to play, and must instead control the activation/play of traps, etc to stop as many players as possible
    - Players race to finish/finish first
    - After first course complete, players move on to second course
    - (Players are both golfers and griefers in this scenario)
    - See *Jack in the Box*


## Tools
- *Godot* Game Engine
- *Git* Version Control
- *Gitlab* Git Hosting
- *Gitlab* Static Site Serving  (Jekyll)
- *C#* Programming Language
- *Visual Studio Code* Programming Editor
- *Google Drive* Document Sharing
- *Autodesk Maya* 3D Modelling
- *Adobe Photoshop* Image Manipulation


## Technology
- Multiplayer Networking
- Realtime Physics
- Dynamic Terrain and Environment
    - Possibly Voxels
        - **[Voxel Tools for Godot](https://github.com/Zylann/godot_voxel)**
- Golfing Physics (Golf Ball, Golf Putters)
    - **[Working on a Procedural Level Generator for hyperputt - also thinking of renaming it to IsoPutt or Infinite Golf](https://www.reddit.com/r/godot/comments/fv5c7a/working_on_a_procedural_level_generator_for/)**
    - **[Kinematic Equations (E03: ball problem)](https://www.youtube.com/watch?v=IvT8hjy6q4o)**
    - **[Create Golf Game Part 1 | Unity Tutorial](https://www.youtube.com/watch?v=dIGJ_ltO1Q0)**
- Networked Physics
- Building Placement


## Related Games/Inspirations

### Tom’s Trap-o-matic (????)
- **[Tom and Jerry: Tom's Trap-O-Matic - Set up Elaborate Traps to catch Jerry (Boomerang Games)](https://www.youtube.com/watch?v=NIQTlOx8MPQ)**

### Team Fortress 2 (2007)
- Especially the Engineer class and the Spy class
- Both commit sabotage, albeit statically and dynamically

### Golf It (2017)
- **[Random Golf It Bullshittery](https://www.youtube.com/watch?v=Ctik9yob2Rw)**

### Carrion (2020)

### Splinter Cell: Chaos Theory (2005)
- specifically, Spies versus Mercs
- **[Chaos Theory - Spy Vs. Merc - Bank 1](https://www.youtube.com/watch?v=su3eckcVSMw)**

### Transformice (2010)
- **[Wikipedia](https://en.wikipedia.org/wiki/Transformice)**
- Single mouse = pope mouse with special abilities
- Every other mouse trying to win
- We reverse the dynamic
- One player trying to win
- Every other player trying to prevent this

### Hitman: Blood Money (2006)
- This, but reversed
- Instead of one player trying to blend in, the griefers are trying to blend in for one player

### Intruder (2014)
- **[Intruder - 6v6 Riverside Pick Up Game](https://www.youtube.com/watch?v=-yoc4gkVqgk)**
- Note the use of various gadgets, sensors, mines, etc that the players can setup to trap other players
- Also note the complex map, which enables stealth gameplay
- Gameplay is very slow
- Players are both active, in dealing with threats directly
- But passive, they are extended by their traps and gadgets

### Viscera Cleanup Detail (2015)
- **[Random Viscera Cleanup Detail Bullshittery](https://www.youtube.com/watch?v=bcVu4j_hkLc)**
- Majority of fun comes from friends

### Ultimate Chicken Horse (2016)
- **[Ultimate Chicken Horse Trailer](https://www.youtube.com/watch?v=sFdjL4elfPU)**
- Notable setup period, everyone must play through the traps

### Home Alone (1990)
- **[Home Alone Trilogy (1990-1997) Booby Trap Count](https://www.youtube.com/watch?v=0rcCeIOcakU)**
- The classic reference (with regards to comical traps)
- Players must discover items to use as traps throughout map
- Players must place and hide traps
- Players must enter the house and navigate around the traps
- A lot of fun is extracted from animation and effects in response to failing a trap
- Players vicariously experience pleasure/pain from watching others traverse their traps
- Also consider the amount of time spent in preparation for the “raid” and how the movie presents this sequence
- I call this **“Bowling Alley Humor”**
    - (recall those wacky animations that play)
    - Is bowling actually fun on its own?
    - If not….

### Dumb Ways to Die (2012)
- **[Dumb Ways to Die - Universal - HD Gameplay Trailer](https://www.youtube.com/watch?v=Ll_CF97UALE)**
- Note the use of quick gestures and actions to avoid death
- These deaths could be considered “Traps”
- Depending on the style of gameplay, we could have a longer play (avoiding this style of gameplay), or shorter play, which necessitates this kind of play

### Evolve (2015)
- Multiple players trying to trap one player
- Monster player is very active, actively avoids other players
- Trappers very actively pursue the monster player

### Mario Kart (????)
- General Polish, feel, of racing around a track in 3D
- Variety of themes across levels
- Level entry, play, and exit


## People
- **Peter**
- **Rex**
- **Jake**


## Questions
- Do we want to even bother with putting?
    - Consider player’s need/ability to dodge other players while traversing course
        - Consider how platformers handle jumping between platforms
            - *Half Life*: Lots of **“Air Strafing”**
                - Ability to adjust course while in flight
            - *Thief*: **No** Air Strafe
                - Once a player commits to a jump, they cannot adjust
    - Consider Wanted (2016)
        - Featured bullets that could **“curve”** mid-flight
    - Consider Tribes: Ascend (2012)
        - High-speed, skiing, jet-packing first-person-shooter
        - What if we had this, but slowed-down?
            - As in, introduce lots of inertia, make it harder to maneuver


## Pictures

### *Tom’s Trap-o-matic* in Play Mode

![Tom's Trapomatic in *Play* Mode](tom_1.png)

- The traps animate and bump into each other, hazards (such as the dog) can trigger if a loud noise (such as a telephone trap) activates next to them, etc

### *Tom’s Trap-o-matic* in Edit Mode

![Tom's Trapomatic in *Plan* Mode](tom_2.png)

- Note the arrows indicating trap direction

### *Team Fortress 2*’s Engineer, carrying a building

![An Engineer in Team Fortress 2 planning where to put his sentry turret](tf2_1.png)

- Note the use of color, many shapes, and various HUD items
- The engineer moves in first-person, but the building is always in front of them, and transforms to reflect whether it can be “placed” on a spot, what direction it is facing, and what range it will operate within

### *Golf It*, lining up a shot

![*Golf It*, lining up a shot](golf_1.png)

- Note the “assistives” - a laser pointer
- The camera is third person, revolving about the player’s ball
- Also note the perspective provided on the rest of the course

### *Far Cry 3: Blood Dragon*, looking for Map Markers

![*Far Cry 3: Blood Dragon*, looking for Map Markers](fc3_1.png)

- Note the HUD-less approach to denoting where major landmarks are on the map

