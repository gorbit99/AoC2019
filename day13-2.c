#include <stdio.h>
#include <stdbool.h>

#define SDL_MAIN_HANDLED

#include <SDL2\SDL.h>

long long relativeBase = 0;
int ip = 0;
long long code[1000000];

int powTen(int a) {
    int ans = 1;
    for (int i = 0; i < a; i++)
        ans *= 10;
    return ans;
}

long long getValue(long long pos) {
    long long inst = code[ip];
    long long arg = code[ip + pos + 1];
    int mode = (inst / powTen(pos + 2)) % 10;
    switch (mode)
    {
    case 0:
        return code[arg];
    case 1:
        return arg;
    case 2:
        return code[arg + relativeBase];

    default:
        break;
    }
    return 0;
}

void putValue(long long pos, long long val, long long arg) {
    long long inst = code[ip];
    int mode = (inst / powTen(pos + 2)) % 10;
    switch (mode)
    {
    case 0:
        code[arg] = val;
        break;
    case 2:
        code[arg + relativeBase] = val;

    default:
        break;
    }
}

int outIndex = 0;
int outPos[2];
unsigned int colors[] = {0x000000ff, 0xffffffff, 0x00ff00ff, 0xff0000ff, 0x0000ffff};

int main(int argc, char **argv) {
    for (int i = 0; i < (sizeof(code) / sizeof(code[0])); i++)
        code[i] = 0;

    FILE *file = fopen("day13code.txt", "rt");
    int index = 0;
    while (fscanf(file, "%I64d,", &code[index]) == 1)
        index++;
    
    /*SDL_Init(SDL_INIT_EVERYTHING);
    SDL_Window *window = SDL_CreateWindow("Day 13-2", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 400, 600, SDL_WINDOW_SHOWN);
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);


    SDL_Texture *screen = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ABGR32, SDL_TEXTUREACCESS_STREAMING, 50, 75);
    */code[0] = 2;
    long long joyState = 0;
    int score = 0;
    bool quit = false;
    
        int paddlePos;
        int ballPos;
    while (!quit) {
        int *pixels;
        int pitch;
        //SDL_LockTexture(screen, NULL, &pixels, &pitch);
        /*SDL_Event event;
        while (SDL_PollEvent(&event)) {
            switch (event.type)
            {
            case SDL_QUIT:
                quit = true;
                break;
            case SDL_KEYDOWN:
                if (event.key.keysym.sym == SDLK_LEFT && event.key.repeat == 0)
                    joyState -= 1;
                if (event.key.keysym.sym == SDLK_RIGHT && event.key.repeat == 0)
                    joyState += 1;
                break;
            case SDL_KEYUP:
                if (event.key.keysym.sym == SDLK_LEFT && event.key.repeat == 0)
                    joyState += 1;
                if (event.key.keysym.sym == SDLK_RIGHT && event.key.repeat == 0)
                    joyState -= 1;
                break;
            default:
                break;
            }
        }*/
        if (paddlePos < ballPos)
            joyState = 1;
        if (paddlePos > ballPos)
            joyState = -1;
        if (paddlePos == ballPos)
            joyState = 0;
        switch (code[ip] % 100)
        {
        case 1: {
            long long a = getValue(0);
            long long b = getValue(1);
            putValue(2, a + b, code[ip + 3]);
            ip += 4;
            break;
        }
        case 2: {
            long long a = getValue(0);
            long long b = getValue(1);
            putValue(2, a * b, code[ip + 3]);
            ip += 4;
            break;
        }
        case 3: {
            putValue(0, joyState, code[ip + 1]);
            ip += 2;
            break;
        }
        case 4: {
            long long c = getValue(0);
            switch (outIndex)
            {
            case 0:
                outPos[0] = c;
                break;
            case 1:
                outPos[1] = c;
                break;
            case 2: {
                if (outPos[0] == -1) {
                    printf("%d\n", c);
                } else {
                    int pos = outPos[1] * 50 + outPos[0];
                    //pixels[pos] = colors[c];
                    if (c == 4)
                        ballPos = outPos[0];
                    if (c == 3)
                        paddlePos = outPos[0];
                }
                break;
            }
            default:
                break;
            }
            outIndex = (outIndex + 1) % 3;
            ip += 2;
            break;
        }
        case 5: {
            long long val = getValue(0);
            long long pos = getValue(1);
            if (val != 0)
                ip = pos;
            else
                ip += 3;
            break;
        }
        case 6: {
            long long val = getValue(0);
            long long pos = getValue(1);
            if (val == 0)
                ip = pos;
            else
                ip += 3;
            break;
        }
        case 7: {
            long long a = getValue(0);
            long long b = getValue(1);
            putValue(2, a < b, code[ip + 3]);
            ip += 4;
            break;
        }
        case 8: {
            long long a = getValue(0);
            long long b = getValue(1);
            putValue(2, a == b ? 1 : 0, code[ip + 3]);
            ip += 4;
            break;
        }
        case 9: {
            long long val = getValue(0);
            relativeBase += val;
            ip += 2;
            break;
        }
        case 99:
            break;
        default:
            return 1;
            break;
        }
        /*SDL_UnlockTexture(screen);
        SDL_RenderCopy(renderer, screen, NULL, NULL);
        SDL_RenderPresent(renderer);*/
    }

    return 0;
}