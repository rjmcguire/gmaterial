/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Devisualization (Richard Andrew Cattermole)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
module devisualization.gmaterial.opengl.controls.papersheet;
import devisualization.gmaterial.opengl.window;
import devisualization.gmaterial.opengl.shaders.papersheet;
import devisualization.gmaterial.opengl.defs;
import devisualization.gmaterial.interfaces.controls.papersheet;
import devisualization.gmaterial.interfaces.window;
import devisualization.scenegraph.interfaces;
import devisualization.window.interfaces.context;
import devisualization.window.interfaces.window;
import devisualization.image.color;

class PaperSheet : Element2D, IPaperSheet, SmartWindowElement.Type  {
	SmartWindowElement elements;

	private {
		IMaterialWindow window_;
	}

	/*
	 * Constructors
	 */

	@disable {
		this(Element element, float x, float y, float width, float height);
	}

	this(float x, float y, float width, float height) {
		super(PaperSheet.elementType, x, y, width, height);
	}

	/*
	 * Background color to default to
	 */
	@property {
		private Color_RGBA backgroundColor_;

		Color_RGBA backgroundColor() { return backgroundColor_; }
		void backgroundColor(Color_RGBA color) { backgroundColor_= color; }
	}

	/*
	 * Element type parts
	 * Can change the type id as needed
	 */
	@property static {
		private ushort elementTypeId;

		ushort elementType() { return elementTypeId; }
		void elementType(ushort id) { elementTypeId = id; }
	}

	void setWindow(IMaterialWindow window) {
		window_ = window;
		elements = new SmartWindowElement(window);

		IContext context = window.window.context;
		context.activate;
		
		auto parts = cachedOpenglParts(context);
		auto buffer = fullBufferCoordinates(context);
		auto vao = parts[0];
		auto shader = parts[1];

		window.graph.register(PaperSheet.elementType, (Element2D e) {
			with(e.to!PaperSheet) {
				vec2 position = vec2(x, (window.height - height) - y);
				vec4 size = vec4(width, height, window.width, window.height);
				
				// use the buffers
				buffer.bind();
				vao.bind();
				
				// configure the shader
				shader.bind();
				shader.position(position);
				shader.size(size);
				shader.myColor(backgroundColor_);
				shader.light(true, true);
				
				// draw
				glDrawArrays(Primitives.TriangleStrip, 0, 4);
			}
		});
	}
}

private {
	import std.typecons;
	import devisualization.util.opengl;
	import devisualization.gmaterial.opengl.controls.defs;
	
	Tuple!(VertexArray, PaperSheetShader) cachedOpenglParts(IContext context) {
		static __gshared VertexArray[IContext] vaos;
		static __gshared PaperSheetShader[IContext] shaders;
		
		if (context !in vaos) {
			vaos[context] = new VertexArray();
			
			shaders[context] = new PaperSheetShader;
			shaders[context].myVertices(vaos[context], fullBufferCoordinates(context));
		}
		
		return tuple(vaos[context], shaders[context]);
	}
}