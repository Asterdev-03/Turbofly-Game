extends CharacterBody3D


const SIDEWAY_SPEED = 5.0
const FORWARD_SPEED = 500
const MAX_ROTATE = deg_to_rad(30)
const CAMERA_SPEED = 0.1

@onready var cameraController = $CameraController
@onready var meshInstance = $MeshInstance3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement
	var input_dir = Input.get_axis("move_left","move_right")
	
	cameraController.rotate_y(- input_dir * deg_to_rad(1))
	
	# New Vector3 direction takes into account the user inputs and the camera position
	var direction = (cameraController.transform.basis * Vector3(input_dir, 0, -1)).normalized()
	
	if input_dir != 0:
		meshInstance.rotation_degrees.y = cameraController.rotation_degrees.y
	#
	# Rotate the player when moving left or right by a slight angle
	rotation.z = direction.z * input_dir * MAX_ROTATE
	
	if direction:
		velocity.x = direction.x * SIDEWAY_SPEED
		velocity.z = direction.z * FORWARD_SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SIDEWAY_SPEED)
		velocity.z = move_toward(velocity.z, 0, SIDEWAY_SPEED)
	
	# Player moves forward infinetly

	move_and_slide()

	# Make Camera_Controller match postion of Player
	cameraController.position = lerp(cameraController.position, position, CAMERA_SPEED)
