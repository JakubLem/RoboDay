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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Współrzędne pikseli <0,1>
    vec2 uv = fragCoord/iResolution.xy;
    
    // Stosunek długości do wysokości wyświetlacza
    float ratio = iResolution.x/iResolution.y;

    // Przeskalowanie osi X "rozciąga" oś X na cały wyświetlacz
    uv.x *= ratio;
    
    // Rysowanie kół
    float radius = 0.1;
    vec2 circleCenter1 = vec2(0.5, 0.5);
    float inCircle1 = circle(uv, circleCenter1, radius);
    
    // Dodaj drugie koło
    float radius2 = 0.1;
    vec2 circleCenter2 = vec2(0.75, 0.75);
    float inCircle2 = circle(uv, circleCenter2, radius2);

    // Rysowanie prostokąta (nadwozie samochodu)
    vec2 rectCenter = vec2(0.25, 0.25);
    vec2 rectSize = vec2(0.5, 0.25);
    float inRect = step(rectCenter.x - rectSize.x / 2.0, uv.x) * step(rectCenter.y - rectSize.y / 2.0, uv.y) *
                   step(uv.x, rectCenter.x + rectSize.x / 2.0) * step(uv.y, rectCenter.y + rectSize.y / 2.0);
    
    // Kolor koła 1
    vec3 color1 = vec3(1.0, 0.0, 0.0);
    
    // Kolor koła 2
    vec3 color2 = vec3(0.0, 1.0, 0.0);
    
    // Kolor prostokąta
    vec3 color3 = vec3(0.0, 0.0, 1.0);
    
    vec3 color = color1 * inCircle1 + color2 * inCircle2 + color3 * inRect;
    
    fragColor = vec4(color, 1.0);
}

