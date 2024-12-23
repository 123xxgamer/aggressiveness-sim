turtles-own [agr age deathAgeX]
patches-own [foodAmount splitPcnt]

to setup
  ca
  reset-ticks
  resize-world ((worldWidth - 1) / -2) ((worldWidth - 1) / 2) ((worldHeight - 1) / -2) ((worldHeight - 1) / 2)
  updateFood
  cro numStartingTurtles [
    setxy random-xcor random-ycor
    set color (blue)
    set agr 0
    set age 0
    ifelse slightlyRandomDeath? [
      set deathAgeX (deathAge + ((random 6) - 3)) ] [
      set deathAgeX deathAge ]  ]
  ask n-of ((percentAgrAtStart / 100) * numStartingTurtles) turtles [
    set color red
    set agr 1]  updateFood
  tick
end

to go
  wait 0.05
  updateFood
  ask patches [
    set splitPcnt 500]
  repeat 100 * waitTime [
    ask turtles [
      wiggle
      wait 0.0005]]
  ask turtles [
    getToAnyFood ]
  ask turtles [
    goToSoloDuoFood ]
  ask turtles [
    splitFood ]
  ask turtles [
    updateAge]
  wait waitTime
  tick
end

to getToAnyFood
  let foodPatches (patches with [foodAmount = 4])
  move-to one-of foodPatches
end

to goToSoloDuoFood
  let foodPatches (patches with [foodAmount = 4])
  ifelse (((count turtles-here) > 1) and any? (foodPatches with [count turtles-on self = 0])) [
    let soloFoodPatch one-of (foodPatches with [(count (turtles-on self) < 1)])
    if whatTurtlesAlone? = "all" [
      move-to soloFoodPatch
      set heading random 360
      bk 0.4]
    if whatTurtlesAlone? = "onlyArg" and agr = 1 [
      move-to soloFoodPatch
      set heading random 360
      bk 0.4]
    if whatTurtlesAlone? = "onlyArg" and agr = 0 [
      move-to soloFoodPatch
      set heading random 360
      bk 0.4]][
    ifelse ((count turtles-here) > 2) [
      ifelse (any? (foodPatches with [count turtles-on self < 2])) [
        let duoFoodPatch one-of (foodPatches with [(count (turtles-on self) < 2)])
        move-to duoFoodPatch
        set heading random 360
        bk 0.4
      ] [
        die
  ]] [
    set heading random 360
      bk 0.4]]
end

to updateFood
  cp
  ask patches [
    set pcolor brown - 3]
  ifelse slightlyRandomFood? [
    let totalFood numFood + ((random 10) - 5)
    if totalFood < 0 [
      set totalFood 0]
    ask n-of totalFood patches [
      set foodAmount 4
      set pcolor green ]] [
    ask n-of numFood patches [
      set foodAmount 4
      set pcolor green ]]
end

to wiggle
  fd (1 + ((random 5) + 1) * 0.1)
  lt random 45
  rt random 45
end

to splitFood
  ifelse splitPcnt != 500 [
    if (splitPcnt < 50) and ((random 50) >= splitPcnt) [
      die]
    if (splitPcnt > 50) and (((random 50) + 50) < splitPcnt) [
      hatch 1 [
        set age 0
        ifelse slightlyRandomDeath? [
          set deathAgeX (deathAge + ((random 6) - 3)) ] [
          set deathAgeX deathAge ]]]
  ] [
    ifelse (count turtles-here) = 1 [
      hatch 1 [
        set age 0
        ifelse slightlyRandomDeath? [
          set deathAgeX (deathAge + ((random 6) - 3)) ] [
          set deathAgeX deathAge ]]] [
      if (agr = 0) and (([agr] of one-of other turtles-here) = 0) [
        set splitPcnt 50]
      if (agr = 0) and (([agr] of one-of other turtles-here) = 1) [
        set splitPcnt (agr-nonAgrFood * 25)
        if (((random 50) + 50) < splitPcnt) [
          die]]
      if (agr = 1) and (([agr] of one-of other turtles-here) = 0) [
        set splitPcnt (100 - (agr-nonAgrFood * 25))
        if ((random 50) + 50) >= (agr-nonAgrFood * 25) [
          hatch 1 [
            set age 0
            ifelse slightlyRandomDeath? [
              set deathAgeX (deathAge + ((random 6) - 3)) ] [
              set deathAgeX deathAge ]]] ]
      if (agr = 1) and (([agr] of one-of other turtles-here) = 1) [
        set splitPcnt (agr-agrFood * 25)
        if random 50 >= splitPcnt [
          die]]
  ]]
