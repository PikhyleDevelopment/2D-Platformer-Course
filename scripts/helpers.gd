extends Node

## Functions
func apply_camera_shake(percentage):
	# Grab objects in the "camera" group.
	var cameras = get_tree().get_nodes_in_group("camera")
	if (cameras.size() > 0):
		# If we have a camera (we should or something is very wrong)
		# apply shake to that camera.
		cameras[0].apply_shake(percentage)
