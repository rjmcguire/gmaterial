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
module devisualization.gmaterial.opengl.shaders.papersheet;
import devisualization.util.opengl.shaders.defs;
import devisualization.util.opengl.vertexarray;
import devisualization.util.opengl.buffers;
import devisualization.image.color;
import gl3n.linalg : vec4, mat4;

/**
 * Renders vertices as a solid colour
 * 
 * Shader based upon https://github.com/fogleman/pg/blob/master/pg/programs.py
 */
class PaperSheetShader : ShaderProgram {
	this() {
		super("""
#if __VERSION__ > 120
    #version 130
    in vec4 position;
#else
    #version 120
    attribute vec4 position;
#endif

void main() {
    gl_Position = position;
}
""",
"""
#version 130
uniform vec2 location;
uniform vec4 size;
uniform vec4 color;

uniform bool keyLight;
uniform bool ambientLight;

#if __VERSION__ > 120
    out vec4 gl_FragColor;
#endif

float rand(vec2 co) { return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

void main() {
    bool inXTop = gl_FragCoord.x >= location.x;
    bool inYTop = gl_FragCoord.y >= location.y;
    bool inXBottom = gl_FragCoord.x <= location.x + size.x;
    bool inYBottom = gl_FragCoord.y <= location.y + size.y;

    float diffx = size.x * 0.05;
    float diffx3 = size.x * 0.15;
    float diffy = size.y * 0.05;
    float diffy2 = size.y * 0.25;
    float maxx = size.x * 0.9;
    float maxy = size.y * 0.9;
    
    bool pastXTop = gl_FragCoord.x > location.x + (size.x * 0.05);
    bool pastYTop = gl_FragCoord.y > location.y + (size.y * 0.05);
    bool pastXBottom = gl_FragCoord.x < location.x + (size.x * 0.95);
    bool pastYBottom = gl_FragCoord.y < location.y + (size.y * 0.95);

    if (inXTop && inYTop &&
        inXBottom && inYBottom) {
        if (pastXTop && pastYTop &&
            pastXBottom && pastYBottom) {
            gl_FragColor = color;
        } else {
            gl_FragColor = vec4(0, 0, 0, 0);

            if (keyLight) {
                float alpha = rand(vec2((diffy / (gl_FragCoord.y - location.y + maxy)), (diffx / (gl_FragCoord.x - location.x + maxx))));
                
                if (pastYBottom) {
                    alpha = ((gl_FragCoord.y - location.y) / diffy) - (alpha / 2);

                    if (!(pastXBottom && pastXTop)) {
                        alpha = 0;
                    }
                    
                    gl_FragColor = vec4(0, 0, 0, alpha);
                }
                
                if (!pastXTop) {
                    alpha = ((gl_FragCoord.x - location.x) / diffx3) - (alpha / 3);
                
                    if (!(pastYTop && pastYBottom) ||
                        distance(gl_FragCoord.xy, vec2(location.x, location.y + diffy)) < diffy) {
                        alpha = 0;
                    }
                    
                    gl_FragColor = vec4(0, 0, 0, alpha);
                }
            }
            
            if (ambientLight) {
                float alpha = 0;
            
                if (!pastYBottom) {
                    if (gl_FragCoord.y < location.y + (size.y * 0.96) &&
                        gl_FragCoord.x > location.x + diffx &&
                        gl_FragCoord.x < location.x + size.x - diffx &&
                        distance(gl_FragCoord.xy, vec2(location.x + diffx, location.y + size.y)) > diffx) {
                        alpha = 1;
                    }
                }
                
                if (!pastXBottom) {
                    if (gl_FragCoord.x < location.x + (size.x * 0.96) &&
                        gl_FragCoord.y > location.y + diffy &&
                        gl_FragCoord.y < location.y + size.y - diffy) {
                        alpha = 1;
                    }
                }
                
                if (alpha > 0) {
                    gl_FragColor = vec4(0, 0, 0, alpha);
                }
            }
        }
    } else {
        gl_FragColor = vec4(0, 0, 0, 0);
    }
}
""");
	}
	
	@disable {
		this(string vert, string frag=null, string geom=null){}
		this(Shader vert = null, Shader frag = null, Shader geom = null){}
	}

	@property {
		void position(vec2 v) {
			uniform("location", v);
		}
		
		void size(vec4 m) {
			uniform("size", m);
		}

		void myColor(Color_RGBA c) {
			uniform("color", vec4(c.r, c.g, c.b, c.a));
		}

		void light(bool key, bool ambient) {
			uniform("keyLight", key);
			uniform("ambientLight", ambient);
		}
		
		void myVertices(VertexArray vao, IBuffer buffer) {
			import devisualization.util.opengl.function_wrappers.v20 : AttribPointerType;
			vao.bindAttribute(this, "position", buffer, AttribPointerType.Float, 2);
		}
	}
}