






//  functions.cpp
//  Woowave
//
//  Created by igor on 1/5/15.
//  Copyright (c) 2015 Woowave ltd. All rights reserved.
//
//#include <jni.h>

#include "functions.h"
#include <math.h>
vector<int> references(1000);


//extern "C" {
//    JNIEXPORT jshortArray JNICALL Java_teewow_com_functionscompile_MainActivity_getFingerprint(JNIEnv *env, jobject o, jfloatArray data, jlong framesCount);
//}
float* precalculate() {
    float * res = (float*)malloc((384*sizeof(float)));
    
    float PI=3.1415926535897932384626433832795;
    int fftSize=384;
    int fftSeqCount = fftSize-1;
    float seqInc = 2*PI/fftSeqCount;
    float s=0;
    
    for (int index=0;index < fftSize;index++,s+=seqInc) {
        res[index] = 0.5*(1-cos(s));
    }
    return res;
}

//float* mnozaci = precalculate();
bool sporedi(const par &a, const par &b)
{
    return a.hashot < b.hashot;
}




bool sporediPosition(const par &a, const par &b)
{
    return a.frejm < b.frejm;
}

bool sporediPoFreq(const par &a, const par &b)
{
    return a.hashot < b.hashot;
}
bool removeIfCompare(const par& item)
{
    int status=0;
    for (int i=0;i<references.size();i++)
    {
        if (item.hashot==references[i])
        {
            //    cout<<"will be removed:"<<item.hashot<<"i="<<i<<endl;
            status=1;
            
        }
        
        
    }
    //    if (item.hashot == 1021900034||item.hashot == 1022500032||item.hashot == 1251900025||item.hashot == 1260300024||item.hashot == 1261900025||item.hashot == 1262600034||item.hashot == 1271400037||item.hashot == 780300025||item.hashot == 1280200061)
    //        return 1;
    
    
    return status;
    
    // apply some logic and return true or false
    //  return item.hashot == 1021900034;
}

bool sporedioffset(const par &a, const par &b)
{
    return (a.frejm<b.frejm);
}
bool sporediUnique(const par &a, const par &b)
{
    return (a.hashot==b.hashot);
}
bool sporedi2(const rezultPair &a, const rezultPair &b)
{
    return a.positionInBigger<b.positionInBigger;
}

bool sporedi2offset(const rezultPair &a, const rezultPair &b)
{
    return a.offset<b.offset;
}
bool offsetunique (const rezultPair &a, const rezultPair &b) {
    return (a.offset==b.offset);
}

