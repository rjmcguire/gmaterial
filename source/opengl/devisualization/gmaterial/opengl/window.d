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
import devisualization.gmaterial.opengl.layout;
import devisualization.gmaterial.interfaces.window;
import devisualization.gmaterial.interfaces.layout;
import devisualization.gmaterial.interfaces.styles;
import devisualization.scenegraph.interfaces;
import devisualization.window.interfaces.window;

class MaterialWindow : IMaterialWindow {
    private {
        Windowable self;
        SceneGraph2D graph_;
        Layout layout_;
        MaterialAppStyle style_;
    }

    alias self this;

    /**
     * Creates a new window given the size.
     * Runs the event loop.
     */
    this(uint width, uint height) {
        import devisualization.window.window;
        import devisualization.window.interfaces.context;

        self = new Window(width, height, ""w, 0, 0, WindowContextType.Opengl3Plus);
        self.show();

        commonSetup1();
        commonSetup2();
        checkSetup();

        Window.messageLoop();
    }

    /**
     * Given a window with a valid OpenGL context create the instance.
     * Does not run the event loop on the window. That's user code.
     */
    this(Windowable window) {
        self = window;
        
        commonSetup1();
        commonSetup2();
        checkSetup();
    }

    /**
     * Given both an already created window with OpenGL context and a 2D compaitble scenegraph create the instance.
     * Does not run the event loop on the window. That's user code.
     */
    this(Windowable window, SceneGraph2D graph) {
        self = window;
        graph_ = graph;

        commonSetup2();
        checkSetup();
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
    }

    private {
        void commonSetup1() {
            import devisualization.scenegraph.base.overlayed;
            // this should be replaced with a 2d specific one. Aka one that doesn't support 3d.
            SceneGraph3DOverlayed2D graph = new SceneGraph3DOverlayed2D(self);
            graph.clearBuffers = () {
                import devisualization.util.opengl.function_wrappers;
                glClear(false, true, false);
            };
            graph_ = graph;
        }

        void commonSetup2() {
            layout_ = new Layout;
            style_ = new MaterialAppStyle;
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
}