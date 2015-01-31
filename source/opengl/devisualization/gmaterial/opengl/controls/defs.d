module devisualization.gmaterial.opengl.controls.defs;
import devisualization.window.interfaces.context;
import devisualization.util.opengl;
import gl3n.linalg : vec2;

StandardBuffer fullBufferCoordinates(IContext context) {
	static __gshared StandardBuffer[IContext] buffers;
	
	if (context !in buffers) {
		buffers[context] = new StandardBuffer(vec2(-1, 1), vec2(1, 1),
										  vec2(-1, -1), vec2(1, -1));
	}
	
	return buffers[context];
}