MatrixXLI  final_sredi( Map<VectorXf> * data, long sampleCount,float a_dec,float targetdf,float targetdt,int slide,int fragmentStartFrame)
{
    
    
    cout<<" START final_sredi:"<<sampleCount<<endl;;
    std::vector<int> in;
    //  	VectorXf test(20);
    //  	test<<8,2,3,4,5,6,7,8,9,4,54,6,5,3,2,2,34,5,7,33;
    //  	VectorXf test2=loc_max(test,&in);
    //
    // 	VectorXf test3=Spread2(test,30);
    
    
    
    
    vector<int> temp_13;
    
    //vector<int> temp_11;
    
    //string filename="allofthem.ali";
    
    //vector<float> csv2spec;
    
    
    //bool zemigo=MatrixUtils::file2vector(&csv2spec,filename);
    
    vector<float> vv;
    vector<int> xx;
    
    vv.reserve(50000);
    xx.reserve(50000);
    
    /*}*/
    
    //	VectorXf X(114);
    //	X<<1,2,3,4,5,4,3,5,6,7,8,7,6,5,4,5,6,7,8,9,2,3,4,54,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,2,2,22,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,1;
    //cout<<Spread(X);
    
    //    int Xs=1866;
    //    float duration=15;
    //    int Ys=257;
    
    // 	char * ime2="D:/testexe/kvalitetno.csv";
    //   MatrixXf Spektrogram=final_specgram(data, &Xs, framesCount,&duration,duration2,slide);
   //  cout<<"before spectrogram:"<<sampleCount<<endl;
    MatrixXf Spektrogram=final_specgram(data, sampleCount, slide);    //  cout<<Spektrogram<<endl;
   // assert(Spektrogram.rows());
    
 //   cout<<"after spectrogram:"<<sampleCount<<endl;
    
    //    if(duration==0)
    //        duration=5;
    // cout<<"posle specgram"<<endl;
//    if (Spektrogram.rows()<2)
//    {
//        MatrixXLI deb(5,2);
//        deb.fill(0);
//        return deb;
//    }
    //	float **spektr=specgram(ime,&Xs,&duration);
    //	float **spektro=transpose(spektr,288,Xs);
    int nmaxes = 0;
    VectorXf eew;
    
    Spektrogram.transposeInPlace();
    
    float Smax=Spektrogram.maxCoeff();
    
    float  N = 52;
    
    int f_sd = 30;
    /*float a_dec = 0.9950;*/
    int maxpksperframe = 20;
    float hpf_pole = 0.98;
    // 	float targetdf = 51;
    // 	float targetdt = 83;
    int maxespersec=30;
    int p=0;
    int maxperpeak=30;
    
    int nmaxkeep = maxespersec * (sampleCount/8000+1)+5;
    
    
    MatrixXf  maxes(3,(sampleCount*2/8000)*50);   //sumnjivo...morav da stavm *2  imase nekoj problem so size
    
    
    
    
    
    
    maxes.fill(0); // popuni so nuli
    
    
    int maxix = 0;
    
    float s_sup = 1.0;
    
    
    MatrixXf tempsubmatrix(10,Spektrogram.cols());
    int temp=Spektrogram.cols();
    tempsubmatrix=Spektrogram.block(0,0,10,temp);
    //cout<<"tempsubmatrix:"<<tempsubmatrix;
    
    VectorXf temp12(tempsubmatrix.cols());
    for (int i=0;i<tempsubmatrix.cols();i++)
        temp12(i)=tempsubmatrix.col(i).maxCoeff(); //naogjanje na 10-te najgolemi koeficienti vo prvite 10 reda
    
    
    
    
    
    VectorXf sthresh=Spread2(temp12,30);
    
    //	cout<<sthresh;
    //system("pause");
    vector<int> Lthresh;
    for (int lt=0;lt<sthresh.rows();lt++)
        Lthresh.push_back(lt);
    Eigen::Map<VectorXi> one2thresh(&Lthresh[0],sthresh.rows()); //nepotreben del
    
    
    
    
    
    //cout<<"thresh:"<<sthresh.rows()<<endl;
    //cout<<sthresh;
    //system("pause");
    int nmaxthistime=0;
    //  const int iu=Xs;
    
    vector<float> makses1;
    VectorXf sdiff;
    vector<vector<int> > niza;
    
    //MatrixXf sthresh_debug(Spektrogram.rows(),Spektrogram.cols());
    //sthresh_debug.fill(0);
    VectorXf zero_vector(1);
    VectorXf s_this;
    zero_vector(0)=0;
    MatrixXf  tempq1_v(Spektrogram.rows(),Spektrogram.cols());
    VectorXf tempq1(Spektrogram.cols());
    tempq1.fill(0);
    for (int i=0;i<Spektrogram.rows();i++)
        
    {
        
        //cout<<endl<<"I="<<i<<endl;
        //cout<<endl<<"I="<<i<<endl;
        s_this=Spektrogram.row(i); //ok
        //cout<<"sthis"<<s_this;
        //system("pause");
        //cout<<"I="<<i;
        VectorXf temp13=(s_this - sthresh); //ok
        sdiff = igor_max_zerovec(zero_vector,temp13); //ok
        
        //        for (int zs=0;zs<temp13Rows;zs++)
        //        cout<<"example:"<<test(zs)<<"-"<<rezArray[zs];
        
        sdiff=loc_max(sdiff,&in); //&in e povratno so lokacija maksot vo toj zemen red od spektrogramot pogore kaj for loopot
        //system("pause");,&in);      // O.K.
        
        //cout<<"sdiff"<<sdiff;
        
        //	sdiff(sdiff.rows()) = 0;
        
        map<float,int> vvxx; // mapa za cuvanje na sdiff sortirana po freq
        sdiff(sdiff.rows()-1)=0;
        
        for (int ii=0;ii<sdiff.rows();ii++)
            vvxx[sdiff(ii)]=ii;
        
        map<float,int>::iterator it = vvxx.begin(), lim = vvxx.end();
        //vector<int> vv,xx;
        
        // cout<<"2476"<<endl;
        vvxx.erase(it);
        it = vvxx.begin();
        while ( it != lim )
        {
            float a = it->first;
            int  b = it->second;
            vv.push_back(a);
            xx.push_back(b);
            ++it;
        }
        
        
        
        
        int nmaxthistime = 0;
        maxpksperframe=5;
        std::reverse(vv.begin(), vv.end());
        std::reverse(xx.begin(), xx.end());
        
        
        
        
        
        for (int j=0;j<xx.size();j++)
        {
            
            p = xx[j];
            
            
            
            if (nmaxthistime < maxpksperframe)
                
            {
                if (s_this(p) > sthresh(p))
                    
                {
                    
                    
                    nmaxthistime = nmaxthistime + 1;
                    nmaxes = nmaxes + 1;
                    
                    maxes(1,nmaxes) = p;
                    //cout<<"nmaxes:***********************************************************************************************"<<nmaxes;
                    maxes(0,nmaxes) = i;
                    maxes(2,nmaxes) = s_this(p);
                    
                    // eww = exp(-0.5*(([1:length(sthresh)]'- p)/f_sd).^2);
                    //sthresh = max(sthresh, s_this(p)*s_sup*eww);
                    VectorXf e(sthresh.rows());
                    for (int e1=0;e1<sthresh.rows();e1++)
                        e(e1)=e1;
                    // cout<<"p"<<endl<<p<<endl;
                    
                    // system("pause");
                    // cout<<"nmaxes:"<<nmaxes<<"i="<<i<<" j="<<j<<"p="<<p<<"s_this="<<s_this(p)<<endl;;
                    
                    tempq1=((e.array()-p)/f_sd).matrix();
                    
                    
                    
                    VectorXf tempq2=tempq1.array()*tempq1.array();
                    //cout<<"bez exp tempq1"<<endl<<tempq2<<endl;
                    
                    // system("pause");
                    VectorXf eew1=-0.5*tempq2;
                    eew=eew1.array().exp().matrix();
                    
                    //eew=eew1;
                    
                    // eew=(((one2thresh.cast<float>().array()-p)/f_sd)*-0.5).pow(2).matrix();
                    // cout<<"EEW"<<eew<<endl;
                    // system("pause");
                    sthresh=igor_max_vec(sthresh,(s_this(p)*s_sup*eew));
                    
                    // cout<<"thresh"<<sthresh<<endl;
                    // system("pause");
                }
                
                
                
            }
            
            
        }
        for (int j=0;j<sthresh.rows();j++)
            tempq1_v(i,j)=tempq1(j);
        
        // 		for (int j=0;j<sthresh.rows();j++)
        // 			sthresh_debug(i,j)=sthresh(j);
        //if (xx.size()>0)
        xx.clear();
        
        //	if (vv.size()>0)
        vv.clear();
        sthresh = a_dec*sthresh; //ok
        
    }
    
    //maxes se identicni so maxes od matlab na ovoj sample na data so edna razlika MORA DA SE DODADE 1 na time and freq zasto C pocnuva od 0 a matlab od 1 !!!!!!!!!!!!!
    //char *fil="c:/11/sthresh_debug2.csv";
    //export2csv(fil,sthresh_debug,sthresh_debug.cols(),sthresh_debug.rows());
    //char *fil2="c:/11/tempq1.csv";
    //export2csv(fil2,tempq1_v,tempq1_v.cols(),tempq1_v.rows());
    MatrixXf makses11=maxes.transpose();
    
    
    //// ALL OK DO TUKA !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    vector<int> maxes2;
    int nmaxes2 = 0;
    int whichmax = nmaxes;
    
    //                  sthresh = s_sup*spread(S(:,end),f_sd)';
    
    //sthresh = s_sup*Spread2(Spektrogram.row(Spektrogram.rows()-1),f_sd);
    VectorXf brisi=Spektrogram.row(Spektrogram.rows()-1);
    sthresh = s_sup*Spread2(brisi,f_sd);    //ok
    
    // VectorXf testbrisi(17);
    // testbrisi<< -1.7595  ,  0.7189  ,  0.7049,   -0.2196,    0.5902,   -0.6784,    1.7027,    1.4021,    2.3306,    2.4146,    1.1575,    1.0467,    0.5539,    1.0482,   -1.4723,    0.2763,    0.6200;
    //
    //
    // VectorXf testbrisi2=Spread2(testbrisi,30);
    
    VectorXf eww(sthresh.rows());
    MatrixXf tempp(sthresh.rows(),1);
    
    MatrixXf temp9(sthresh.rows(),1);
    for (int i=Spektrogram.rows()-1;i>=0;i--)
    {
        while((whichmax>0)&&(makses11(whichmax,0)==i))
        {
            int p=makses11(whichmax,1);
            float v=makses11(whichmax,2);
            if (v>=sthresh(p))
            {
                nmaxes2=nmaxes2+1;
                maxes2.push_back(p);
                maxes2.push_back(i);
                for (int j=0;j<sthresh.rows();j++)
                    tempp(j)=j;
                VectorXf tempq1=((tempp.array()-p)/f_sd).matrix();
                VectorXf tempq2=tempq1.array().pow(2);
                VectorXf eew1=tempq2.array()*-0.5;
                eww=eew1.array().exp().matrix();
                tempp=v*1.0*eww;
                sthresh = igor_max_vec(sthresh, tempp);
            }
            whichmax = whichmax - 1;
            
            
        }
        
        sthresh = a_dec*sthresh;
    }
    
    
    //vector<int> tempigor3,tempigor2,tempigor1;
    vector<int> startt_v;
    vector<int> maxt_v;
    vector<int> minf_v;
    vector<int> maxf_v;
    startt_v.reserve(1000);
    maxt_v.reserve(1000);
    minf_v.reserve(1000);
    maxf_v.reserve(1000);
    temp_13.reserve(1000);
    //std::system("pause");
    if (maxes2.size()<2)
    {
        maxes2.push_back(0);
        maxes2.push_back(0);
        maxes2.push_back(0);
        maxes2.push_back(0);
        maxes2.push_back(0);
        maxes2.push_back(0);
    }
    
    Eigen::Map<MatrixXi> maxes2emap(&maxes2[0],2,maxes2.size()/2);
    maxes2emap.transpose();
    MatrixXi rrr=maxes2emap;
    MatrixXf maxes2e=rrr.cast<float>();
    //    for (int y=0;y<maxes2.size()/2;y++)
    // 	   for (int y1=0;y1<2;y1++)
    // 	   cout<<"maxes2e("<<y1<<","<<y<<")="<<maxes2e(y1,y)<<endl;
    
    // cout<<maxes2e<<endl;
    // Limit the number of pairs that we'll accept from each peak
    int	 maxpairsperpeak=10;
    if (nmaxes2<5)
        nmaxes2=5;
    //% Landmark is <starttime F1 endtime F2>
    // MatrixXf L(nmaxes2*maxpairsperpeak*2,5);
    MatrixXLI LL(nmaxes2*maxpairsperpeak*2,2);
    //L.fill(0);
    float startt;
    float F1;
    float maxt;
    float minf;
    float maxf;
    int nlmarks = -1;
    
    MatrixXf test10=maxes2e;
    VectorXf freq(maxes2e.cols());
    VectorXf time(maxes2e.cols());
    freq=maxes2e.row(0);
    time=maxes2e.row(1);
    int usloven =0;
    int j=0;
    int yy=0;
    int match_t;
    int match_f;
    int brojce;
    int i=0;
    // 		#pragma omp parallel private(startt,F1,minf,maxt,startt_v,yy,brojce,maxt_v,minf_v,maxf_v,j,match_t, match_f)
    //
    // 	{
    
    //#pragma omp parallel for num_threads(8) private(i,j,startt,F1,maxt,minf,maxf,brojce)  //23082012
    
    for (i=0;i<maxes2e.cols();i++)
    {
        
        startt = maxes2e(1,i);
        F1 = maxes2e(0,i);
        maxt = startt + targetdt;
        minf = F1 - targetdf;
        maxf = F1 + targetdf;
        /*#pragma omp parallel for */
        brojce=0;
        vector <int> temp_13;
        
        //#pragma omp parallel for   num threads(8)               //22082012
        for ( j=0;j<maxes2e.cols();j++)
        {
            
            if (time(j)>startt)
                
            {
                
                if (time(j)<maxt)
                    
                    
                    if (freq(j)>minf)
                        
                        
                        if (freq(j)<maxf)
                            
                        {
                            brojce=brojce+1;
                            
                            
                            if (brojce<maxperpeak)
                                
                            {
                                
                                match_t=time(j);
                                match_f=freq(j);
                                
                                
                                nlmarks=nlmarks+1;
                                //                                L(nlmarks,0)=startt;
                                //                                L(nlmarks,1) = F1;
                                //                                L(nlmarks,2) = match_f;
                                //                                L(nlmarks,3) = match_t-startt;
                                //                                L(nlmarks,4)=file_id;
                                
                                
                                //     unsigned long long composedints=composeints::composeInts((int)F1,(int)match_f,int(match_t-startt));
                                //30072012 TUKA MOZE NEKAKO NAMESTO DA SE STAVI MATCH-START KOJ E BROJ VO FREJMOVI, DA SE KALKULIRA VREMETO VO SEKUNDI AMA DA SE IZGUBI PRECIZNOST DO EDNA DECIMALA ZA DA SE NAJDAM POVEKE MATCHES VO SLEDNIOT DECOMPOSE
                                LL(nlmarks,0)=startt+(fragmentStartFrame/(192));
                                LL(nlmarks,1)=composeints::composeInts((int)F1,(int)match_f,int(match_t-startt));
                                
                                
                            }
                            
                            
                            
                            
                        }
                
                
            }
            
            
            
            
        }
        
        
        
    }
    
    //	}
    //sega a parovi od nizata
    
    
    //cout<<L.block(0,0,nlmarks,4);
    
    // Spektrogram.resize(0,0); anetta
    
    
    
    
//    if (LL.rows()<3||LL.cols()<2||nlmarks<1)
//    {
//        MatrixXLI test34;
//        
//        
//        
//        cout<<"LL<2 pred return.."<<endl;
//        test34.resize(5,2);
//        test34<<0,0,0,0,0,0,0,0,0,0;
//        
//        
//        return test34;
//        
//    }
    
    
    //MatrixXf temp10=L.block(0,0,nlmarks,5);
//    if (LL.rows()<nlmarks-1&&LL.cols()<2)
//    {
//        MatrixXLI test34;
//        
//        
//        
//        //  cout<<"LL<2 pred return.."<<endl;
//        test34.resize(5,2);
//        test34<<0,0,0,0,0,0,0,0,0,0;
//        
//        
//        return test34;
//        
//        
//        
//    }
    if (nlmarks>4)
    {
    MatrixXLI temp10=LL.block(0,0,nlmarks-1,2);
    
    // MatrixXLI temp100=sortirajeigenmatricapored(temp10);
    
    //cout<<"Analysis done!";
    
   // vector<par> rez;
  //  for (int i=0;i<temp10.rows();i++)
        
    
   cout<<" END final_sredi:"<<sampleCount<<endl;;
    return temp10;
    }
    else
    {
        MatrixXLI temp10;
        return temp10;
        
        
        
    }
    
    
    
    
    
    
    
}






