const float PI = 3.14159265359;

mat2 getRotationMatrix(float t)
{
    float s = sin(t);
    float c = cos(t);
    return mat2(c,-s,s,c);
}


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

// Funkcja rysująca prostokąt o środku w punkcie center i wymiarach size
float rectangle(vec2 pt, vec2 size,vec2 center)
{
   // Przeskalowanie współrzędnych x  
   float ratio = iResolution.x/iResolution.y; 
   center.x *= ratio;
   size.x *= ratio;

   vec2 d = pt - center;
   vec2 halfSize = size/2.0;
    
   float horizontal = step(-halfSize.x,d.x) - step(halfSize.x,d.x);
   float vertical = step(-halfSize.y,d.y) - step(halfSize.y,d.y);
   return horizontal * vertical;
}

// Funkcja rysująca trójkąt o wierzchołkach a,b,c
float triangle(vec2 pt, vec2 a, vec2 b, vec2 c)
{
   // Przeskalowanie współrzędnych x  
   float ratio = iResolution.x/iResolution.y; 
   a.x *= ratio;
   b.x *= ratio;
   c.x *= ratio;

  
   
   // obliczanie współrzędnych barycentrycznych punktu P
   vec3 P = vec3(pt,0.0);
   vec3 A = vec3(a,0.0);
   vec3 B = vec3(b,0.0);
   vec3 C = vec3(c,0.0);
    
   vec3 v0 = C-A;
   vec3 v1 = B-A;
   vec3 v2 = P-A;
  
   float dot00 = dot(v0, v0);
   float dot01 = dot(v0, v1);
   float dot02 = dot(v0, v2);
   float dot11 = dot(v1, v1);
   float dot12 = dot(v1, v2);
   
   float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
   float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
   float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
 
   // Sprawdzenie, czy punkt należy do trójkąta
   if((u >= 0.0) && (v >= 0.0) && (u + v < 1.0))
   return 1.0;
 
   return 0.0;
}

// Funkcja rysująca pomocniczą siatkę
float grid(vec2 pt, vec2 fragCoord)
{
    float ratio = iResolution.x/iResolution.y;
    vec2 uv = fragCoord/iResolution.xy;
    
    float size = 1.0/10.0;  
    float edge = size/32.0; 
    uv = (mod(uv, size) - mod(uv - edge, size) - edge) * 1.0/size;
 
    if(length(uv) > edge)
    return 1.0;
    
    return 0.0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Współrzędne pikseli <0,1>
    vec2 uv = fragCoord/iResolution.xy;
    
    // zwiększanie współrzędniej x powoduje ruch ciężarówki
    // usuń komentarze z poniższych linijek aby zaobserwować ruch
    //uv.x +=iTime;
    //float count = 1.0;
    //uv.x = fract(uv.x * count);

    // Stosunek długości do wysokości wyświetlacza
    float ratio = iResolution.x/iResolution.y;

    // Przeskalowanie osi X "rozciąga" oś X na cały wyświetlacz
    uv.x *= ratio;
    
   
    // TU ZMIENIAJ WARTOŚCI promien I srodekKola
    // Rysowanie kół
    float promien = 0.1;
    vec2 srodekKola1 = vec2(0.1, 0.8);
    float inCircle1 = circle(uv,srodekKola1,promien);
    
    vec2 srodekKola2 = vec2(0.5, 0.8);
    float inCircle2 = circle(uv,srodekKola2,promien);
    
    // Rysowanie kwadratów
    vec2 rectSize1 = vec2(0.9,0.1);
    vec2 rectCenter1 = vec2(0.5,0.3);
    float inRect1 = rectangle(uv,rectSize1,rectCenter1);
    
    vec2 rectSize2 = vec2(0.7,0.4);
    vec2 rectCenter2 = vec2(0.6,0.5);
    float inRect2 = rectangle(uv,rectSize2,rectCenter2);
   
    // Rysowanie trójkąta
    vec2 a1 = vec2(0.05,0.35);
    vec2 b1 = vec2(0.25,0.7);
    vec2 c1 = vec2(0.25,0.35);
    float inTriangle1 = triangle(uv,a1,b1,c1);



    // Wyświetlanie - ustalenie koloru piksela
    vec3 color = vec3(0.0,0.0,0.0);
    
    color += vec3(1.0,0.0,0.0)* inRect1;
    color += vec3(1.0,0.0,0.0)* inRect2;

    color += vec3(0.0,1.0,0.0) * inCircle1;
    color += vec3(0.0,1.0,0.0) * inCircle2;
    
    color += vec3(0.0,0.0,1.0) * inTriangle1;

    // Wyświetl pomocniczą siatkę
    color += vec3(0.5,0.5,0.5)* grid(uv, fragCoord);
    
    fragColor = vec4(color,1.0);
}