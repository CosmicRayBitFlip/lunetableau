extends KinematicBody2D

class_name Enemy

var hp:int
var speed:int
var dir:Vector2

var team:int # team only has to be assigned for normal human robot (wait 'human robot'?)
enum {WHITE, RED, BLUE, YELLOW} # teams

# i don't even remember the reason i made this class if i was just gonna leave it blank
