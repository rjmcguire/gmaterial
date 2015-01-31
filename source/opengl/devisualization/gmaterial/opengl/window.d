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
module devisualization.gmaterial.opengl.window;
import devisualization.gmaterial.opengl;
import devisualization.gmaterial.interfaces;
import devisualization.scenegraph.interfaces;
import devisualization.window.interfaces.window;
import devisualization.window.interfaces.eventable;

class MaterialWindow : IMaterialWindow {
    private {
        SceneGraph2D graph_;
        Layout layout_;
        MaterialAppStyle style_;

		uint width_, height_;
    }

	Windowable self;
    alias self this;

    /**
     * Creates a new window given the size.
     * Runs the event loop.
     */
    this(uint width, uint height) {
        import devisualization.window.window;
        import devisualization.window.interfaces.context;

		width_ = width;
		height_ = height;

        self = new Window(width, height, ""w, 0, 0, WindowContextType.Opengl3Plus);

        commonSetup1();
        commonSetup2();
        //checkSetup();
    }

    /**
     * Given a window with a valid OpenGL context create the instance.
     * Does not run the event loop on the window. That's user code.
     */
	this(Windowable window, uint _width, uint _height) {
        self = window;
		width_ = _width;
		height_ = _height;
        
        commonSetup1();
        commonSetup2();
        //checkSetup();
    }

    /**
     * Given both an already created window with OpenGL context and a 2D compaitble scenegraph create the instance.
     * Does not run the event loop on the window. That's user code.
     * 
     * You will need to configure the graph to auto set the window on 2d elements
     */
	this(Windowable window, uint _width, uint _height, SceneGraph2D graph) {
        self = window;
		width_ = _width;
		height_ = _height;
		graph_ = graph;

        commonSetup2();
        checkSetup();
    }

	void showAndRun(ushort tickSleep = 25) {
		import devisualization.window.window;
		self.show;

		while(true) {
			import core.thread : Thread;
			import core.time : dur;
			Window.messageLoopIteration();
			
			IContext context = self.context;
			if (self.hasBeenClosed)
				break;
			else if (context !is null) {
				self.onDraw;
			}

			if (tickSleep > 0)
				Thread.sleep(dur!"msecs"(tickSleep));
		}
	}

    @property {
        Windowable window() {
            return self;
        }

        SceneGraph2D graph() {
            return graph_;
        }

        ILayout layout() {
            return layout_;
        }

        MaterialAppStyle appStyle() {
            return style_;
        }

		uint width() { return width_; }
		uint height() { return height_; }
    }

    private {
        void commonSetup1() {
            import devisualization.scenegraph.base.overlayed;
            // this should be replaced with a 2d specific one. Aka one that doesn't support 3d.

			alias gthis = this;

			class MyRoot2d : Element2D {
				this() {
					super(0, 0, 0, 0, 0);
					elements = new SmartWindowElement(gthis);
				}
			}

			class MyGraph : SceneGraph3DOverlayed2D {
				this() {
					super(self);
					root_2d = new MyRoot2d;
				}
			}

			MyGraph graph = new MyGraph;

            graph.clearBuffers = () {
                import devisualization.util.opengl.function_wrappers;
                glClear(false, true, false);
            };
            graph_ = graph;
        }

        void commonSetup2() {
            layout_ = new Layout;
            style_ = new MaterialAppStyle;

			void FirstResizeFunc(Windowable, uint w, uint h) {
				width_ = w;
				height_ = h;
			}
			self.addOnResize(&FirstResizeFunc);

			void FirstDrawHook(Windowable) {
				import devisualization.util.opengl;
				self.removeOnDraw(&FirstDrawHook);

				self.context.activate;

				self.addOnDraw((Windowable) {
					glClearColor(1, 1, 1, 1);
					glClear(true,true, true);
					
					glEnable(EnableFunc.Blend);
					glBlendFunc(BlendFactors.SrcAlpha, BlendFactors.OneMinusSrcAlpha);
					
					graph_.draw;
					self.context.swapBuffers;
				});

				self.addOnResize((Windowable, uint w, uint h) {
					glViewport(0, 0, w, h);

					width_ = w;
					height_ = h;
				});

				self.removeOnResize(&FirstResizeFunc);
				onFirstDraw(this);
			}
	
			self.addOnDraw(&FirstDrawHook);
        }

        void checkSetup() {
            import devisualization.window.interfaces.context;
        
            if (self.context !is null && self.context.type == WindowContextType.Opengl3Plus) {
            } else {
                throw new WindowIsNotMaterialUsable("Opengl context (3+) has not already been created.");
            }

            if (graph_ !is null) {
            } else {
                throw new WindowIsNotMaterialUsable("No 2d graph type supplied.");
            }
        }
    }

	mixin Eventing!("onFirstDraw", Windowable);
}