//spectrogram code

void filter(int ord, float *a, float *b, int np, float *x, float *y)
{
    int i,j;
    y[0]=b[0]*x[0];
    for (i=1;i<ord+1;i++)
    {
        y[i]=0.0;
        for (j=0;j<i+1;j++)
            y[i]=y[i]+b[j]*x[i-j];
        for (j=0;j<i;j++)
            y[i]=y[i]-a[j+1]*y[i-j-1];
    }
    /* end of initial part */
    for (i=ord+1;i<np+1;i++)
    {
        y[i]=0.0;
        for (j=0;j<ord+1;j++)
            y[i]=y[i]+b[j]*x[i-j];
        for (j=0;j<ord;j++)
            y[i]=y[i]-a[j+1]*y[i-j-1];
    }
}
vector<float>  one2minusone(float n)
{
    vector<float> rezultat;
    
    float hop=2/n;
    for (float i=1;i>-1;i=i-hop)
        rezultat.push_back(i);
    
    rezultat[rezultat.size()-1]=-1;
    
    rezultat[n/2]=0.0;
    return rezultat;
}
vector<float>  one2minusdot98(float n)
{
    vector<float> rezultat;
    
    float hop=1.98/n;
    for (float i=1;i>-0.98;i=i-hop)
        rezultat.push_back(i);
    
    rezultat[rezultat.size()-1]=.98;
    rezultat[n/2]=0.0;
    return rezultat;
}
vector<float>  hanning(vector<float>  vec)
{
    float PI=3.1415926535897932384626433832795;
    vector<float> result;
    
    
    
    for ( int i=0;i<vec.size();i++)
    {
        float multiplier = 0.5 * (1 - cos(2*PI*i/(vec.size()-2)));
        result.push_back(vec[i]*multiplier);
        
        
    }
    
    
    return result;
    
    
}

MatrixXf remove_mean(MatrixXf matrica2)
{
    int y=matrica2.rows();
    int y1=matrica2.cols();
    float m=matrica2.mean();
    //#pragma omp parallel for
    for (int i=0;i<y;i++)
    {
        for (int j=0;j<y1;j++)
        {
            if (matrica2(i,j)==0)
                matrica2(i,j)=m;
            matrica2(i,j)=abs(matrica2(i,j)-m);
        }
    }
    
    return matrica2;
    
    
}
MatrixXf Max(float cutoff_value,MatrixXf matrica2)
{
    int y=matrica2.rows();
    int y1=matrica2.cols();
    //#pragma omp parallel for
    for (int i=0;i<y;i++)
    {
        for (int j=0;j<y1;j++)
        {
            
            
            if (matrica2(i,j)<cutoff_value)
                matrica2(i,j)=cutoff_value;
        }
    }
    
    return matrica2;
    
    
}

MatrixXf final_specgram(Map<VectorXf> * framesData, int samplesCount,int slide)
{
    float pixpersec;
    float basefreq;
    
    //     int32_t Ysize;
    //     int32_t bpo;
    /*float **spektral_image;*/
    // SNDFILE * audiofile;
    // SF_INFO sfinfo;
    // audiofile=sf_open(Filename,SFM_READ, &sfinfo);
    // *duration2=sfinfo.frames;
    // cout<<"sf info FRAMES:"<<sfinfo.frames<<endl;
    
    int fft=384;
    int noverlap=192;
    //    int frjms=framesCount;//sfinfo.frames;
    unsigned int modal=(samplesCount-slide)%fft;
    unsigned int tempi=(samplesCount-slide)+(fft-modal);
    //float *data=new float [tempi+1];
    VectorXf data(tempi+slide);
    data.fill(0);
    
    for (int i = 0; i < (*framesData).rows()-slide; ++i)
    {
        data(i) = (*framesData)(i+slide);
        //cout<<data(i)<<endl;;
    }
    unsigned int readcount;
    unsigned int  Xsize;
    // cout<<"specgram 832"<<endl;
    // readcount = sf_read_float (audiofile, &data(slide), sfinfo.frames);
    //vector<float>  data2;
    VectorXf data2(tempi*2);
    data2.fill(0);
    //  cout<<"specgram 837"<<endl;
    if (modal>=fft)
        cout<<"vnimanie!!";
    //     	for (int j=0;j<fft-modal;j++)
    // 			data(frjms+j)=0;
    
    int r=0;
    //#pragma opm parallel for num_threads(8)
    for (int i=0;i<tempi-fft;i=i+fft)
    {
        
        for (int j=0;j<fft;j++)
        {data2(r)=(data(i+j));
            r=r+1;}
        for (int j=0;j<fft;j++)
        {data2(r)=data(i+noverlap+j);
            r=r+1;}
        
        
    }
    
    //	data.resize(0);  anetta
    //cout<<"specgram 858"<<endl;
    // 		for (int i=0;i<tempi-fft;i=i+fft)
    // 		{
    //
    // 					for (int j=0;j<fft;j++)
    // 				data2.push_back(data(i+j));
    //
    // 					for (int j=0;j<fft;j++)
    // 						data2.push_back(data[i+noverlap+j]);
    //
    //
    // 		}
    
    Eigen::Map<MatrixXf> speko(&data2(0),fft,data2.rows()/fft);
    //	typedef std::vector<Eigen::VectorXf,Eigen::aligned_allocator<Eigen::VectorXf> > XdVector;
    float PI=3.1415926535897932384626433832795;
    //MatrixXf properspeko=speko;
    
    MatrixXf windowed(fft,speko.cols());
  //  cout<<"windowed initialised with :"<<fft<<speko.cols()<<endl;
    //#pragma omp parallel for num_threads(8) //24082012
    for (int j=0;j<windowed.cols();j++)
    {
        
        for (int i=0;i<fft;i++)
        {
            
            float mnozac=0.5*(1-cos(2*3.14159265358*i/(fft-1)));
            windowed(i,j)=mnozac*speko(i,j);
          //  cout<<"windowed("<<i<<","<<j<<")="<<windowed(i,j)<<endl;
           // windowed(i,j)=0.5*(1-cos(2*PI*i/(fft-1)))*speko(i,j);
            
        }
    }
    //properspeko=windowed;
    //	data2.resize(0);  anetta
    //speko.resize(0,0); anetta
    
    // cout<<"specgram 892"<<endl;
    //XdVector S;
    MatrixXf final(fft,windowed.cols());
    final.fill(0);
    int j=0;
    //#pragma omp parallel for num_threads(8) //23082012
  //  Eigen::FFT<float>  fftit;
     Eigen::FFT<float>  fftit;
    for (int i=0;i<windowed.cols()-1;i++)
    {
        
        VectorXf temp=windowed.col(i);
        VectorXcf freqvec2;
        
        fftit.fwd(freqvec2,temp);
        //properspeko.col(i)=freqvec2.cast<VectorXf>();
        VectorXf kasted=(freqvec2.real().array().pow(2)+freqvec2.imag().array().pow(2)).sqrt();
        //VectorXf kasted2=kasted.array().sqrt();
        //fft.inv( timevec,freqvec);
        //final<<kasted;
        for (int j=0;j<kasted.rows();j++)
            final(j,i)=kasted(j);
        
    }
    // windowed.resize(0,0); anetta
    float a[2]={1,-1};
    float b[2]={1,-0.98};
    MatrixXf final2=final.block(0,0,speko.rows()/2,speko.cols());
    //   cout<<"specgram 315"<<endl;
    //speko.resize(0,0);
    // final.resize(0,0); anetta
    //MatrixXf Spektrogram=final2;
    //cout<<"specgram 921"<<endl;
    float Smax=final2.maxCoeff();
    
    final2=(Max(Smax/1000000,final2)).array().log();
    
    //final2=remove_mean(final2);
    final2=final2.array()-final2.mean();
    
    //speko=Spektrogram;
    
    
    
    
    
    
    float **ru2=new float *[final2.rows()]();
    float *ru=new float [final2.cols()];
    
    
    int fr=final2.cols();
    for (int i=0;i<final2.rows();i++)
        ru2[i]=new float [fr+1]();
    //#pragma omp parallel for num_threads(8) //24082012
    for (int i=0;i<final2.rows();i++)
    {
        VectorXf roww=final2.row(i);
        // ru2[i]=new float [fr];
        for ( unsigned int j=0;j<roww.rows();j++)
        {
            /*ru[j]=roww(roww.rows()-1-j);*/
            ru[j]=roww(j);
            //cout<<"ru["<<j<<"]="<<ru[j]<<endl;
            //cout<<ru[j]<<endl;
        }
        
        
        filter(1,b,a,final2.cols(),ru,ru2[i]);
        
    }
    int kols=final2.cols();
    MatrixXf Spektrogram(final2.rows(),kols);
    //	#pragma omp parallel for num_threads(8) //24082012
    for (  int i=0;i<final2.rows();i++)
    {
        for (  int j=0;j<final2.cols();j++)
        {
            Spektrogram(i,j)=ru2[i][j];
        }
    }
    
    
    
    for (int i=0;i<final2.rows();i++)
        delete ru2[i];
    //data2.resize(0,0);
    delete [] ru2;
    delete [] ru;
    
    return Spektrogram;
    
    
    
    
    
}





