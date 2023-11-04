# GameOff 2023 project
<div style="overflow:hidden;">
<img src="game-off-2023-logo.png" width="100px" style="float:left;" />
<div style="float:left;">
A puzzle game about linking objects together.
</div>
</div>

## Controls
* **Move**: WASD or arrow keys
* **Look around**: Move mouse
* **Link objects**: Left click
* **Unlink objects**: Right click

## Link types
There are several ways two objects can be linked:
* **Forward link**: Any movement applied to object A is also applied to object B *if possible*, and vice versa. If one object is for example pushed up against the wall, the other can still move.
* **Static forward link**: As above, but if one object is pushed up against at wall, the other cannot move in that direction.
* **Reverse link**: As the static forward link, but movement from one object is negated before being applied to the other.

Currently only the forward link and static forward link is implemented.
