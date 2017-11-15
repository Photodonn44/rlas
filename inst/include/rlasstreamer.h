#ifndef LASSTREAMER_H
#define LASSTREAMER_H

#include <Rcpp.h>
#include "lasreader.hpp"
#include "laswriter.hpp"
#include "lasfilter.hpp"

using namespace Rcpp;

class RLASstreamer
{
  public:
    RLASstreamer();
    RLASstreamer(CharacterVector);
    RLASstreamer(CharacterVector, CharacterVector);
    RLASstreamer(CharacterVector, CharacterVector, CharacterVector);
    ~RLASstreamer();
    void setinputfiles(CharacterVector);
    void setoutputfile(CharacterVector);
    void setfilter(CharacterVector);
    bool read_point();
    void write_point();
    LASpoint* point();
    List terminate();
    void read_t(bool);
    void read_i(bool);
    void read_r(bool);
    void read_n(bool);
    void read_d(bool);
    void read_e(bool);
    void read_c(bool);
    void read_a(bool);
    void read_u(bool);
    void read_p(bool);
    void read_rgb(bool);
    void read_at(bool*, int);

  private:
    void initialize_bool();
    void initialize();
    int get_format(U8);

  private:
    std::vector<double> X;
    std::vector<double> Y;
    std::vector<double> Z;
    std::vector<double> T;
    std::vector<unsigned short> I;
    std::vector<unsigned short> RN;
    std::vector<unsigned short> NoR;
    std::vector<unsigned short> SDF;
    std::vector<unsigned short> EoF;
    std::vector<unsigned short> C;
    std::vector<short> SA;
    std::vector<unsigned short> UD;
    std::vector<unsigned short> PSI;
    std::vector<unsigned short> R;
    std::vector<unsigned short> G;
    std::vector<unsigned short> B;
    std::vector<double> At0;
    std::vector<double> At1;
    std::vector<double> At2;
    std::vector<double> At3;
    std::vector<double> At4;
    std::vector<double> At5;
    std::vector<double> At6;
    std::vector<double> At7;
    std::vector<double> At8;
    std::vector<double> At9;


    LASreadOpener lasreadopener;
    LASwriteOpener laswriteopener;
    LASreader* lasreader;
    LASwriter* laswriter;
    LASheader* header;

    int format;

    bool inR;
    bool useFilter;
    bool initialized;
    bool ended;

    bool t;
    bool i;
    bool r;
    bool n;
    bool d;
    bool e;
    bool c;
    bool a;
    bool u;
    bool p;
    bool rgb;
    bool at0; // attribute0
    bool at1; // attribute1
    bool at2; // attribute2
    bool at3; // attribute3
    bool at4; // attribute4
    bool at5; // attribute5
    bool at6; // attribute6
    bool at7; // attribute7
    bool at8; // attribute8
    bool at9; // attribute9
};

#endif //LASSTREAMER_H