//end spektrogram code
VectorXf Spread2(VectorXf X,int Q)
{
    float   W1 = 4*Q;
    VectorXf W(W1*2);
    VectorXf E(W1*2);
    E.fill(Q);
    
    for (float  i=-W1;i<W1;i=i+1)
    { W(i+W1)=i;
        
    }
    
    //  VectorXf E(32);
    //  cout<<"W"<<W<<endl;
    //  VectorXf E3 = W/4;
    //  VectorXf E31 = -0.5*E3;
    //  VectorXf  E2 = E31.array().pow(2).matrix();
    //  VectorXf E1 = E2.array().exp().matrix();
    
    
    E=(-0.5*(((W.array()/E.array())).array().pow(2))).exp();
    //cout<<"E"<<endl<<E<<endl;
    
    // E = exp(-0.5*[(-W:W)/E].^2);
    
    
    
    std::vector<int> in;
    in.reserve(1000);   //07082012
    X=loc_max(X,&in);
    
    VectorXf Y(X.size());
    Y.fill(0);
    
    int lenx = X.size();
    int maxi = lenx + (E.size()-1);
    int spos = 1+floorf(((E.size()-1)/2)+0.5);
    int temp;
    VectorXf EE;
    
    VectorXf temp1;
    VectorXf temp2;
    VectorXf temp3;
    for (int i=0;i<in.size();i++)
    {
        temp=in[i];
        
        temp1.resize(temp);
        temp1.fill(0);
        temp1=zalepi_vec(temp1,E);
        temp2.resize(maxi-temp1.size());
        temp2.fill(0);
        temp1=zalepi_vec(temp1,temp2);
        
        temp3=temp1.segment(spos,lenx);
        
        for (int u=0;u<lenx;u++)
            
        {
            
            Y(u) = std::max(Y(u),X(in[i])*temp3(u));
            
        }
        
    }
    return Y;
}
void igor_max_zerovecArray(VectorXf vec1,VectorXf vec2,float *rez)
{
    
    
    int y=vec2.rows();
    //   cout<<vec2.rows();
    //VectorXf rez(y);
    
    for (int i=0;i<y;i++)
    {
        
        
        
        if (vec2[i]<=vec1(0))
            rez[i]=vec1(0);
        else
            rez[i]=vec2(i);
        
    }
    
    //  cout<<rez;
    
    
}
VectorXf igor_max_zerovec(VectorXf vec1,VectorXf vec2)
{
    
    
    int y=vec2.rows();
    VectorXf rez(y);
    
    for (int i=0;i<y;i++)
    {
        
        
        
        if (vec2(i)<=vec1(0))
            rez(i)=vec1(0);
        else
            rez(i)=vec2(i);
        
    }
    
    return rez;
    
    
}

VectorXf igor_max_vec(VectorXf vec1,VectorXf vec2)
{
    if (vec1.rows()!=vec2.rows())
    {
        cout<<"mora da bidat ista dolzina vektorite!!!";
        exit(1);
    }
    
    int y=vec1.rows();
    VectorXf rez(y);
    
    for (int i=0;i<y;i++)
    {
        
        
        
        if (vec2(i)<=vec1(i))
            rez(i)=vec1(i);
        else
            rez(i)=vec2(i);
        
    }
    
    return rez;
    
    
}

VectorXf loc_max(VectorXf red,std::vector<int> *in)
{
    VectorXf red2(red.rows());
    VectorXf b(red.rows()+1);
    VectorXf c(red.rows()+1);
    VectorXf d(red.rows());
    b(0)=red(0);
    b.tail(red.rows())=red;
    red2=red;
    red2.conservativeResize(red2.rows()+1);
    red2(red2.rows()-1)=red(red.rows()-1);
    
    
    for (int j=0;j<red.rows()+1;j++)
        if (red2(j)>=b(j))
        {c(j)=1;}
        else {c(j)=0;}
    
    VectorXf test1=c.segment(0,c.rows()-1);
    VectorXf test2=c.segment(1,c.rows()-1);
    //Y = X .* nbr(1:end-1) .* (1-nbr(2:end));
    d=red.array()*c.segment(0,c.rows()-1).array()*(1-c.segment(1,c.rows()-1).array());
    
    for (int j=0;j<d.rows();j++)
        if (d(j)!=0)
            in->push_back(j);
    
    
    
    
    return d;
    
    
}
VectorXf zalepi_vec(VectorXf vec1,VectorXf vec2)
{
    if (vec2.rows()==0)
        return vec1;
    if (vec1.rows()==0)
        return vec2;
    
    vec1.conservativeResize(vec1.rows()+vec2.rows());
    vec1.tail(vec2.rows())<<vec2;
    
    
    return vec1;
    
    
    
    
    
}






unsigned long long composeints::composeInts(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z)
{
    //  return x + (10000 * y) + (1000000*z);
    //return x + (100000000000000 * y) + (100000000*z);
    
    return y*10000000+x*100000+z;
    //	h= (a*1031+b)*1031+c
}

void composeints::decomposeInts( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z)
{
    x = composed % 1000;
    composed -= x;
    composed = composed / 1000;
    
    y = composed % 1000;
    composed -= y;
    composed = composed / 1000;
    
    z = composed;
}

unsigned long long composeints::composeInts2(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z)
{
    //return x + (100000000000000 * y) + (100000000*z);
    
    return y*1000000000+z*1000000+x;
}



unsigned long long composeints::composeInts3(const unsigned long long& poz, const unsigned long long&id_1, const unsigned long long&id_2,const unsigned long long&offset)
{
    //return x + (100000000000000 * y) + (100000000*z);
    
    //	return y*1000000000+z*1000000+x;  // 01082012  nekako da se enkodira vremeto na match-ot i posle da se bara samo vo toj interval a ne vo cel file zasto so golemi fajlovi e problematicno!!!!
    return poz*10000000000000+id_1*10000000000+id_2*10000000+offset;
    // 18446744073709551615
}

void composeints::decomposeInts2( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z)
{
    unsigned long long q1,q2,q3,q4,q5;
    
    
    x = composed %1000000; // eve go prviot broj ofsetot
    q1=composed-x;
    composed =composed-x;
    //composed = composed / 100000;
    q2=q1/1000000;
    q3=q2 %1000;  //eve go vtoriot broj
    q4=q2-q3;
    q5=q4/1000;// eve go tretiot broj
    //y = (composed % 100000000000000)/100000000;
    //composed =composed-y;
    //composed = composed / 100000000;sredi(
    
    
    //z = composed;
    
    z=q3;
    y=q5;
    
    
}




void composeints::decomposeInts3( unsigned long long composed,  unsigned long long & poz, unsigned long long &id_1, unsigned long long &id_2, unsigned long long &offset)
{
    unsigned long long prviot=composed%10000000; // x
    unsigned long long temp=(composed-prviot)/10000000;
    unsigned long long vtoriot=temp%1000;
    temp=(temp-vtoriot);
    temp=temp/1000;
    unsigned long long tretiot=temp%1000;
    unsigned long long cetvrtiot=(temp-tretiot)/1000;
    //composed,offset,tret,vtor,poz;
    offset=prviot;
    id_2=vtoriot;
    id_1=tretiot;
    poz=cetvrtiot;
}
/////////////////////////////

unsigned long long composeInts(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z)
{
    //  return x + (10000 * y) + (1000000*z);
    //return x + (100000000000000 * y) + (100000000*z);
    
    return y*10000000+x*100000+z;
    //	h= (a*1031+b)*1031+c
}

void decomposeInts( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z)
{
    x = composed % 1000;
    composed -= x;
    composed = composed / 1000;
    
    y = composed % 1000;
    composed -= y;
    composed = composed / 1000;
    
    z = composed;
}

unsigned long long composeInts2(const  unsigned long long& x, const  unsigned long long&y, const  unsigned long long&z)
{
    //return x + (100000000000000 * y) + (100000000*z);
    
    return y*1000000000+z*1000000+x;
}

unsigned long long composeInts3_old(const unsigned long long& poz, const unsigned long long&id_1, const unsigned long long&id_2,const unsigned long long&offset)
{
    //return x + (100000000000000 * y) + (100000000*z);
    
    //	return y*1000000000+z*1000000+x;  // 01082012  nekako da se enkodira vremeto na match-ot i posle da se bara samo vo toj interval a ne vo cel file zasto so golemi fajlovi e problematicno!!!!
    return poz*1000000000000+id_1*1000000000+id_2*1000000+offset;
}
unsigned long long composeInts3(const unsigned long long& poz, const unsigned long long&id_1, const unsigned long long&id_2,const unsigned long long&offset)
{
    //return x + (100000000000000 * y) + (100000000*z);
    
    //	return y*1000000000+z*1000000+x;  // 01082012  nekako da se enkodira vremeto na match-ot i posle da se bara samo vo toj interval a ne vo cel file zasto so golemi fajlovi e problematicno!!!!
    return poz*10000000000000+id_1*10000000000+id_2*10000000+offset;
}


