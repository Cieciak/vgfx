module gfxe

import gg
import gx
 
// Objects without internal structure
pub interface Simple{
	cost() int
	draw(mut GFXEngine)
}

// These can contain references to other objects
pub interface Complex{
	cost() int
	flatten() []Simple
}

struct Drawable{
	obj Simple
	cst int
}

// Getting around language limitation
struct SimpleStruct{s Simple}
struct ComplexStruct{c Complex}
type LayerObject = SimpleStruct | ComplexStruct

pub struct GFXEngine{
	mut:
		gg &gg.Context = &gg.Context{}
		sc &Scene      = &Scene{}
}

pub fn new_gfxe() &GFXEngine{
	mut ge := &GFXEngine{}

	ge.gg = gg.new_context(
		window_title: "Vlang GFX"
		bg_color:     gx.black
		width:        600
		height:       600
		frame_fn:     frame
		sample_count: 2
		user_data: ge
	)
	ge.sc = &Scene{}

	return ge
}

pub fn (mut ge GFXEngine) run(){ge.gg.run()}

pub fn (ge GFXEngine) get_ctx() &gg.Context{return ge.gg}

pub fn (mut ge GFXEngine) set_scene(sc &Scene){ge.sc = sc}

fn frame(mut ge GFXEngine){
    // Clear screen
	ge.gg.begin()
	ge.gg.end()

	// Get all drawable objects
	objects := ge.sc.flatten()
	println("List ${objects}")
	for drawable in objects{
		drawable.obj.draw(mut ge)
	}

	// Show FPS
	ge.gg.begin()
	ge.gg.show_fps()
	ge.gg.end(how: .passthru)
}