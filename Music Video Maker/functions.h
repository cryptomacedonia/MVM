//
//  functions.h
//  Woowave
//
//  Created by igor on 1/5/15.
//  Copyright (c) 2015 Woowave ltd. All rights reserved.
//


#pragma once
#include <stdio.h>

#include <Eigen/dense>
#include <iostream>
#include <vector>
#include <fstream>
#include <map>

#include <ostream>
#include <istream>
#include <sys/stat.h>
#include <iterator>
//#include "sndfile.hh"
#include <Eigen/unsupported/Eigen/FFT>
//#include <utf8.h>
#include <algorithm>

using namespace Eigen;
using namespace std;
extern "C"
{
typedef Matrix< unsigned long long,-1,-1,0,-1,-1> MatrixXLI;
    
    
}
// typedef void(^BlockHandlerMATRIXXLI)(MatrixXLI retMatrixXLI);


class CPP_asset                   // begin declaration of the class
{
public:                    // begin public section
    CPP_asset(char * mediaFilePath ,int strength);     // constructor
    ~CPP_asset();
    char * filePath;
    MatrixXLI maxes;
    vector<char *>  waveFiles;
    char * maxesBinaryFile;
    vector<CPP_asset> * matchedMedia;
    float durationOfTheFile;
    float strength;
    void  getPeaks(float strength);
    void getAudiofromMedia(char * url, char * saveLocation);
private:                   // begin private section
};
extern "C"
{
typedef struct
{
    unsigned long long frejm;
    unsigned long long hashot;
}par;
typedef struct
{
    int positionInBigger;
    int offset;
    int freq;
    
}
rezultPair;
}



bool sporedioffset(const par &a, const par &b);
bool sporedi2(const rezultPair &a, const rezultPair &b);
bool sporedi(const par &a, const par &b);
vector<par> getInter( vector<par> left,  vector<par> right);
//#if defined(WOOWAVELIB_LIBRARY)
//#  define WOOWAVELIBSHARED_EXPORT Q_DECL_EXPORT
//#else
//#  define WOOWAVELIBSHARED_EXPORT Q_DECL_IMPORT
//#endif
MatrixXLI  final_sredi( Map<VectorXf> * data, long sampleCount,float a_dec,float targetdf,float targetdt,int slide,int fragmentStartFrame);
MatrixXf final_specgram(Map<VectorXf> * framesData, int samplesCount,int slide);
VectorXf Spread2(VectorXf X,int Q);
VectorXf igor_max_zerovec(VectorXf vec1,VectorXf vec2);
void igor_max_zerovecArray(VectorXf vec1,VectorXf vec2,float results[]);

VectorXf igor_max_vec(VectorXf vec1,VectorXf vec2);
VectorXf loc_max(VectorXf red,std::vector<int> *in);
VectorXf zalepi_vec(VectorXf vec1,VectorXf vec2);
vector<par> getPeaks_CPP(float * framesData,long sampleCount, float strength,int fragmentStartFrame,float targetF,float targetD);
vector<int> getduplicates(vector<int> IntVect);
vector<rezultPair> proveri(MatrixXLI bigger,MatrixXLI smaller);
void writeVector(vector<int> reference);
vector<int> readVector();
int exists(const char *fname);


MatrixXLI proccessWavData(void * wavData,size_t numberOfSamples,float strength,size_t buffSizeInSamples,size_t * returnSize,float targetF,float targetD);
vector<par> proccessWavDataPAR(void * wavData,size_t numberOfSamples,float strength,size_t buffSizeInSamples,size_t * returnSize,float targetF,float targetD);
vector<rezultPair> proveri_new(vector<par> left,vector<par> right,size_t leftDurationInFrames,size_t rightDurationinFrames,float * returnedOffset,float * returnedStrength,float * variance);
vector<rezultPair> mostfrequentnumbers(vector<rezultPair>  array);
double variance ( vector<rezultPair> v , int offsetInFrames, int startInBigFile, int endinBigFile);
void writeMatrixWithMetadata(char *  filePath, vector<par> markers, char * metadata,unsigned long long metadataSizeInBytes,unsigned long long numberOfSamples);
vector<par> readMatrixWithMetadata(char *  filePath,char * metadata, unsigned long long * numberOfSamples);
double varianceNew ( vector<rezultPair> v , int offsetInFrames, int startInBigFile, int endinBigFile);

class   composeints
{
public:
    static  unsigned long long composeInts(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z);
    static void decomposeInts( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z);
    static  unsigned long long composeInts2(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z);
    static void decomposeInts2( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z);
    static unsigned long long composeInts3(const unsigned long long& poz, const unsigned long long&id_1, const unsigned long long&id_2,const unsigned long long&offset);
    static void decomposeInts3( unsigned long long composed,  unsigned long long & poz, unsigned long long &id_1, unsigned long long &id_2, unsigned long long &offset);
};

unsigned long long composeInts(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z);
void decomposeInts( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z);
unsigned long long composeInts2(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z);
void decomposeInts2( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z);
unsigned long long composeInts3(const unsigned long long& poz, const unsigned long long&id_1, const unsigned long long&id_2,const unsigned long long&offset);
void decomposeInts3( unsigned long long composed,  unsigned long long & poz, unsigned long long &id_1, unsigned long long &id_2, unsigned long long &offset);