void decomposeInts2( unsigned long long composed,  unsigned long long& x,  unsigned long long&y,  unsigned long long&z)
{
    unsigned long long q1,q2,q3,q4,q5;
    
    
    x = composed %1000000; // eve go prviot broj ofsetot
    q1=composed-x;
    composed =composed-x;
    //composed = composed / 100000;
    q2=q1/1000000;
    q3=q2 %1000;  //eve go vtoriot broj
    q4=q2-q3;
    q5=q4/1000;// eve go tretiot broj
    //y = (composed % 100000000000000)/100000000;
    //composed =composed-y;
    //composed = composed / 100000000;sredi(
    
    
    //z = composed;
    
    z=q3;
    y=q5;
    
    
}

void decomposeInts3_old( unsigned long long composed,  unsigned long long & poz, unsigned long long &id_1, unsigned long long &id_2, unsigned long long &offset)
{
    unsigned long long prviot=composed%1000000;
    unsigned long long temp=(composed-prviot)/1000000;
    unsigned long long vtoriot=temp%1000;
    temp=(temp-vtoriot);
    temp=temp/1000;
    unsigned long long tretiot=temp%1000;
    unsigned long long cetvrtiot=(temp-tretiot)/1000;
    //composed,offset,tret,vtor,poz;
    offset=prviot;
    id_2=vtoriot;
    id_1=tretiot;
    poz=cetvrtiot;
}

void decomposeInts3( unsigned long long composed,  unsigned long long & poz, unsigned long long &id_1, unsigned long long &id_2, unsigned long long &offset)
{
    unsigned long long prviot=composed%10000000;
    unsigned long long temp=(composed-prviot)/10000000;
    unsigned long long vtoriot=temp%1000;
    temp=(temp-vtoriot);
    temp=temp/1000;
    unsigned long long tretiot=temp%1000;
    unsigned long long cetvrtiot=(temp-tretiot)/1000;
    //composed,offset,tret,vtor,poz;
    offset=prviot;
    id_2=vtoriot;
    id_1=tretiot;
    poz=cetvrtiot;
}
 vector<int> getduplicates(vector<int> IntVect)
 {

     std::map<int, int> CountMap;
     vector<int> results;
     //...
     std::vector<int>::iterator it = IntVect.begin();
     std::map<int, int>::iterator mapIt;

     for (std::vector<int>::iterator it = IntVect.begin(); it != IntVect.end(); ++it)
         CountMap[*it]++;

     for (std::map<int, int>::iterator it = CountMap.begin(); it != CountMap.end(); ++it)
         if (it->second > 2)
         {
             //  cout << "Duplicate " << it->first << endl;
             results.push_back(it->first);
         }

     return results;

 }



vector<par> getPeaks_CPP(float * framesData,long sampleCount, float strength,int fragmentStartFrame,float targetF,float targetD)
{
    vector<MatrixXLI> firstPass;
    
    //    for (int i=0;i<10;i++)
    //        cout<<framesData[i]<<endl;
    // std::cout<<filePath;
    // int durationInFrames=0;
    vector<MatrixXLI> secondPass;
    vector<MatrixXLI> thirdPass;
    //    VectorXf eigenData(sampleCount);
    //    for (int i=0;i<sampleCount;i++)
    //    {
    //
    //        eigenData(i) = framesData[i];
    //
    //    }
    
    
    Map<VectorXf> eigenData(framesData,sampleCount,1);
    
    
    MatrixXLI first= final_sredi(&eigenData, sampleCount,strength, targetF, targetD, 0,fragmentStartFrame);
    firstPass.push_back(first);
    
    
    MatrixXLI second= final_sredi(&eigenData, sampleCount,strength, targetF, targetD, 48,fragmentStartFrame);
    secondPass.push_back(second);
    //
    //
    MatrixXLI third= final_sredi(&eigenData, sampleCount,strength, targetF, targetD, 96,fragmentStartFrame);
    thirdPass.push_back(third);
    
    //   long _startTime = now_ms(); // start time
    
    
    vector<par> allPairs;
    long long reserveSpace = 0;
    for (int i=0;i<1;i++)
    {
        reserveSpace=reserveSpace+firstPass[i].rows()+secondPass[i].rows()+thirdPass[i].rows();
        
        
    }
    allPairs.reserve(reserveSpace);
    for (int j=0;j<1;j++)
    {
        for (int i=0;i<firstPass[j].rows();i++)
        {
            par temm;
            temm.frejm=firstPass[j](i,0);
            temm.hashot=firstPass[j](i,1);
            allPairs.push_back(temm);
            
        }
        
        for (int i=0;i<secondPass[j].rows();i++)
        {
            par temm;
            temm.frejm=secondPass[j](i,0);
            temm.hashot=secondPass[j](i,1);
            allPairs.push_back(temm);
            
        }
        
        for (int i=0;i<thirdPass[j].rows();i++)
        {
            par temm;
            temm.frejm=thirdPass[j](i,0);
            temm.hashot=thirdPass[j](i,1);
            allPairs.push_back(temm);
            
        }
    }
    
    
    // references=readVector();
    //    cout<<"references loaded from file:"<<endl;
    //    for (int i=0;i<references.size();i++)
    //    {
    //
    //        cout<<references[i]<<endl;
    //
    //    }
    //  std::sort(allPairs.begin(),allPairs.end(),sporediPoFreq);
    // std::unique(allPairs.begin(),allPairs.end(),sporediUnique);
    std::sort(allPairs.begin(),allPairs.end(),sporedi);
    // std::unique(allPairs.begin(),allPairs.end(),sporediUnique);
    allPairs.erase(unique(allPairs.begin(), allPairs.end(),sporediUnique), allPairs.end());
    //    for (int i=0;i<allPairs.size();i++)
    //    {
    //
    //        if (allPairs[i].hashot==61600038||allPairs[i].hashot==80800028||allPairs[i].hashot==160800046||allPairs[i].hashot==203200025||allPairs[i].hashot==82900055||allPairs[i].hashot==462000003||allPairs[i].hashot==466700008||allPairs[i].hashot==204600040||allPairs[i].hashot==294600018||allPairs[i].hashot==463200028)
    //            cout<<"pred brisenje, go ima vo allpairs["<<i<<"]="<<allPairs[i].hashot<<endl;
    //
    //
    //    }
    // allPairs.erase( remove_if(allPairs.begin(), allPairs.end(), removeIfCompare), allPairs.end() );
    //  std::sort(allPairs.begin(),allPairs.end(),sporediPosition);
    // vector<int> test;
    //for (int i=0;i<allPairs.size();i++)
    //    {
    //
    //        if (allPairs[i].hashot==61600038||allPairs[i].hashot==80800028||allPairs[i].hashot==160800046||allPairs[i].hashot==203200025||allPairs[i].hashot==82900055||allPairs[i].hashot==462000003||allPairs[i].hashot==466700008||allPairs[i].hashot==204600040||allPairs[i].hashot==294600018||    allPairs[i].hashot==463200028)
    //            cout<<"ne treba da go ima:"<<allPairs[i].hashot<<endl;
    //
    //
    //    }
    //    for (int i=0;i<allPairs.size();i++)
    //        test.push_back(allPairs[i].hashot);
    
    //    sort(test.begin(),test.end());
    //    test=getduplicates(test);
    //    cout<<"duplikati:";
    //    for (int i=0;i<test.size();i++)
    //        cout<<test[i]<<endl;
    
    
//    MatrixXLI rez(allPairs.size(),2);
//    for (int i=0;i<allPairs.size();i++)
//    {
//        rez(i,0)=allPairs[i].frejm;
//        rez(i,1)=allPairs[i].hashot;
//        
//        
//        
//    }
   
    //   long deltaTime = now_ms() - _startTime; // time your code took to exec in ms
    // // __android_log_print(ANDROID_LOG_INFO,"testt","getPeaks_CPP %d", deltaTime);
    
    // cout<<"durationinframes getpeaks finish:"<<durationInFrames<<endl;
    //  rez(allPairs.size(),0)=(long long)*durationInFrames;
    //  rez(allPairs.size(),1)=(long long)*durationInFrames;
    return allPairs;
    
}


