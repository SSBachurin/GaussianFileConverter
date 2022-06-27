# GaussianFileConverter

## Description
This package was developed for Gaussian ONIOM and MM calculations.

## Motivation
Currently Gaussian uses built-in MM force fields, which may be
not suited for some biologica calculations. In my case it was necessary
to perform calculations in OL15 ffLib. Manualy I prepared force field replacement
as it mentioned in official instructions, but it was frustrating to check and replace
atom notations in several input ".gjf" files.

So I writed a Haskell project which take Gaussian Input files (.gjf) with PDB information
(avaliable as option in GausView 6.0) like this:

```
%nprocshared=56
%mem=10GB
# opt pm6 geom=connectivity

Title Card Required

0 1
 H(PDBName=H5',ResName=DA,ResNum=1_A)                 0  -10.03800000   -1.70400000   -1.56300000 L
 O(PDBName=O5',ResName=DA,ResNum=1_A)                 0   -9.22900000   -1.73000000   -1.04200000 L
 C(PDBName=C5',ResName=DA,ResNum=1_A)                 0   -9.24700000   -2.87600000   -0.20600000 L
 H(PDBName=H5',ResName=DA,ResNum=1_A)                0  -10.08000000   -2.79600000    0.49300000 L
 H(PDBName=H5'',ResName=DA,ResNum=1_A)                0   -9.38700000   -3.77200000   -0.81400000 L
 C(PDBName=C4',ResName=DA,ResNum=1_A)                 0   -7.94200000   -3.02700000    0.59200000 L
....
```

and convert it in something like this:

```
%nprocshared=56
%mem=10GB
# opt pm6 geom=connectivity

Title Card Required

0 1
H-H5'-0.075400                 0  -10.03800000   -1.70400000   -1.56300000 L
O-O5'--0.495400                 0   -9.22900000   -1.73000000   -1.04200000 L
C-C5'--0.006900                 0   -9.24700000   -2.87600000   -0.20600000 L
H-H5'-0.075400                0  -10.08000000   -2.79600000    0.49300000 L
H-H5''-0.075400                0   -9.38700000   -3.77200000   -0.81400000 L
C-C4'-0.162900                 0   -7.94200000   -3.02700000    0.59200000 L
```

As You can see script touches only strings with keywords "PDBName=" and does nothing with others.
Moreower if script cann't find apropriate replacement in the FF-library - corresponding string willn't be
replaced. You should manualy check notation of these atoms, make the corrections and feed input file again.

## Usage

Windows users:

1. Place GaussianConverter.exe in folder with force field library file (.lib) and .gjf files, formatted as above.
2. Launch PowerShell in the same folder and write ./GaussianConverter.exe -ff {ffLibName.lib}
3. If everything OK you will be asked to input filename or type All. In the second variant (All) converter will processed
all .gjf files in current directory.
4. Find files converted_{filename.gjf} and check their content.
5. Good luck in your further work.

Other platform users:

I haven't tested it yet on Linux platform, please try to perform the same steps as Windows user. 
