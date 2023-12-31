extends CharacterBody2D

@onready var gameManager = get_node("../")

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isParkouring = false
var isSliding = false

@onready var animationTree : AnimationTree = $AnimationTree

func _ready():
	animationTree.active = true
	
func _process(delta):
	update_animation_parameters()
	
func _physics_process(delta):
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction and not isParkouring:
		velocity.x = direction * SPEED
		if direction < 0:
			$CatSprite.flip_h = true
		else:
			$CatSprite.flip_h = false
	elif not isParkouring:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if not is_on_floor():
		if is_on_wall():
			isSliding = true
		else:
			isSliding = false
		if isSliding:
			if $CatSprite.flip_h:
				velocity.x = -1
			else:
				velocity.x = 1
			if Input.is_action_just_pressed("Jump"):
				$CatSprite.flip_h = not $CatSprite.flip_h
				velocity.y = JUMP_VELOCITY * 1.5
				if $CatSprite.flip_h:
					velocity.x = -SPEED * 1.5
				else:
					velocity.x = SPEED * 1.5
				isParkouring = true
			
		velocity.y += gravity * delta
		clampf(velocity.y, -1, 1)
	else:
		isParkouring = false
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
			
	move_and_slide()
	
func die():
	gameManager.emit_signal("playerDeath")
		
# Animations
func update_animation_parameters():
	if velocity == Vector2.ZERO:
		change_animation(true, false, false, false)
	elif velocity.x and is_on_floor():
		change_animation(false, true, false, false)
	elif velocity.y < 0:
		change_animation(false, false, true, false)
	elif velocity.y > 0:
		change_animation(false, false, false, true)
		
func change_animation(isIdle, isRunning, isJumping, isFalling):
	animationTree["parameters/conditions/isIdle"] = isIdle
	animationTree["parameters/conditions/isRunning"] = isRunning
	animationTree["parameters/conditions/isJumping"] = isJumping
	animationTree["parameters/conditions/isFalling"] = isFalling