vector<rezultPair> proveri_new(vector<par> left,vector<par> right,size_t leftDurationInFrames,size_t rightDurationinFrames,float * returnedOffset,float * returnedStrength,float * retVarience)
{
    
    
    
    std::sort(left.begin(), left.end(),sporedi);
    std::sort(right.begin(), right.end(),sporedi);
    vector<par> bigger;
    vector<par> smaller;
    size_t smallerDuration,biggerDuration;
    if (leftDurationInFrames>rightDurationinFrames)
    {
        bigger=left; smaller=right;
        smallerDuration = rightDurationinFrames;
        biggerDuration = leftDurationInFrames;
        
        
    }
    else
    {
        bigger=right;smaller=left ;
        smallerDuration = leftDurationInFrames;
        biggerDuration = rightDurationinFrames;
        
    }
    
    
    vector<rezultPair> rez;
    rez.reserve(1000);
    
    
    
    
    
    //    cout<<bigger<<endl;;
    //    cout<<"*****************"<<endl;
    //    cout<<smaller<<endl;
    // vector<rezultPair> results;
    
    typedef Matrix< unsigned long long,Dynamic , 1> VectorXLI;
    VectorXLI A(smaller.size()),B(bigger.size()),A_index(smaller.size()),B_index(bigger.size());
    
    
    for (unsigned int i=0;i<smaller.size();i++)
    {
        A(i)=smaller[i].hashot;
        A_index(i)=smaller[i].frejm;
    }
    for (int i=0;i<bigger.size();i++)
    {
        B(i)=bigger[i].hashot;
        
        B_index(i)=bigger[i].frejm;
    }
    
    
    unsigned  int n1 = A.rows();
    
    unsigned  int n2 = B.rows();
    
    int i = 0, j = 0;
    while (i < n1 && j < n2) {
        if (A(i) > B(j)) {
            j++;
        } else if (B(j) > A(i)) {
            i++;
        } else {
            
            int timediff;
            int q=A_index(i);
            int q1=B_index(j);
            
            timediff=(double)((((double)A_index(i)-(double)B_index(j))*192)/8000)*100+5000000;
            
            float start1=((((double)B_index(j)*192)/8000));
            
            int pozicija=start1;
            rezultPair pair;
            pair.positionInBigger=B_index(j);
            
            
            pair.offset=A_index(i)-B_index(j);
            pair.freq=A(i);
            
            rez.push_back(pair);
            
            
            i++;
            j++;
        }
    }
    
    
    
    
    
    
    std::sort(rez.begin(),rez.end(),sporedi2offset);
    vector<rezultPair> uniqueElements;
    // std::unique (rez.begin(), rez.end(), offsetunique);
    std::unique_copy (rez.begin(), rez.end(),back_inserter(uniqueElements) ,offsetunique);
    
    
    vector<rezultPair> ty = mostfrequentnumbers(rez);
//    for (int ii=0;ii<rez.size();ii++)
//        cout<<"rez:"<<rez[ii].offset<<endl;
    //    if (!ty.size())
    //        ty = rez;
    if (ty.size())
    {
        for (int i=0;i<rez.size();i++)
        {
            float currentOffset = rez[i].offset;
            
            for (int j=0;j<ty.size();j++)
            {
                
                if (abs(abs(ty[j].offset)-abs(currentOffset))<10)
                {
                    cout<<"changing offset:"<<rez[i].offset<<"to->"<<ty[j].offset<<endl;
                    rez[i].offset=ty[j].offset;
                }
                
                
                
                
            }
            
        }
        //    offset + MIN(v1.length-offset, v2.length-offset)
        
        float largestStrength=0;
        float largestStrengthRelatedOffset=0;
        int largestCounter=10;
        float allmaxesfactor=10;
        float bestVarience=150;
        vector<rezultPair> rezSortedByPosition = rez;
        std::sort(rezSortedByPosition.begin(),rezSortedByPosition.end(),sporedi2);
        for (int i=0;i<ty.size();i++)
        {
            
            unsigned int expectedPresek;
            int overlapend = min(smallerDuration,biggerDuration+ty[i].offset);
            //  int overlapstart = max(-ty[i].offset,0);
            float startInBigger,endInBigger;
            if (ty[i].offset>0)
            {
                expectedPresek =min(smallerDuration,smallerDuration-ty[i].offset);
                startInBigger = max(-ty[i].offset,0);
                endInBigger = startInBigger+expectedPresek;
                
            }
            else
            {
                expectedPresek =min(smallerDuration,biggerDuration+ty[i].offset);
                startInBigger = max(-ty[i].offset,0);
                endInBigger = startInBigger+expectedPresek;
                
                
            }
            //
            //
            cout<<"start in bigger:"<<(float)startInBigger*192/8000<<endl;
            
            cout<<"end in bigger:"<<(float)endInBigger*192/8000<<endl;
            
            
            *retVarience = varianceNew(rezSortedByPosition ,(int)ty[i].offset, startInBigger,endInBigger);
            
            cout<<"VARIENCE:"<<*retVarience<<endl;
            //   cout<<expectedPresek;
            int strength=0;
            int numberofinadequatemaxesinpresek=1;
            int counter=0;
            int allMaxesCount=0;
            for (int j=0;j<rezSortedByPosition.size();j++)
            {
               if ( rezSortedByPosition[j].positionInBigger >startInBigger &&  rezSortedByPosition[j].positionInBigger < endInBigger)
                   
               {
                   
                if (rezSortedByPosition[j].positionInBigger >startInBigger&&rezSortedByPosition[j].positionInBigger<endInBigger&&!(ty[i].offset==rezSortedByPosition[j].offset))
                    numberofinadequatemaxesinpresek++;
                
                 if (rezSortedByPosition[j].positionInBigger >startInBigger&&rezSortedByPosition[j].positionInBigger<endInBigger)
                     allMaxesCount++;
                
                
                if (ty[i].offset==rezSortedByPosition[j].offset)
                {
                    
                    
                   
                        strength++;
                    
                        counter++;
                  
                    
                        
                  
                    
                }
                   else
                       strength--;
              
                
            }
            
                
            }
            
          //  if (strength/numberofinadequatemaxesinpresek>1&&*retVarience<100&&counter>5)
        //    if (*retVarience<100&&counter>5&&((expectedPresek*192/8000)/counter<1))
         //   float currFactor = (((float)(expectedPresek)*192)/8000)/(float)counter;
             float currFactor = (((float)(expectedPresek))/(float)counter);
        //    float allmaxespresentfactor =  (((float)(expectedPresek))/((float)allMaxesCount));
            float allmaxespresentfactor =  ((float)allMaxesCount)/((float)counter);
           // float factor3 = (float)allMaxesCount/(float) expectedPresek;
             cout<<"counter:"<<counter<<"allmaxescount:"<<allMaxesCount<<"expectedpresek:"<<expectedPresek<<"varience:"<<*retVarience <<"allmaxes/counter:"<<allmaxespresentfactor<<endl;
           // if (counter>expectedPresek/30&&allmaxespresentfactor<10&&allmaxespresentfactor<allmaxesfactor&&*retVarience<200)
            if (allmaxespresentfactor<allmaxesfactor&&*retVarience<bestVarience)
         //   if (*retVarience<max(expectedPresek/8.0,400.0)&&*retVarience<bestVarience&&counter>max(expectedPresek/200.0,10.0))
            // if ((*retVarience<50&&currFactor<16)||((strength*20)>((float)(expectedPresek))&&currFactor<16))
               // if ((*retVarience<(allMaxesCount)))
               // if (counter>allMaxesCount/6)
              //  if (*retVarience<4&&(allMaxesCount/counter)<10) //before kalap 2016
                 //if (*retVarience<max(200.0,expectedPresek/2.0)&&(allMaxesCount/counter)<90)
            {
                largestCounter = counter;
                float currentStrength = (float)strength/(float)expectedPresek;
                allmaxesfactor = allmaxespresentfactor;
                float negativeSrength = (float)numberofinadequatemaxesinpresek/(float)expectedPresek;
               currentStrength = currentStrength/negativeSrength;
               // if (currentStrength>largestStrength)
               // if (*retVarience<bestVarience)
                {
                    largestStrength=currentStrength;
                    bestVarience = *retVarience;
                    
                    largestStrengthRelatedOffset = ty[i].offset;
                    
                }
                
                cout<<"SYNC FOUND -> counter:"<<counter<<"allmaxescount:"<<allMaxesCount<<"expectedpresek:"<<expectedPresek<<"varience:"<<*retVarience <<endl;
//                if ((strength>60&&currFactor>1)||(strength>60&&*retVarience>50))
//                    cout<<"BASED STRENGTH >60!!!!!!!!!!!!!"<<endl;
            }
            
            
        }
        
        
        *returnedOffset = largestStrengthRelatedOffset;
        *returnedStrength = largestStrength;
        
        *retVarience = bestVarience;
    }
    else
    {
        *returnedOffset = 0;
        *returnedStrength=0;
        
    }
    
    
    if (leftDurationInFrames<rightDurationinFrames&&*returnedOffset<0)
        *returnedOffset = *returnedOffset*-1;
    else
    if (leftDurationInFrames<rightDurationinFrames&&*returnedOffset>0)
        *returnedOffset = *returnedOffset;
    
    return rez;
}
vector<rezultPair> mostfrequentnumbers(vector<rezultPair>  array)
{
    vector<rezultPair> uniqueElements;
    // std::unique (rez.begin(), rez.end(), offsetunique);
    std::unique_copy (array.begin(), array.end(),back_inserter(uniqueElements) ,offsetunique);

    vector<rezultPair> results;
    
   
   
    
        rezultPair   number = {};
        rezultPair   emty = {};
        array.push_back(number);
    rezultPair mode = number;
    int count = 1;
    int countMode = 1;
        int location=0;
    
    rezultPair firstMax;
    
    
    
    
        for (int i=0;i<array.size(); i++)
    {
     
      
            if (array[i].offset == number.offset)
            {
                count++;
            }
            else
            {
                if (count > countMode)
                {
                    countMode = count;
                    mode = number;
                    location = i;
                }
                count = 1;
                number = array[i];
            }

        }
    
    firstMax = mode;
    number = emty;
    
    
     mode = number;
    count = 1;
    countMode = 1;
     location=0;
    
    rezultPair secondMax;
    
    for (int i=0;i<array.size(); i++)
    {
        
        
        if (array[i].offset == number.offset)
        {
            count++;
        }
        else
        {
            if (count > countMode && number.offset != firstMax.offset )
            {
                countMode = count;
                mode = number;
                location = i;
            }
            count = 1;
            number = array[i];
        }
        
    }
    
    secondMax = mode;
    number = emty;
    
    
    mode = number;
    count = 1;
    countMode = 1;
    location=0;
    
    rezultPair thirdMax;
    
    for (int i=0;i<array.size(); i++)
    {
        
        
        if (array[i].offset == number.offset)
        {
            count++;
        }
        else
        {
            if (count > countMode && number.offset!=firstMax.offset&&number.offset!=secondMax.offset)
            {
                countMode = count;
                mode = number;
                location = i;
            }
            count = 1;
            number = array[i];
        }
        
    }
    thirdMax = mode;
      if (firstMax.offset!=0&&firstMax.positionInBigger!=0)
    results.push_back(firstMax);
    if (secondMax.offset!=0&&secondMax.positionInBigger!=0&&abs((abs(secondMax.offset)-abs(firstMax.offset)))>4)
    results.push_back(secondMax);
     if (thirdMax.offset!=0&&thirdMax.positionInBigger!=0&&abs((abs(thirdMax.offset)-abs(secondMax.offset)))>4&&abs((abs(thirdMax.offset)-abs(firstMax.offset)))>4)
    results.push_back(thirdMax);
    
  
    
    return results;
}