end

to addAgr
  cro 1 [
    set agr 1
    set color red
    setxy random-xcor random-ycor
    ifelse slightlyRandomDeath? [
      set deathAgeX (deathAge + ((random 6) - 3)) ] [
      set deathAgeX deathAge ]]
end

to addNon
  cro 1 [
    set agr 0
    set color blue
    setxy random-xcor random-ycor
    ifelse slightlyRandomDeath? [
      set deathAgeX (deathAge + ((random 6) - 3)) ] [
      set deathAgeX deathAge ]]
end

to updateAge
  if oldAge? [
    set age age + 1
    if age >= deathAgeX [
      die]]
end
@#$#@#$#@
GRAPHICS-WINDOW
257
10
616
630
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-13
13
-23
23
0
0
1
ticks
30.0

BUTTON
47
350
191
383
Setup Simulation
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
28
393
217
426
Play/Pause Simulation
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
32
157
204
190
numFood
numFood
0
200
38.0
1
1
NIL
HORIZONTAL

SLIDER
30
195
202
228
worldWidth
worldWidth
15
61
27.0
2
1
NIL
HORIZONTAL

SLIDER
30
235
202
268
worldHeight
worldHeight
15
61
47.0
2
1
NIL
HORIZONTAL

PLOT
18
447
251
597
Number Agressive/Nonagressive Turtles
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot count turtles with [agr = 1]"
"pen-1" 1.0 0 -13840069 true "" "plot count turtles with [agr = 0]"

SLIDER
27
4
199
37
agr-agrFood
agr-agrFood
0
1.5
0.0
0.5
1
NIL
HORIZONTAL

SLIDER
26
44
198
77
agr-nonAgrFood
agr-nonAgrFood
2.5
4
3.0
0.5
1
NIL
HORIZONTAL

SLIDER
28
121
203
154
numStartingTurtles
numStartingTurtles
2
100
51.0
1
1
NIL
HORIZONTAL

SLIDER
27
85
199
118
percentAgrAtStart
percentAgrAtStart
0
100
100.0
1
1
NIL
HORIZONTAL

PLOT
16
618
253
768
Total Number Turtles
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -13791810 true "" "plot count turtles"

SWITCH
26
314
234
347
slightlyRandomFood?
slightlyRandomFood?
0
1
-1000

BUTTON
40
817
252
850
Add One Agressive Turtle
addAgr
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
273
819
514
852
Add One Nonagressive Turtle
addNon
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
44
855
157
888
oldAge?
oldAge?
1
1
-1000

SLIDER
175
855
347
888
deathAge
deathAge
3
20
20.0
1
1
NIL
HORIZONTAL

SWITCH
359
857
575
890
slightlyRandomDeath?
slightlyRandomDeath?
1
1
-1000

CHOOSER
228
909
384
954
whatTurtlesAlone?
whatTurtlesAlone?
"none" "all" "onlyNonAgr" "onlyAgr"
2

SLIDER
33
277
205
310
waitTime
waitTime
0
0.5
0.0
0.02
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This model aims to simulate the evolution, via natural selection, of aggressiveness in a population. It is very interesting to observe the success of these traits in a carefully managed population.

## HOW IT WORKS

