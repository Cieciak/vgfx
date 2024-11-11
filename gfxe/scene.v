module gfxe

@[heap]
pub struct Scene{
	mut:
		layers []Layer
}

pub fn (sc Scene) flatten() []Drawable{
	mut candidates := []Drawable{}

	for lr in sc.layers{
		for ob in lr.objects{
			match ob {
				SimpleStruct{
					println("Simple ${ob}")
					candidates << Drawable{
						obj: ob.s
						cst: ob.s.cost()
					}
				}
				ComplexStruct{
					println("Complex ${ob}")
					for c in ob.c.flatten(){
						candidates << Drawable{
							obj: c,
							cst: c.cost(),
						}
					}
				}
			}
		}
	}

	return candidates
}

pub fn (mut sc Scene) add_layer(lr Layer){
	sc.layers << lr
}