vector<rezultPair> proveri(MatrixXLI bigger,MatrixXLI smaller)
{
    //    cout<<bigger<<endl;;
    //    cout<<"*****************"<<endl;
    //    cout<<smaller<<endl;
    vector<rezultPair> results;
    
    typedef Matrix< unsigned long long,Dynamic , 1> VectorXLI;
    VectorXLI A(smaller.rows()),B(bigger.rows()),A_index(smaller.rows()),B_index(bigger.rows());
    for (int i=0;i<smaller.rows();i++)
    {
        A(i)=smaller(i,1);
        A_index(i)=smaller(i,0);
    }
    for (int i=0;i<bigger.rows();i++)
    {
        B(i)=bigger(i,1);
        
        B_index(i)=bigger(i,0);
    }
    float smaller_traenje=smaller.rows();
    float bigger_traenje=bigger.rows();
    vector<unsigned long long> intersection;
    intersection.push_back(9999999);
    vector<unsigned long long> intersectionindeksi;
    intersectionindeksi.push_back(0);
    
    // logthis("*");
    int n1 = A.rows();
    // cout<<"n1="<<n1<<endl;
    int n2 = B.rows();
    // cout<<"n2="<<n2<<endl;
    int i = 0, j = 0;
    while (i < n1 && j < n2) {
        if (A(i) > B(j)) {
            j++;
        } else if (B(j) > A(i)) {
            i++;
        } else {
            
            int timediff;
            int q=A_index(i);
            int q1=B_index(j);
            // cout<<  B(j)<<endl;
            //   cout<<A(i);
            timediff=(double)((((double)A_index(i)-(double)B_index(j))*192)/8000)*100+5000000;
            //   cout<<(double)((((double)A_index(i)-(double)B_index(j))*192)/8000)*100000<<endl;
            float start1=((((double)B_index(j)*192)/8000));
            //  float pozicija=((float)start1)/((float)(((float)smaller_traenje+1)/32));
            int pozicija=start1;
            rezultPair pair;
            pair.positionInBigger=B_index(j);
            
            //  cout<< "positioninbigger-A_index:"<<pair.positionInBigger<<"- "<<A_index(i);
            // A_index(i)-(double)B_index(j)
            pair.offset=A_index(i)-B_index(j);
            pair.freq=A(i);
            // pair.offset=A_index(i)-B_index(j);
            results.push_back(pair);
            if (A(i)==61600038)
                cout<<"ne treba da e tuka"<<A(i)<<endl;
            // cout<<pair.positionInBigger<<"<->"<<abs(pair.offset)+A_index(i)<<"<->"<<pair.offset<<endl;
            //  unsigned long long haso=composeInts3((int)pozicija,3,smaller_id,timediff);
            //  cout<<haso<<endl;
            // intersection.push_back(haso);
            // intersectionindeksi.push_back(A_index(i));
            i++;
            j++;
        }
    }
    std::sort(results.begin(),results.end(),sporedi2);
    
    
    return results;
}

void writeVector(vector<int> reference)
{
    char* pPath;
    pPath = getenv ("TMPDIR");
    if (pPath!=NULL)
        printf ("The current path is: %s",pPath);
    char destination[1024]; // 5 times s, 4 times k, one zero-terminator
    
    char* str2="reference.bin";
    strcpy(destination, pPath);
    printf("%s",strcat(destination,str2));
    // const char *cString = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
    int * array= &reference[0]; // zemi pointer to dense data
    unsigned long long sajz=(reference.size()); // kolku data imame
    FILE *file = fopen(destination, "wb");
    fwrite(array, sizeof(int), sajz , file);
    fclose(file);
}
int exists(const char *fname)
{
    FILE *file;
    if (file = fopen(fname, "r"))
    {
        fclose(file);
        return 1;
    }
    return 0;
}
vector<int> readVector()
{
    char* pPath;
    pPath = getenv ("TMPDIR");
    if (pPath!=NULL)
        printf ("The current path is: %s",pPath);
    char destination[1024]; // 5 times s, 4 times k, one zero-terminator
    
    char* str2="reference.bin";
    strcpy(destination, pPath);
    printf("%s",strcat(destination,str2));
    vector<int> empty;
    if (exists(destination))
    {
        FILE *file = fopen(destination, "rb");
        fseek(file, 0L, SEEK_END);
        size_t sz = ftell(file);
        fseek(file, 0L, SEEK_SET);
        int s=sz/sizeof(int);
        int *readArray=new int [s];
        fread(readArray,sizeof(int),sz/sizeof(int),file);
        
        for (int i=0;i<s;i++)
        {    empty.push_back(readArray[i]);
            
            //  cout<<empty[i]<<endl;
        }
        //   std::vector<int> v(readArray, readArray + 3);
        
        //  empty=v;
        //  return v;
        
    }
    
    return empty;
    
}

