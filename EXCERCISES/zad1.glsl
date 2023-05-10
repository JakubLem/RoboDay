// Funkcja rysująca koło o środku w punkcie center i promieniu radius
float circle(vec2 pt, vec2 center, float radius)
{
    // Przeskalowanie współrzędnych x  
    float ratio = iResolution.x/iResolution.y; 
    center.x *= ratio;
    vec2 d = pt - center;

    if(radius >= length(d))
    {
        return 1.0;
    }
    else
    {
        return 0.0;
    }
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float ratio = iResolution.x / iResolution.y;
    uv.x *= ratio;

    // Koło
    float circleRadius = 0.1;
    vec2 circleCenter = vec2(0.25, 0.5);
    float inCircle = circle(uv, circleCenter, circleRadius);

    // Prostokąt
    vec2 rectCenter = vec2(0.5, 0.5);
    vec2 rectSize = vec2(0.3, 0.1);
    float inRect = step(rectCenter.x - rectSize.x / 2.0, uv.x) * step(rectCenter.y - rectSize.y / 2.0, uv.y) *
                   step(uv.x, rectCenter.x + rectSize.x / 2.0) * step(uv.y, rectCenter.y + rectSize.y / 2.0);

    // Trójkąt z prostokątów
    float rectWidth = 0.02;
    float rectHeight = 0.1;
    vec2 rect1Center = vec2(0.75, 0.5 - rectHeight / 2.0);
    vec2 rect2Center = vec2(0.75 + rectWidth / 2.0, 0.5);
    float inRect1 = step(rect1Center.x - rectWidth / 2.0, uv.x) * step(rect1Center.y - rectHeight / 2.0, uv.y) *
                    step(uv.x, rect1Center.x + rectWidth / 2.0) * step(uv.y, rect1Center.y + rectHeight / 2.0);
    float inRect2 = step(rect2Center.x - rectWidth / 2.0, uv.x) * step(rect2Center.y - rectHeight / 2.0, uv.y) *
                    step(uv.x, rect2Center.x + rectWidth / 2.0) * step(uv.y, rect2Center.y + rectHeight / 2.0);

    // Kolory figur
    vec3 circleColor = vec3(1.0, 0.0, 0.0);
    vec3 rectColor = vec3(1.0, 0.0, 0.0);
    vec3 triangleColor = vec3(1.0, 0.0, 0.0);

    vec3 color = circleColor * inCircle + rectColor * inRect + triangleColor * (inRect1 + inRect2);
    fragColor = vec4(color, 1.0);
}
