﻿/*
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
module devisualization.gmaterial.interfaces.window;
import devisualization.gmaterial.interfaces.layout;
import devisualization.gmaterial.interfaces.styles;
import devisualization.window.interfaces.window;
import devisualization.window.interfaces.eventable;
import devisualization.scenegraph.interfaces;

interface IMaterialWindow {
	//this(uint width, uint height);
	//this(Windowable window, uint width, uint height);
	//this(Windowable window, uint width, uint height, SceneGraph2D graph);

    @property {
        ILayout layout();
        SceneGraph2D graph();
        Windowable window();
        MaterialAppStyle appStyle();

		uint width();
		uint height();
    }

	void showAndRun(ushort tickSleep = 25);

	mixin IEventing!("onFirstDraw", Windowable);
}

alias WindowIsNotMaterialUsable = Exception;