MatrixXLI proccessWavData(void * wavData,size_t numberOfSamples,float strength,size_t buffSizeInSamples,size_t * returnSize,float targetF,float targetD)
{
    
    vector<vector<par> > resultsVector;
    
    
    float div = (32768.00f);
    
    size_t numberOfFraments = numberOfSamples /  (buffSizeInSamples );
    
    size_t remindingFrames = numberOfSamples  %  (buffSizeInSamples );
    
    short * buffData = (short*)wavData;
    
    
    
    
    for ( size_t  i=0;i<numberOfFraments;i++)
    {
        float * fragmentFloatData = new float[buffSizeInSamples];
        
        for (unsigned int j=0;j<buffSizeInSamples;j++) {
            fragmentFloatData[j] = (float)buffData[i*buffSizeInSamples+j]/div;
        }
        
        vector<par> results = getPeaks_CPP(&fragmentFloatData[0], buffSizeInSamples, strength,i*buffSizeInSamples,targetF,targetD);
        
        resultsVector.push_back(results);
        
        delete [] fragmentFloatData;
        
    }
    
    
    if (remindingFrames>8000) {// samo akoreminder e podolgo od 1 sek. ako ne , ignoriraj
        float * fragmentFloatData = new float[remindingFrames];
        
        for (unsigned int j=0;j<remindingFrames;j++)
            
        {
            
            
            fragmentFloatData[j] = (float)buffData[numberOfFraments*buffSizeInSamples+j]/div;
            
            
            
        }
        
        
        
        vector<par> reminderResults = getPeaks_CPP(&fragmentFloatData[0], remindingFrames, strength,numberOfFraments*buffSizeInSamples,targetF,targetD);
        resultsVector.push_back(reminderResults);
        delete [] fragmentFloatData;
        
        
    }
    
    //   long _startTime = now_ms(); // start time
    
    size_t totalSizeOfElements=0;
    
    
    for ( int i=0;i<resultsVector.size();i++)
    {
        
        totalSizeOfElements = totalSizeOfElements + resultsVector[i].size();
        
    }
    
    
    
    vector<par> finalRez;
    finalRez.reserve(totalSizeOfElements);
    //= new unsigned long long [totalSizeOfElements];
    size_t count =0;
    for ( int i=0;i<resultsVector.size();i++)
        for (int j=0;j<resultsVector[i].size();j++)
        {
            finalRez.push_back(resultsVector[i][j]);
            
        }
    
    
    *returnSize = count;
    
    //  long deltaTime = now_ms() - _startTime; // time your code took to exec in ms
    // // __android_log_print(ANDROID_LOG_INFO,"testt","proccessWavData %d", deltaTime);
    
    MatrixXLI rezEiegen(finalRez.size()+1,2);
    for ( int i=0;i<finalRez.size();i++)
    {
        rezEiegen(i,1) = finalRez[i].hashot;
        rezEiegen(i,0) = finalRez[i].frejm;
        
    }
    rezEiegen(finalRez.size(),1) = numberOfSamples/192;
    rezEiegen(finalRez.size(),0) = numberOfSamples/192;
    
    return rezEiegen;
}
vector<par> proccessWavDataPAR(void * wavData,size_t numberOfSamples,float strength,size_t buffSizeInSamples,size_t * returnSize,float targetF,float targetD)
{
    
    vector<vector<par> > resultsVector;
    
    
    float div = (32768.00f);
    
    size_t numberOfFraments = numberOfSamples /  (buffSizeInSamples );
    
    size_t remindingFrames = numberOfSamples  %  (buffSizeInSamples );
    
    short * buffData = (short*)wavData;
    
    
    
    
    for ( size_t  i=0;i<numberOfFraments;i++)
    {
        float * fragmentFloatData = new float[buffSizeInSamples];
        
        for (unsigned int j=0;j<buffSizeInSamples;j++) {
            fragmentFloatData[j] = (float)buffData[i*buffSizeInSamples+j]/div;
        }
        
        vector<par> results = getPeaks_CPP(&fragmentFloatData[0], buffSizeInSamples, strength,i*buffSizeInSamples,targetF,targetD);
        
        resultsVector.push_back(results);
        
        delete [] fragmentFloatData;
        
    }
    
    
    if (remindingFrames>8000) {// samo akoreminder e podolgo od 1 sek. ako ne , ignoriraj
        float * fragmentFloatData = new float[remindingFrames];
        
        for (unsigned int j=0;j<remindingFrames;j++)
            
        {
            
            
            fragmentFloatData[j] = (float)buffData[numberOfFraments*buffSizeInSamples+j]/div;
            
            
            
        }
        
        
        
        vector<par> reminderResults = getPeaks_CPP(&fragmentFloatData[0], remindingFrames, strength,numberOfFraments*buffSizeInSamples,targetF,targetD);
        resultsVector.push_back(reminderResults);
        delete [] fragmentFloatData;
        
        
    }
    
    //   long _startTime = now_ms(); // start time
    
    size_t totalSizeOfElements=0;
    
    
    for ( int i=0;i<resultsVector.size();i++)
    {
        
        totalSizeOfElements = totalSizeOfElements + resultsVector[i].size();
        
    }
    
    
    
    vector<par> finalRez;
    finalRez.reserve(totalSizeOfElements+1);
    //= new unsigned long long [totalSizeOfElements];
    size_t count =0;
    for ( int i=0;i<resultsVector.size();i++)
        for (int j=0;j<resultsVector[i].size();j++)
        {
            finalRez.push_back(resultsVector[i][j]);
            
        }
    par numberofsamplesaslast={};
    numberofsamplesaslast.frejm = numberOfSamples/192;
    numberofsamplesaslast.hashot = numberOfSamples/192;
    finalRez.push_back(numberofsamplesaslast);
    
    *returnSize = count;
    
    //  long deltaTime = now_ms() - _startTime; // time your code took to exec in ms
    // // __android_log_print(ANDROID_LOG_INFO,"testt","proccessWavData %d", deltaTime);
    
//    MatrixXLI rezEiegen(finalRez.size()+1,2);
//    for ( int i=0;i<finalRez.size();i++)
//    {
//        rezEiegen(i,1) = finalRez[i].hashot;
//        rezEiegen(i,0) = finalRez[i].frejm;
//        
//    }
//    rezEiegen(finalRez.size(),1) = numberOfSamples/192;
//    rezEiegen(finalRez.size(),0) = numberOfSamples/192;
    
    return finalRez;
}
//JNIEXPORT jshortArray JNICALL Java_teewow_com_functionscompile_MainActivity_getFingerprint(JNIEnv *env, jobject o, jfloatArray data, jlong framesCount) {
//    jfloat* framesData = env->GetFloatArrayElements(data,0);
//
//    int durationinframes;
//    MatrixXLI result =  getPeaks_CPP(framesData, framesCount, 0.99, &durationinframes);
//    
//    jshortArray retval = env->NewShortArray(result.rows());
//    // env->SetShortArrayRegion(retval,0,result.rows(), );
//    
//    return retval;
//
//}
bool parsporediequal ( par & a,  par & b) {
    if (a.hashot<b.hashot)
    {
        a.frejm = (a.frejm-b.frejm)+1000;
      return 1;
    }
    else return 0;
}
vector<par> getInter( vector<par> left,  vector<par> right)
{
    
    std::sort(left.begin(), left.end(),sporedi);
    std::sort(right.begin(), right.end(),sporedi);
    vector<par> intersected;
    intersected.reserve(2000);
 //  set_intersection(left.begin(),left.end(),right.begin(),right.end(),intersected.begin(),parsporediequal);
    set_intersection(left.begin(), left.end(), right.begin(), right.end(), std::back_inserter(intersected), parsporediequal);
    return intersected;
    
    
    
}
double variance ( vector<rezultPair> v , int offsetInFrames, int startInBigFile, int endinBigFile)
{
    double sum = 0.0;
    double temp =0.0;
    double var =10000000;
    float mean = offsetInFrames*192.00/8000;
    int counter=0;
    for ( int j =0; j <= v.size(); j++)
    {
        if (v[j].positionInBigger>=startInBigFile&&v[j].positionInBigger<=endinBigFile)
        {
            counter++;
            float timedOffset = (float)v[j].offset*192/8000;
        float A = timedOffset - mean;
        temp = pow(A,2);
        sum += temp;
        }
    }
    var = sum/(counter -2);
    return var;
}


double varianceNew ( vector<rezultPair> v , int offsetInFrames, int startInBigFile, int endinBigFile)
{
   int counter=1;
    int sum=0;
    int sumI=0;
    
    double res=200000;
    double resI=200000;
    for ( int j =0; j <= v.size(); j++)
    {
        if (v[j].positionInBigger>=startInBigFile)
        {
           int  lastframematch = v[j].positionInBigger;
            int lastframematchI = j;
        
            for (int i =j ;i<v.size();i++)
            {
                counter++;
                if(v[i].offset==offsetInFrames)
                {
                    
                    float currentPosition = (float)v[i].positionInBigger;
                    float A = currentPosition - lastframematch;
                    float B = i - lastframematchI;
                              int  temp = pow(A,2);
                    int  tempI = pow(B,2);
                                sum += temp;
                    sumI += tempI;
                    lastframematch = v[i].positionInBigger;
                    lastframematchI = i;
                    
                }
                
                if (v[i].positionInBigger>=endinBigFile||i==v.size()-1)
                 
                   {
                       float B = i - lastframematchI;
                       
                       int  tempI = pow(B,2);
                     
                       sumI += tempI;
                    res = (float)sum / ((float)counter);
                     resI = (float)sumI / (float)(counter);
                    return resI;
                    }
                
                
                
                
                
                
            }
            
            
            

        }
    }

    return resI;
}



void writeMatrixWithMetadata(char *  filePath, vector<par> markers, char * metadata,unsigned long long metadataSizeInBytes,unsigned long long numberOfSamples)
{
    
    par * array=&markers[0]; // zemi pointer to dense data
    unsigned long long sajz=markers.size(); // kolku data imame
    FILE *file = fopen(filePath, "wb");
    unsigned long long markersSize = markers.size();
    fwrite(&markersSize, sizeof(unsigned long long), 1 , file);
    fwrite(&metadataSizeInBytes, sizeof(unsigned long long), 1 , file);
    fwrite(&numberOfSamples, sizeof(unsigned long long), 1 , file);
    fwrite(array, sizeof(par), sajz , file);
    fwrite(metadata, sizeof(char), metadataSizeInBytes , file);
    fclose(file);
}



vector<par> readMatrixWithMetadata(char *  filePath,char * metadata, unsigned long long * numberOfSamples)
{
    //
    
    
    FILE * pFile;
    long lSize;
    char * buffer;
    size_t result;
    
    pFile = fopen ( filePath , "r" );
    if (pFile==NULL) {fputs ("File error",stderr); exit (1);}
    
    // obtain file size:
    fseek (pFile , 0 , SEEK_END);
    lSize = ftell (pFile);
    rewind (pFile);
    
    // allocate memory to contain the whole file:
    buffer = (char*) malloc (sizeof(char)*lSize);
    if (buffer == NULL) {fputs ("Memory error",stderr); exit (2);}
    
    
    //get number of fingerprints
    unsigned long long numberofmaxes,metadatasizeinbytes;
    result = fread (&numberofmaxes,1,sizeof(unsigned long long),pFile);
    result = fread (&metadatasizeinbytes,1,sizeof(unsigned long long),pFile);
     result = fread (numberOfSamples,1,sizeof(unsigned long long),pFile);
    
    // copy the file into the buffer:
    result = fread (buffer,1,lSize-metadatasizeinbytes-sizeof(unsigned long long)*3,pFile);
    if (result != lSize-metadatasizeinbytes-sizeof(unsigned long long)*3) {fputs ("Reading error par vector",stderr); exit (3);}
    result = fread(metadata, 1, metadatasizeinbytes, pFile);
    if (result != metadatasizeinbytes) {fputs ("Reading error 500 metadata",stderr); exit (3);}
    
    
    
    /* the whole file is now loaded in the memory buffer. */
    
    // terminate
    fclose (pFile);
    free (buffer);
    
    
    //
    
    
  //  NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    size_t s=(lSize-metadatasizeinbytes-sizeof(unsigned long long)*3)/sizeof(par);
    par *int_data_out = (par*) buffer;
    //  std::vector<int> v(x, x + sizeof x / sizeof x[0]);
    vector<par> rezultat(int_data_out,int_data_out+s);
  
    return rezultat;
}

