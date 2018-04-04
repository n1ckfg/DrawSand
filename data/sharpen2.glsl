// https://r3dux.org/2011/06/glsl-image-processing/

#version 330

uniform sampler2D quadTexture;
uniform int       filterNumber;
uniform vec2      tcOffset[25]; // Texture coordinate offsets

in vec2 vTex;

out vec4 vFragColour;

void main(void)
{
    // Standard
    if (filterNumber == 0)
    {
        vFragColour = texture2D(quadTexture, vTex);
    }

    // Greyscale
    if (filterNumber == 1)
    {
        // Convert to greyscale using NTSC weightings
        float grey = dot(texture2D(quadTexture, vTex).rgb, vec3(0.299, 0.587, 0.114));

        vFragColour = vec4(grey, grey, grey, 1.0);
    }

    // Sepia tone
    if (filterNumber == 2)
    {
        // Convert to greyscale using NTSC weightings
        float grey = dot(texture2D(quadTexture, vTex).rgb, vec3(0.299, 0.587, 0.114));

        // Play with these rgb weightings to get different tones.
        // (As long as all rgb weightings add up to 1.0 you won't lighten or darken the image)
        vFragColour = vec4(grey * vec3(1.2, 1.0, 0.8), 1.0);
    }

    // Negative
    if (filterNumber == 3)
    {
        vec4 texMapColour = texture2D(quadTexture, vTex);

        vFragColour = vec4(1.0 - texMapColour.rgb, 1.0);
    }

    // Blur (gaussian)
    if (filterNumber == 4)
    {
        vec4 sample[25];

        for (int i = 0; i < 25; i++)
        {
            // Sample a grid around and including our texel
            sample[i] = texture(quadTexture, vTex + tcOffset[i]);
        }

        // Gaussian weighting:
        // 1  4  7  4 1
        // 4 16 26 16 4
        // 7 26 41 26 7 / 273 (i.e. divide by total of weightings)
        // 4 16 26 16 4
        // 1  4  7  4 1

            vFragColour = (
                       (1.0  * (sample[0] + sample[4]  + sample[20] + sample[24])) +
                       (4.0  * (sample[1] + sample[3]  + sample[5]  + sample[9] + sample[15] + sample[19] + sample[21] + sample[23])) +
                       (7.0  * (sample[2] + sample[10] + sample[14] + sample[22])) +
                       (16.0 * (sample[6] + sample[8]  + sample[16] + sample[18])) +
                       (26.0 * (sample[7] + sample[11] + sample[13] + sample[17])) +
                       (41.0 * sample[12])
                       ) / 273.0;

    }

    // Blur (mean filter)
    if (filterNumber == 5)
    {
        vFragColour = vec4(0.0);

        for (int i = 0; i < 25; i++)
        {
            // Sample a grid around and including our texel
            vFragColour += texture(quadTexture, vTex + tcOffset[i]);
        }

        // Divide by the number of samples to get our mean
        vFragColour /= 25;
    }

    // Sharpen
    if (filterNumber == 6)
    {
        vec4 sample[25];

        for (int i = 0; i < 25; i++)
        {
            // Sample a grid around and including our texel
            sample[i] = texture(quadTexture, vTex + tcOffset[i]);
        }

        // Sharpen weighting:
        // -1 -1 -1 -1 -1
        // -1 -1 -1 -1 -1
        // -1 -1 25 -1 -1
        // -1 -1 -1 -1 -1
        // -1 -1 -1 -1 -1

            vFragColour = 25.0 * sample[12];

        for (int i = 0; i < 25; i++)
        {
            if (i != 12)
                vFragColour -= sample[i];
        }
    }

    // Dilate
    if (filterNumber == 7)
    {
        vec4 sample[25];
        vec4 maxValue = vec4(0.0);

        for (int i = 0; i < 25; i++)
        {
            // Sample a grid around and including our texel
            sample[i] = texture(quadTexture, vTex + tcOffset[i]);

            // Keep the maximum value       
            maxValue = max(sample[i], maxValue);
        }

        vFragColour = maxValue;
    }

    // Erode
    if (filterNumber == 8)
    {
        vec4 sample[25];
        vec4 minValue = vec4(1.0);

        for (int i = 0; i < 25; i++)
        {
            // Sample a grid around and including our texel
            sample[i] = texture(quadTexture, vTex + tcOffset[i]);

            // Keep the minimum value       
            minValue = min(sample[i], minValue);
        }

        vFragColour = minValue;
    }

    // Laplacian Edge Detection (very, very similar to sharpen filter - check it out!)
    if (filterNumber == 9)
    {
        vec4 sample[25];

        for (int i = 0; i < 25; i++)
        {
            // Sample a grid around and including our texel
            sample[i] = texture(quadTexture, vTex + tcOffset[i]);
        }

        // Laplacian weighting:
        // -1 -1 -1 -1 -1
        // -1 -1 -1 -1 -1
        // -1 -1 24 -1 -1
        // -1 -1 -1 -1 -1
        // -1 -1 -1 -1 -1

            vFragColour = 24.0 * sample[12];

        for (int i = 0; i < 25; i++)
        {
            if (i != 12)
                vFragColour -= sample[i];
        }
    }
}