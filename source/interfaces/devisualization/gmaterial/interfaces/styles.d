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
module devisualization.gmaterial.interfaces.styles;
import devisualization.image;

class MaterialAppStyle {
    /*
     * Commonly modified / wanted colours
     */

    Color_RGBA primary_hue1; // 500 colour
    Color_RGBA primary_hue2; // 100 colour
    Color_RGBA primary_hue3; // 700 colour

    Color_RGBA accent; // 200 colour
    Color_RGBA accent_fallback1; // 100 colour
    Color_RGBA accent_fallback2; // 400 colour

    /**
     * We can just use this for storage.
     * Fields can be null.
     */
    this() {}

    this(string primary = "Indigo", string accentName = "Pink") {
        primary_hue1 = *palette.lookup(primary ~ " 500 - Primary");
        primary_hue2 = *palette.lookup(primary ~ " 100");
        primary_hue3 = *palette.lookup(primary ~ " 700");

        accent = *palette.lookup(accentName ~ " A200");
        accent_fallback1 = *palette.lookup(accentName ~ " A100");
        accent_fallback2 = *palette.lookup(accentName ~ " A400");
    }

    @property {
        Color_RGBA primary() {
            return primary_hue1;
        }

        /**
         * If we want to use custom colours not based upon the spec.
         * Use this to grab the palette.
         */
        ACOPalette colorPaletteUsed() {
            return palette;
        }
    }

    /**
     * These colours can be modified, but proberbly shouldn't be.
     */

    Color_RGBA black_Dividers = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max*0.12));
    Color_RGBA black_Disabled_HintText = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max*0.26));
    Color_RGBA black_SecondaryText_Icons = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max*0.54));
    Color_RGBA black_Text = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max*0.87));
    float black_activeIconsAlpha = 0.54;
    float black_inactiveIconsAlpha = 0.26;

    Color_RGBA white_Dividers = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max*0.12));
    Color_RGBA white_Disabled_HintText = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max*0.30));
    Color_RGBA white_SecondaryText = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max*0.70));
    Color_RGBA white_Text_Icons = Color_RGBA.fromUbyte(0, 0, 0, cast(ubyte)(ubyte.max));
    float white_activeIconsAlpha = 1.00;
    float white_inactiveIconsAlpha = 0.30;
}

private {
    import devisualization.util.photoshop_aco;
    /*
     * Basically a palette provided from Google as part of the Material spec
     *     is compiled into the program (~60kb once bin2d'd) which is used.
     * Not swapable.
     */
    __gshared ACOPalette palette;

    shared static this() {
        import devisualization.gmaterial.resources;
        palette = ACOPalette.parse(Material_Palette_aco);
    }
}
