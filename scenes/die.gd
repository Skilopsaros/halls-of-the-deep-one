extends Sprite2D

@onready var animation_player = $AnimationPlayer

		
func roll() -> int:
	var sides : Array[int] = [0,1,2,3,4,5]
	sides.shuffle()
	var key = ""
	for n in sides:
		key+= str(n)
	# var animation : Animation = animation_player.get_animation("roll")
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:frame")
	#var track_index : int = animation.find_track(".:frame", Animation.TYPE_VALUE)
	for i in range(len(sides)):
			animation.track_insert_key(track_index,0.20*i,sides[i])
			
	animation_player.get_animation_library("").add_animation(key, animation)
	animation_player.current_animation = key
	animation_player.play()
	return(sides[5]+1)