There are two types of turtles: aggressive turtles, which are red and shown by the red line on the graph, and nonaggressive turtles, which are blue and shown by the green line on the graph. Each turtle needs 2 food to survive, and another 2 food to reproduce (so 4 food total to survive AND reproduce). Intermediate amounts of food lead to corresponding chances of survival and reproduction. For example, 1 food will lead to a 50% chance of survival, while 2.5 food will lead to survival and a 25% chance of reproduction. Each cycle of the simulation, some randomly determined patches will grow 4 food. Each turtle will find a patch with food. If it is alone, it will eat all 4 food, thus reproducing. If it ends up on the same patch as a 2nd turtle, then if both turtles are nonaggressive, each turtle will get 2 food and survive; if both turtles are atggressive, each turtle will get somewhere between 0 and 1.5 food; and if there is one of each, the nonagressive one wil get between 0 and 1.5 food; the aggressive one will get between 2.5 and 4 food. If there are not enough patches with food for there to be no more than 2 turtles per patch, the extra turtles will automatically die.

## HOW TO USE IT

First, one must setup the simulation:

  * The percentAgrAtStart slider determines what percent of turtles will be aggressive when you click setup.
  * the numStartingTurtles slider determines the amount of turtles that are created after you click setup.
  * The worldWidth and worldHeight sliders control the width and height, respectively, of the world (in patches).
    * Note that world size does not affect the results of the simulation and is purely visual.

You are now ready to click setup and configure the simulation rules.

  * The numFood slider determines the number of patches that will grow food each round.
    * The slightlyRandomFood? switch, when turned on, will allow for a random +/- 5 variation in the amount of patches that grow food each cycle, to create some variation between cycles.
  * The agr-agrFood slider controls how much food each aggressive turtle gets when encountering another aggressive turtle.
  * The agr-nonAgrFood slider controls how much food the aggressive turtle gets when encountering a nonaggressive turtle.
    * Note that the nonaggressive turtle will then get 4 - [whatever the slider is set to]
  * The oldAge? switch, when turned on, will cause turtles to keep track of and die from old age.
    * The deathAge slider determines the age, in cycles, at which turtles will die.
    * The slightlyRandomDeath? switch, when turned on, will lead to +/- 3 random variation in a turtle's deathAge.
  * The Add One Aggressive Turtle and the Add One Nonaggressive Turtle buttons can be pressed at any point while the simulation is running to insert one turtle of the respective type into the simulation.
  * The whatTurtlesAlone? dropdown lets one choose which turtles, if any, prefer to be alone on a patch rather than sharing the patch with another turtle, when the amount of available patches permits this.
  * The waitTime slider determines how long, in seconds, the feeding time lasts. This is purely visual and does not affect the results of the simulation. This slider also affects how long the turtles wiggle before going to a random food, also not affecting the results of the simulation. Setting this slider to 0 is perfect for running cycles very quickly, thus tracking the effects of various options over multiple generations in a short period of time.
 
## THINGS TO NOTICE

Notice how at different combinations of simulation rules, the equilibrium that is achieved, as seen in the graph that shows the population of both aggressive and nonaggressive turtle, is different. This equilibrium can be determined algebraically by calculating and comparing the expected food values per cycle of each type of turtle; an equilibrium is achieved then these values are equal.
Also notice how a population of all nonaggressive turtles will achieve a greater total population than a population of mixed turtles (or all aggressive turtles) under the same conditions, as can be seen on the total population graph. This shows how natural selection doesn't always lead to what is best for the species, but rather what is best for each trait. This can be tested by starting with wither all nonaggressive turtles or all aggressive turtles and then adding a couple of the opposite type of turtles using the buttons, and observing how that affects both realtive and total populations.
Also note that it is easiest to spot patterns when waitTime is set to 0, since this allows the simulation to run cycles quicker.

## THINGS TO TRY

We recommend starting at the following values for how much food turtles get, and playing around from there: agr-agrFood = 0, agr-nonAgr food = 3.

## RELATED MODELS

Check out the models in the Social Science category of the models library: many of them explore or simualte similar principles to the ones shown in this simulation. More specifically: Altruism, Cooperation, and the models in the Prisoner's Dillema folder.

## CREDITS AND REFERENCES

This model is mostly based on this video by Primer: https://youtu.be/YNMkADpvO4w?si=U0TPOxsYml1Sqmwo.
Credit to this video for sparking my interest in behavioral simulations and the prisoner's dillema: https://youtu.be/mScpHTIi-kM?si=7q3HA5SyK_TxGaLV.
Credits to the programs in the Model Library/Social Science/Prisoner's Dillema folder for helping inspire some functionality in this simulation.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
