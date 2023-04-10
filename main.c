#include <stdio.h>
#include <math.h>

#define N 100
#define PI 3.14285714285714
#define FILTER_ORDER 8

const int Freq[3] = {1000,0,0};
const int Ampl[3] = {1,0,0};
const int Phase[3] = {0,0,0};

const int SamplingFreq = 22050;

const float a[FILTER_ORDER+1] = {     1,-4.6414, 11.0316, -16.8431, 17.8249, -13.3024, 6.8295, -2.2142, 0.3514};
const float b[FILTER_ORDER+1] = {0.0001, 0.0010,  0.0035,   0.0071,  0.0088,   0.0071, 0.0035,  0.0010, 0.0001};

float InputSignal[N + FILTER_ORDER];
float OutputSignal[N + FILTER_ORDER];

int main()
{
    int i,j,k;
    float Ts;
    float nT;
    
    Ts = 1.0 / SamplingFreq;
    
    for(i = 0; i < FILTER_ORDER; i++)
    {
        InputSignal[i] = 0;
        OutputSignal[i] = 0;
    }
    
    for(i = FILTER_ORDER; i < FILTER_ORDER + N; i++)
    {
        nT = (i-FILTER_ORDER+1) * Ts;
        InputSignal[i] = Ampl[0] * sin(2*PI*Freq[0]*nT + Phase[0]) + Ampl[1] * sin(2*PI*Freq[1]*nT + Phase[1]) + Ampl[2] * sin(2*PI*Freq[2]*nT + Phase[2]);
        //printf("ID[%d] = %f\n", i, InputSignal[i]);
    }

    for(i = FILTER_ORDER; i < FILTER_ORDER + N; i++)
    {
        for(j = 0; j < FILTER_ORDER + 1; j++)
        {
            OutputSignal[i] += (b[j] * InputSignal[i - j]);
        }
        
        for(k = 1; k < FILTER_ORDER + 1; k++)
        {
            OutputSignal[i] -= (a[k] * OutputSignal[i - k]);
        }
        
        OutputSignal[i] *= (1.0/a[0]);
        
        printf("%f\n", OutputSignal[i]);
    }
    return 0;
}
